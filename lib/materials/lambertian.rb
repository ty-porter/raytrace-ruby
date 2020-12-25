require_relative './base_material'
require_relative '../ray'
require_relative '../vector3d'

module Materials
  class Lambertian < BaseMaterial
    def scatter?(_ray_in, hit_record)
      scatter_direction = hit_record.normal + Vector3D.random_unit_vector

      scatter_direction = hit_record.normal if scatter_direction.near_zero?

      @scattered        = Ray.new(hit_record.point, scatter_direction)
      @attenuation      = albedo

      true
    end
  end
end
