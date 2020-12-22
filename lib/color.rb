require_relative './vector3d.rb'

class Color < Vector3D
  MAX = 255.999

  alias r x
  alias g y
  alias b z

  def to_s
    rgb.map { |v| (v * MAX).to_i.to_s }.join(' ') + "\n"
  end

  def rgb
    [r, g, b]
  end
end
