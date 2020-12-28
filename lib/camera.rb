# frozen_string_literal: true

require_relative './point'
require_relative './vector3d'
require_relative './utils/utils'

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

    set_coordinate_instance_vars # Set w, u, v and derivatives
  end

  attr_reader \
    :look_from,
    :look_at,
    :v_up,
    :vertical_fov,
    :aspect_ratio,
    :height,
    :width,
    :origin,
    :horizontal,
    :vertical,
    :focal_length,
    :lower_left,
    :w,
    :u,
    :v

  def image_dimensions(image_width)
    # Returns dimensions in width x height
    [image_width, (image_width / aspect_ratio).to_i]
  end

  def get_ray(u, v)
    Ray.new(origin, ray_direction(u, v))
  end

  private

  def ray_direction(u, v)
    lower_left + horizontal * u + vertical * v - origin
  end

  def theta
    degrees_to_radians(vertical_fov)
  end

  def set_coordinate_instance_vars
    @w = (look_from - look_at).unit_vector
    @u = v_up.cross(w).unit_vector
    @v = w.cross(u)

    @origin     = look_from
    @horizontal = u * width
    @vertical   = v * height
    @lower_left = set_lower_left
  end

  def set_lower_left
    origin - (horizontal / 2.0) - (vertical / 2.0) - w
  end
end
