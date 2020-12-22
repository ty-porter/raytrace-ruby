require_relative './point'
require_relative './vector3d'

class Camera
  def initialize(width, height, opts = {})
    @viewport_width  = width
    @viewport_height = height

    @origin       = opts[:origin]       || Point.new
    @horizontal   = opts[:horizontal]   || Vector3D.new(width, 0, 0)
    @vertical     = opts[:vertical]     || Vector3D.new(0, height, 0)
    @focal_length = opts[:focal_length] || 1.0
    @lower_left   = opts[:lower_left]   || default_lower_left
  end

  attr_reader \
    :viewport_width,
    :viewport_height,
    :origin,
    :horizontal,
    :vertical,
    :focal_length,
    :lower_left

  private

  def default_lower_left
    origin - horizontal / 2 - vertical / 2 - Vector3D.new(0, 0, focal_length)
  end
end
