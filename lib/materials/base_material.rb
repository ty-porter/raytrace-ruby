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
  end
end
