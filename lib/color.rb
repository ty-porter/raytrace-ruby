# frozen_string_literal: true

require_relative './vector3d.rb'

# RGB color container
#
# Params:
#  r -> x (Float), defaults to 0.0
#  g -> y (Float), defaults to 0.0
#  b -> z (Float), defaults to 0.0
#
# Aliases r, g, b -> x, y, z on inheritance from base Vector3D class
# Default color is BLACK (0.0, 0.0, 0.0)
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

  def self.black
    Color.new(0.0, 0.0, 0.0)
  end

  def self.white
    Color.new(1.0, 1.0, 1.0)
  end

  def self.red
    Color.new(1.0, 0.0, 0.0)
  end

  def self.green
    Color.new(0.0, 1.0, 0.0)
  end

  def self.blue
    Color.new(0.0, 0.0, 1.0)
  end
end
