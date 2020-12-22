# frozen_string_literal: true

# Storage for a 'hit' by a ray.
#
# Params:
#  point (Point)
#  normal (Vector3D)
#  t (Integer), time
class HitRecord
  # Struct for holding hit statistics
  #
  # In the C++ code, this was referred to as:
  #
  # struct hit_record {
  #   point3 p;
  #   vec3 normal;
  #   double t;
  # };
  #
  # Calling #hit? on a hittable sets its associated HitRecord values
  def initialize(point = nil, normal = nil, t = nil)
    @point      = point
    @normal     = normal
    @t          = t
    @front_face = false
  end

  attr_accessor \
    :front_face,
    :point,
    :normal,
    :t

  def set_face_normal(ray, outward_normal)
    @front_face = ray.direction.dot(outward_normal).negative?
    @normal = front_face ? outward_normal : outward_normal.inverse
  end
end

# Base class for a hittable object
#
# Params:
#  ray (Ray)
#  t_min (Integer)
#  t_max (Integer)
#  hit_record (HitRecord), defaults to HitRecord.new
class Hittable
  def initialize(ray, t_min, t_max, hit_record = HitRecord.new)
    @ray        = ray
    @t_min      = t_min
    @t_max      = t_max
    @hit_record = hit_record
  end

  attr_reader \
    :ray,
    :t_min,
    :t_max,
    :hit_record
end

# Storage for a list of hittables.
#
# Params:
#  None
#
# Use HittableList#add to add a Hittable
class HittableList
  def initialize
    @objects = []
  end

  attr_accessor :objects

  def add(object)
    objects << object
  end

  def clear
    @objects = []
  end

  def hit?(ray, t_min, t_max, hit_record)
    temp_record  = HitRecord.new
    hit_anything = false
    closest      = t_max

    objects.each do |object|
      next unless object.hit?(ray, t_min, t_max, hit_record)

      hit_anything = true
      closest      = temp_record.t
      hit_record   = temp_record
    end

    hit_anything
  end
end
