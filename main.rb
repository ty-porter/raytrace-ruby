# frozen_string_literal: true

require 'pry' # to pry the bugs out

require './lib/camera'
require './lib/image'
require './lib/hittable'
require './lib/point'
require './lib/sphere'
require './lib/vector3d'
require './lib/world'

# Image
IMAGE_WIDTH = 400

# World
world = World.new
world.add(
  Sphere.new(
    Point.new(0, 0, -1),
    0.5
  )
)
world.add(
  Sphere.new(
    Point.new(0, -100.5, -1),
    100
  )
)

# Rendering
camera = Camera.new
width, height = camera.image_dimensions(400)
image = Image.new(width, height, camera, world)
image.render
