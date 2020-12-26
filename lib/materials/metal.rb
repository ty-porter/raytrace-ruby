# frozen_string_literal: true

require_relative './base_material'
require_relative '../ray'
require_relative '../vector3d'
require_relative '../utils/utils'

module Materials
  # Metal material model for highly reflective surfaces
  #
  # Params:
  #   albedo (Color)
  #   fuzz (Float), values between 0.0 -> 1.0
  #
  # Inherits from Materials::BaseMaterial
  class Metal < BaseMaterial
    include Utils

    def initialize(albedo, fuzz = 0.0)
      super(albedo)
      @fuzz = clamp(fuzz.to_f, 0.0, 1.0)
    end

    attr_reader :fuzz

    def scatter?(ray_in, hit_record)
      reflected    = reflect(ray_in.unit_vector, hit_record.normal)
      @scattered   = Ray.new(hit_record.point, reflected + Vector3D.random_in_unit_sphere * fuzz)
      @attenuation = albedo

      @scattered.direction.dot(hit_record.normal).positive?
    end
  end
end
