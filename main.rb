require 'pry' # to pry the bugs out

require './lib/camera'
require './lib/image'
require './lib/hittable'
require './lib/point'
require './lib/sphere'
require './lib/vector3d'
require './lib/world'

# Image
ASPECT_RATIO = 16.0 / 9.0
IMAGE_WIDTH  = 400
IMAGE_HEIGHT = (IMAGE_WIDTH / ASPECT_RATIO).to_i

# Viewport
VIEWPORT_HEIGHT = 2.0
VIEWPORT_WIDTH  = ASPECT_RATIO * VIEWPORT_HEIGHT

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
camera = Camera.new(VIEWPORT_WIDTH, VIEWPORT_HEIGHT)
image = Image.new(IMAGE_WIDTH, IMAGE_HEIGHT, camera, world)
image.render
