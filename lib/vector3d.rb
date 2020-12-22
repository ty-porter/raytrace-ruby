# frozen_string_literal: true

# A vector, contains all operations (+-*/) as well as dot and cross products
# Classes that have a representation in 3D space inherit from Vector3D
#
# Params:
#  x (Float), defaults to 0.0
#  y (Float), defaults to 0.0
#  z (Float), defaults to 0.0
class Vector3D
  def initialize(x = 0.0, y = 0.0, z = 0.0)
    @x = x
    @y = y
    @z = z
  end

  attr_reader :x, :y, :z

  def +(other)
    self.class.new(x + other.x,
                   y + other.y,
                   z + other.z)
  end

  def -(other)
    self.class.new(x - other.x,
                   y - other.y,
                   z - other.z)
  end

  def *(other)
    self.class.new(x * other,
                   y * other,
                   z * other)
  end

  def /(other)
    self * (1.to_f / other)
  end

  def inverse
    self.class.new(-x, -y, -z)
  end

  def length
    Math.sqrt(length_squared)
  end

  def length_squared
    x**2 + y**2 + z**2
  end

  def to_s
    "#{x} #{y} #{z}"
  end

  def dot(other)
    (x * other.x) + (y * other.y) + (z * other.z)
  end

  def cross(other)
    self.class.new(y * other.z - z * other.y,
                   z * other.x - x * other.z,
                   x * other.y - y * other.x)
  end

  def unit_vector
    self / length
  end

  def to_color
    Color.new(x, y, z)
  end
end
