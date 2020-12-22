require 'time'

require_relative './color'
require_relative './ray'

class Image
  IMAGE_PATH = "images/image_#{Time.now.to_i}.ppm".freeze

  def initialize(width, height, camera, world)
    File.delete(IMAGE_PATH) if File.exist?(IMAGE_PATH)
    @width  = width
    @height = height
    @file   = nil
    @camera = camera
    @world  = world
  end

  attr_reader \
    :file,
    :width,
    :height,
    :camera,
    :world

  def render
    open
    write("P3\n#{width} #{height}\n255\n")

    (height - 1).downto(0).each do |y|
      print 'Percent complete: ' + percent_complete(y) + "%\r"

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

  def ray_direction(u, v)
    h_offset = camera.horizontal * u
    v_offset = camera.vertical * v

    camera.lower_left + h_offset + v_offset
  end

  def ray_color(ray)
    hit_record = HitRecord.new

    if world.hit?(ray, 0, Float::INFINITY, hit_record)
      # Original guide doesn't use a unit_vector call here
      #
      # However, it seems like it should? Otherwise, the output color would have values > 255
      # The below code averages the normal vector and the color white (255, 255, 255)
      vector = (hit_record.normal.unit_vector + Color.new(1.0, 1.0, 1.0)) * 0.5

      # Without using unit_vector, it's possible (likely) to get a vector with x/y/z > 1.0:
      #
      # normal = Vector3D.new(4.0, 4.0, 4.0)
      # color  = Color.new(   1.0, 1.0, 1.0)
      #
      # vector = (normal + color) * 0.5
      # => Vector3D(x: 2.0, y: 2.0, z: 2.0)
      #
      # vector.to_color.to_s
      # => "511 511 511"
      #
      # Max RGB is (255, 255, 255)
      return vector.to_color
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

  def percent_complete(val)
    percent = (height - val).to_f / height * 100
    percent.to_i.to_s
  end
end
