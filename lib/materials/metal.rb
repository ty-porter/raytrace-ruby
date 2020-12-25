require_relative './base_material'
require_relative '../ray'

module Materials
  class Metal < BaseMaterial
    def scatter?(ray_in, hit_record)
      reflected    = ray_in.unit_vector.reflect(hit_record.normal)
      @scattered   = Ray.new(hit_record.point, reflected)
      @attenuation = albedo

      @scattered.direction.dot(hit_record.normal).positive?
    end
  end
end
