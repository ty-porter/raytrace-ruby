module Materials
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
