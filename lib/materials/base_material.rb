# frozen_string_literal: true

module Materials
  # Base materials class, provides storage for scattered rays and color attenuation
  #
  # Params:
  #   albedo (Color)
  class BaseMaterial
    def initialize(albedo)
      @albedo = albedo
    end

    attr_reader :albedo, :scattered, :attenuation

    def scatter?(*_args)
      raise NotImplementedError, 'Implement in child class.'
    end

    private

    def reflect(vector, normal)
      vector - (normal * vector.dot(normal)) * 2
    end

    def refract(vector, normal, etai_over_etat)
      cos_theta             = [(-vector).dot(normal), 1.0].min
      ray_out_perpendicular = (normal * cos_theta + vector) * etai_over_etat
      ray_out_parallel      = normal * -Math.sqrt((1.0 - ray_out_perpendicular.length_squared).abs)

      ray_out_perpendicular + ray_out_parallel
    end

    def reflectance(cosine, refractive_index)
      # Schlick's approxmation for reflectance
      r0 = (1.0 - refractive_index) / (1.0 + refractive_index)
      r0 **= 2

      r0 + (1.0 - r0) * (1.0 - cosine)**5
    end
  end
end
