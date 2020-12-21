require 'time'

class Image
  IMAGE_PATH = "image_#{Time.now.to_i}.ppm"

  def initialize(width, height)
    File.delete(IMAGE_PATH) if File.exist?(IMAGE_PATH)
    @width = width
    @height = height
    @file = nil
  end

  attr_reader :file, :width, :height

  def generate_image
    open
    write("P3\n#{width} #{height}\n255\n")

    (IMAGE_HEIGHT - 1).downto(0).each do |y|
      print "Percent complete: " + percent_done(y) + "%\r"
    
      (0..IMAGE_WIDTH - 1).each do |x|
        r = x.to_f / (IMAGE_WIDTH - 1)
        g = y.to_f / (IMAGE_HEIGHT - 1)
        b = 0.25
    
        color = Color.new(r, g, b)
    
        write(color.to_s)
      end
    end

    print "Done.                  \n" # Weird hack to get proper newline on WSL
  ensure
    close
  end

  private

  def write(data)
    file.write(data)
  end

  def open
    @file = File.open(IMAGE_PATH, 'a')
  end

  def close
    file.close
  end
end