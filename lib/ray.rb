# frozen_string_literal: true

# A ray in space (------>)
#
# Params:
#   origin (Point)
#   direction (Vector3D)
class Ray
  def initialize(origin, direction)
    @origin = origin
    @direction = direction
  end

  attr_reader :origin, :direction

  def at(value)
    origin + (direction * value)
  end

  def unit_vector
    direction.unit_vector
  end
end
