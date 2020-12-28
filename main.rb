# frozen_string_literal: true

require 'pry' # to pry the bugs out

require './lib/camera'
require './lib/image'
require './lib/hittable'
require './lib/point'
require './lib/sphere'
require './lib/vector3d'
require './lib/world'
require './lib/materials/lambertian'
require './lib/materials/dielectric'
require './lib/materials/metal'

# Image
IMAGE_WIDTH = 1200

# World
def random_scene
  # Set up the world
  world = World.new

  # Add the ground
  ground_material = Materials::Lambertian.new(Color.white * 0.5)
  ground_sphere   = Sphere.new(Point.new(0, -1000, 0), 1000, ground_material)
  world.add(ground_sphere)

  # Begin a loop
  (-11..11).each do |a|
    (-11..11).each do |b|
      material_probability = rand
      center = Point.new(a + 0.9 * rand, 0.2, b + 0.9 * rand)

      # Check it's not too far away
      next unless (center - Point.new(4, 0.2, 0)).length > 0.9

      # Make a material based on probability
      if material_probability < 0.8
        # Lambertian
        albedo   = Color.random * Color.random
        material = Materials::Lambertian.new(albedo)
      elsif material_probability < 0.95
        # Metal
        albedo   = Color.random(0.5, 1.0)
        fuzz     = rand(0.0..0.5)
        material = Materials::Metal.new(albedo, fuzz)
      else
        # Glass
        material = Materials::Dielectric.new(1.5)
      end

      # Add the sphere to the world
      sphere = Sphere.new(center, 0.2, material)
      world.add(sphere)
    end
  end

  # Let 'er rip!
  world
end

# Rendering
cam_from = Point.new(13, 3, 2)
cam_to   = Point.new(0, 0, 0)

camera = Camera.new(
  cam_from,
  cam_to,
  aspect_ratio: 3.0 / 2.0,
  vertical_fov: 20.0,
  aperture: 0.1,
  focus_dist: 10.0
)

width, height = camera.image_dimensions(IMAGE_WIDTH)
image = Image.new(width, height, camera, random_scene)
image.render
