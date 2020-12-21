require 'time'

require_relative './color'
require_relative './ray'

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
        # Defining canvas coordinate plane
        # 
        # u: canvas horizontal
        # v: canvas vertical
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
    oc           = ray.origin - center
    a            = ray.direction.length_squared
    half_b       = oc.dot(ray.direction)
    c            = oc.length_squared - radius**2
    discriminant = half_b**2 - a * c
    
    if discriminant < 0
      -1 # can't do anything with imaginary numbers
    else
      (-half_b - Math.sqrt(discriminant)) / a
    end
  end

  def ray_direction(u, v)
    h_offset = camera.horizontal * u
    v_offset = camera.vertical * v

    camera.lower_left + h_offset + v_offset - camera.origin
  end

  def ray_color(ray)
    t = hit_sphere(Point.new(0, 0, -1), 0.5, ray)

    if t > 0
      n = ray.at(t).unit_vector - Vector3D.new(0, 0, -1)

      return ( Color.new(n.x + 1, n.y + 1, n.z + 1) * 0.5 ).to_color
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
