# frozen_string_literal: true

require_relative './hittable'
require_relative './materials/lambertian'

# A representation of a sphere
#
# Params:
#  center (Point)
#  radius (Float)
#  material (Material), defaults to Materials::Lambertian
class Sphere < Hittable
  def initialize(center, radius, material = Materials::Lambertian.new)
    @center   = center
    @radius   = radius
    @material = material
  end

  attr_reader :center, :radius, :material

  def hit?(ray, t_min, t_max, hit_record)
    oc           = ray.origin - center
    a            = ray.direction.length_squared
    half_b       = oc.dot(ray.direction)
    c            = oc.length_squared - radius**2
    discriminant = half_b**2 - a * c

    return false if discriminant.negative?

    sqrt_d = Math.sqrt(discriminant)

    # Find the nearest root in the acceptable range (t_min/t_max)
    root = (-half_b - sqrt_d) / a
    if root < t_min || t_max < root
      root = (-half_b + sqrt_d) / a

      return false if root < t_min || t_max < root
    end

    hit_record.t        = root
    hit_record.point    = ray.at(hit_record.t)
    hit_record.material = material

    outward_normal = (hit_record.point - center) / radius
    hit_record.set_face_normal(ray, outward_normal)

    true
  end
end
