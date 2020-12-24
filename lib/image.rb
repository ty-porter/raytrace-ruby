# frozen_string_literal: true

require 'time'

require_relative './color'
require_relative './ray'

require_relative './utils/utils'

# Contains all the frameworks to generate a rendering and write it to a file
#
# Params:
#   width (Integer), in px
#   height (Integer), in px
#   camera (Camera)
#   world (World, HittableList)
class Image
  include Utils

  IMAGE_PATH        = "images/image_#{Time.now.to_i}.ppm"
  SAMPLES_PER_PIXEL = 100
  MAX_DEPTH         = 50

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
        color = Color.new(0, 0, 0)
        (0..SAMPLES_PER_PIXEL - 1).each do |_s|
          # Defining canvas coordinate plane
          #
          # u: canvas horizontal
          # v: canvas vertical
          #
          # add rand to x/y for sampling & antialiasing
          u = (x.to_f + rand) / (width - 1)
          v = (y.to_f + rand) / (height - 1)

          ray = camera.get_ray(u, v)
          color += ray_color(ray)
        end
        write_sampled_color(color)
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

  def ray_color(ray, depth = MAX_DEPTH)
    hit_record = HitRecord.new

    # Return black if we've exceeded ray bounce limit, no more light gathered
    return Color.black if depth <= 0

    if world.hit?(ray, 0.001, Float::INFINITY, hit_record)
      target = hit_record.point + Vector3D.random_in_hemisphere(hit_record.normal)

      return ray_color(Ray.new(hit_record.point, target - hit_record.point), depth - 1) * 0.5
    end

    t = 0.5 * (ray.unit_vector.y + 1.0)

    Color.new(1.0, 1.0, 1.0) * (1.0 - t) + Color.new(0.5, 0.7, 1.0) * t
  end

  def write(data)
    file.write(data)
  end

  def write_sampled_color(color)
    scale      = 1.0 / SAMPLES_PER_PIXEL
    scaled_rgb = (color * scale).rgb
    scaled_rgb.map do |value|
      # Math.sqrt is equivalent to gamma = 2.0 here
      clamp(Math.sqrt(value), 0.0, 0.999)
    end

    scaled_color = Color.new(*scaled_rgb)

    file.write(scaled_color.to_s)
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
