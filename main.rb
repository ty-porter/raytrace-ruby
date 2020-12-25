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
require './lib/materials/metal'

# Image
IMAGE_WIDTH = 400

# World
world = World.new

middle = Sphere.new(
  Point.new(0.0, 0.0, -1.0),
  0.5,
  Materials::Lambertian.new(
    Color.new(0.7, 0.3, 0.3)
  )
)
left = Sphere.new(
  Point.new(-1.0, 0.0, -1.0),
  0.5,
  Materials::Metal.new(
    Color.new(0.8, 0.8, 0.8)
  )
)

right = Sphere.new(
  Point.new(1.0, 0.0, -1.0),
  0.5,
  Materials::Metal.new(
    Color.new(0.8, 0.6, 0.2)
  )
)

ground = Sphere.new(
  Point.new(0.0, -100.5, -1.0),
  100.0,
  Materials::Lambertian.new(
    Color.new(0.8, 0.8, 0.0)
  )
)

spheres = [
  # Order is important, rendered from front -> back
  middle,
  left,
  right,
  ground
]

spheres.each { |sphere| world.add(sphere) }

# Rendering
camera = Camera.new
width, height = camera.image_dimensions(400)
image = Image.new(width, height, camera, world)
image.render
