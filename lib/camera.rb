# frozen_string_literal: true

require_relative 'point'
require_relative 'vector3d'
require_relative 'utils/utils'

# Camera class for viewing the world.
#
# Params:
#  look_from (Point)
#  look_at (Point)
#  opts (Hash), defaults to {}
#
# Valid options are:
#   :v_up
#   :vertical_fov
#   :aspect_ratio
#   :height
#   :width
#   :focal_length
#   :aperture
#   :focus_dist
#
# Options are defaulted unless explicitly passed to the options hash
# See below for defaults:
class Camera
  include Utils

  def initialize(look_from, look_at, opts = {})
    @look_from    = look_from
    @look_at      = look_at

    @v_up         = opts[:v_up]         || Vector3D.new(0, 1, 0) # world up
    @vertical_fov = opts[:vertical_fov] || 90.0 # degrees
    @aspect_ratio = opts[:aspect_ratio] || 16.0 / 9.0
    @height       = opts[:height]       || 2.0 * Math.tan(theta / 2.0)
    @width        = opts[:width]        || aspect_ratio * height
    @focal_length = opts[:focal_length] || 1.0
    @aperture     = opts[:aperture]     || 0.0
    @focus_dist   = opts[:focus_dist]   || 1.0

    set_coordinate_instance_vars # Set w, u, v
  end

  attr_reader \
    :look_from,
    :look_at,
    :v_up,
    :vertical_fov,
    :aspect_ratio,
    :height,
    :width,
    :focal_length,
    :aperture,
    :focus_dist,
    :w,
    :u,
    :v

  def image_dimensions(image_width)
    # Returns dimensions in width x height
    [image_width, (image_width / aspect_ratio).to_i]
  end

  def get_ray(s, t)
    offset_vector = Vector3D.random_in_unit_disk * lens_radius
    offset        = u * offset_vector.x + v * offset_vector.y

    Ray.new(origin + offset, ray_direction(s, t, offset))
  end

  private

  def ray_direction(s, t, offset = nil)
    direction = lower_left + horizontal * s + vertical * t - origin
    return direction if offset.nil?

    direction - offset
  end

  def set_coordinate_instance_vars
    @w = (look_from - look_at).unit_vector
    @u = v_up.cross(w).unit_vector
    @v = w.cross(u)
  end

  def origin
    look_from
  end

  def horizontal
    u * width * focus_dist
  end

  def vertical
    v * height * focus_dist
  end

  def lower_left
    origin - (horizontal / 2.0) - (vertical / 2.0) - (w * focus_dist)
  end

  def lens_radius
    aperture / 2.0
  end

  def theta
    degrees_to_radians(vertical_fov)
  end
end
