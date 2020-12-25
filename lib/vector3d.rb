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
    @x = x.to_f
    @y = y.to_f
    @z = z.to_f
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
    if other.is_a?(Vector3D)
      self.class.new(x * other.x,
                     y * other.y,
                     z * other.z)
    else
      self.class.new(x * other,
                     y * other,
                     z * other)
    end
  end

  def /(other)
    self * (1.to_f / other)
  end

  def -@
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

  def near_zero?
    # Return true if vector is close to zero in all dimensions
    s = 1e-8

    [x, y, z].all? { |dimension| dimension < s }
  end

  def reflect(normal)
    self - (normal * dot(normal)) * 2
  end

  # ================
  # The below methods are used in approximation of Lambertian diffuse
  # https://raytracing.github.io/books/RayTracingInOneWeekend.html#diffusematerials/analternativediffuseformulation
  # ================

  # Generate a unit vector from a random vector in the same hemisphere as the normal
  def self.random_in_hemisphere(normal)
    in_unit_sphere = Vector3D.random_in_unit_sphere

    in_unit_sphere.dot(normal) > 0.0 ? in_unit_sphere : -in_unit_sphere
  end

  # Generate a unit vector from a random vector in unit sphere
  def self.random_unit_vector
    Vector3D.random_in_unit_sphere.unit_vector
  end

  # Generate a random vector within a unit sphere
  def self.random_in_unit_sphere
    loop do
      vector = Vector3D.random(-1.0, 1.0)
      return vector if vector.length_squared < 1
    end
  end

  # Generate a random vector with min <= x,y,z < max
  #
  # Can take either min/max args or no args
  def self.random(*args)
    case args.reject(&:nil?).count
    when 0
      Vector3D.new(rand, rand, rand)
    when 2
      min, max = args.map(&:to_f)
      raise ArgumentError, 'Minimum must be less than maximum.' if min >= max

      Vector3D.new(rand(min..max), rand(min..max), rand(min..max))
    else
      raise ArgumentError, 'Exactly zero or two arguments required.'
    end
  end
end
