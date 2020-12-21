require './image'
require './vector3d'
require './color'

# Constants
ASPECT_RATIO = 16.0 / 9.0
IMAGE_WIDTH  = 400;
IMAGE_HEIGHT = (IMAGE_WIDTH / ASPECT_RATIO).to_i;

# Rendering
def percent_done(val)
  percent = (IMAGE_HEIGHT - val).to_f / IMAGE_HEIGHT * 100
  percent.to_i.to_s
end

# def open_file
#   File.open(IMAGE, 'a')
# end

# def write_to_file(file, data)
#   file.write(data)
# end

# File.delete(IMAGE) if File.exist?(IMAGE)

# file = open_file

# write_to_file(file, "P3\n" + IMAGE_WIDTH.to_s + " " + IMAGE_HEIGHT.to_s + "\n255\n")

# def generate_image(file)
#   (IMAGE_HEIGHT - 1).downto(0).each do |y|
#     print "Percent complete: " + percent_done(y) + "%\r"
  
#     (0..IMAGE_WIDTH - 1).each do |x|
#       r = x.to_f / (IMAGE_WIDTH - 1)
#       g = y.to_f / (IMAGE_HEIGHT - 1)
#       b = 0.25
  
#       color = Color.new(r, g, b)
  
#       write_to_file(file, color.to_s)
#     end
#   end
# end

# generate_image(file)
# file.close

image = Image.new(IMAGE_WIDTH, IMAGE_HEIGHT)
image.generate_image



