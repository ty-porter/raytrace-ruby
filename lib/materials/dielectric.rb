# frozen_string_literal: true

require_relative 'base_material'
require_relative '../color'
require_relative '../ray'

module Materials
  # Dielectric material model for highly refractive surfaces (i.e. glass)
  #
  # Params:
  #   index_of_refraction (Float)
  #
  # Inherits from Materials::BaseMaterial
  class Dielectric < BaseMaterial
    def initialize(index_of_refraction)
      super(0.0) # BaseMaterial requires albedo parameter, Dielectric does not
      @index_of_refraction = index_of_refraction.to_f
    end

    attr_reader :index_of_refraction

    def scatter?(ray_in, hit_record)
      refraction_ratio = hit_record.front_face ? (1.0 / index_of_refraction) : index_of_refraction

      cos_theta        = [(-ray_in.unit_vector).dot(hit_record.normal), 1.0].min
      sin_theta        = Math.sqrt(1.0 - cos_theta**2)

      # Check if the ray can be refracted at all or if material should randomly reflect
      cannot_refract = refraction_ratio * sin_theta > 1.0
      random_reflect = reflectance(cos_theta, refraction_ratio) > rand

      direction = if cannot_refract || random_reflect
                    # Must reflect
                    reflect(ray_in.unit_vector, hit_record.normal)
                  else
                    # Can refract
                    refract(ray_in.unit_vector, hit_record.normal, refraction_ratio)
                  end

      @scattered       = Ray.new(hit_record.point, direction)
      @attenuation     = Color.white # Absorb nothing

      true
    end
  end
end
