# frozen_string_literal: true

require_relative 'lib/camera'
require_relative 'lib/image'
require_relative 'lib/hittable'
require_relative 'lib/point'
require_relative 'lib/sphere'
require_relative 'lib/vector3d'
require_relative 'lib/world'
require_relative 'lib/materials/lambertian'
require_relative 'lib/materials/dielectric'
require_relative 'lib/materials/metal'

# Image
IMAGE_WIDTH = 400

# World
def random_scene
  # Set up the world
  world = World.new

  # Add the three basic spheres
  left_material = Materials::Lambertian.new(Color.new(0.4, 0.2, 0.1))
  left_sphere   = Sphere.new(Point.new(-4.0, 1.0, 0.0), 1.0, left_material)

  center_material   = Materials::Dielectric.new(1.5)
  center_sphere     = Sphere.new(Point.new(0.0, 1.0, 0.0), 1.0, center_material)

  right_material  = Materials::Metal.new(Color.new(0.7, 0.6, 0.5))
  right_sphere    = Sphere.new(Point.new(4.0, 1.0, 0.0), 1.0, right_material)

  [left_sphere, center_sphere, right_sphere].each { |sphere| world.add(sphere) }

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

  # Add the ground
  ground_material = Materials::Lambertian.new(Color.white * 0.5)
  ground_sphere   = Sphere.new(Point.new(0, -1000, 0), 1000, ground_material)
  world.add(ground_sphere)

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
