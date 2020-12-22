require_relative './point'
require_relative './vector3d'

class Camera
  def initialize(opts = {})
    @aspect_ratio = opts[:aspect_ratio] || 16.0 / 9.0
    @height       = opts[:height]       || 2.0
    @width        = opts[:width]        || aspect_ratio * height
    @origin       = opts[:origin]       || Point.new
    @horizontal   = opts[:horizontal]   || Vector3D.new(width, 0, 0)
    @vertical     = opts[:vertical]     || Vector3D.new(0, height, 0)
    @focal_length = opts[:focal_length] || 1.0
    @lower_left   = opts[:lower_left]   || default_lower_left
  end

  attr_reader \
    :aspect_ratio,
    :height,
    :width,
    :origin,
    :horizontal,
    :vertical,
    :focal_length,
    :lower_left

  def image_dimensions(image_width)
    # Returns dimensions in width x height
    [image_width, (image_width / aspect_ratio).to_i]
  end

  def get_ray(u, v)
    Ray.new(origin, ray_direction(u, v))
  end

  private

  def default_lower_left
    origin - horizontal / 2 - vertical / 2 - Vector3D.new(0, 0, focal_length)
  end

  def ray_direction(u, v)
    lower_left + horizontal * u + vertical * v
  end
end
