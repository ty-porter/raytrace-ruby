require './camera'
require './image'
require './point'
require './vector3d'

# Image
ASPECT_RATIO = 16.0 / 9.0
IMAGE_WIDTH  = 400
IMAGE_HEIGHT = (IMAGE_WIDTH / ASPECT_RATIO).to_i

# Viewport
VIEWPORT_HEIGHT = 2.0
VIEWPORT_WIDTH  = ASPECT_RATIO * VIEWPORT_HEIGHT

# Rendering
camera = Camera.new(VIEWPORT_WIDTH, VIEWPORT_HEIGHT)
image = Image.new(IMAGE_WIDTH, IMAGE_HEIGHT, camera)
image.render
