require 'time'
require 'pry'

require './color'
require './ray'

class Image
  IMAGE_PATH = "images/image_#{Time.now.to_i}.ppm".freeze

  def initialize(width, height, camera)
    File.delete(IMAGE_PATH) if File.exist?(IMAGE_PATH)
    @width = width
    @height = height
    @file = nil
    @camera = camera
  end

  attr_reader \
    :file,
    :width,
    :height,
    :camera

  def render
    open
    write("P3\n#{width} #{height}\n255\n")

    (height - 1).downto(0).each do |y|
      print 'Percent complete: ' + percent_done(y) + "%\r"

      (0..width - 1).each do |x|
        u = x.to_f / (width - 1)
        v = y.to_f / (height - 1)

        direction = ray_direction(u, v)
        ray = Ray.new(camera.origin, direction)

        color = ray_color(ray)

        write(color.to_s)
      end
    end

    print "Done.                  \n" # Weird hack to get proper newline on WSL
  ensure
    close
  end

  private

  def hit_sphere(center, radius, ray)
    oc = ray.origin - center
    a  = ray.direction.dot(ray.direction)
    b  = oc.dot(ray.direction) * 2.0
    c  = oc.dot(oc) - (radius * radius)

    # Quadratic equation
    discriminant = (b * b) - (4 * a * c)
    # binding.pry if discriminant < 0
    discriminant > 0
  end

  def ray_direction(u, v)
    h_offset = camera.horizontal * u
    v_offset = camera.vertical * v

    camera.lower_left + h_offset + v_offset - camera.origin
  end

  def ray_color(ray)
    # Hard-coding this for now...
    if hit_sphere(Point.new(0, 0, -1), 0.5, ray)
      return Color.new(1, 0, 0)
    end

    t = 0.5 * (ray.unit_vector.y + 1.0)

    vector = Color.new(1.0, 1.0, 1.0) * (1.0 - t) + Color.new(0.5, 0.7, 1.0) * t
    vector.to_color
  end

  def write(data)
    file.write(data)
  end

  def open
    @file = File.open(IMAGE_PATH, 'a')
  end

  def close
    file.close
  end

  def percent_done(val)
    percent = (IMAGE_HEIGHT - val).to_f / IMAGE_HEIGHT * 100
    percent.to_i.to_s
  end
end
