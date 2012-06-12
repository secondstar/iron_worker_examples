require 'open-uri'
require 'RMagick'

require 'aws'
require 'subexec'
require 'mini_magick'

#
# A sampling of image transformations and effects
# Most of the operations use mini_magick but a few use RMagick.
#

def resize_image(filename, width=nil, height=nil, format='jpg')
  image = MiniMagick::Image.open(filename)
  original_width, original_height = image[:width], image[:height]
  width ||= original_width
  height ||= original_height
  output_filename = "#{filename}_thumbnail_#{width}_#{height}.#{format}"
  image.resize "#{width}x#{height}"
  image.format format
  image.write output_filename
  output_filename
end

def generate_thumb(filename, width=nil, height=nil, format='jpg')
  output_filename = "#{filename}_thumbnail_#{width}_#{height}.#{format}"
  image = MiniMagick::Image.open(filename)
  image.combine_options do |c|
    c.thumbnail "#{width}x#{height}"
    c.background 'white'
    c.extent "#{width}x#{height}"
    c.gravity "center"
  end
  image.format format
  image.write output_filename
  output_filename
end

def normalize_image(filename, format='jpg')
  output_filename = "#{filename}_normalized.#{format}"
  image = MiniMagick::Image.open(filename)
  image.normalize
  image.format format
  image.write output_filename
  output_filename
end

def sketch_image(filename, format='jpg')
  output_filename = "#{filename}_sketch.#{format}"
  image = MiniMagick::Image.open(filename)
  image.combine_options do |c|
    c.edge "1"
    c.negate
    c.normalize
    c.colorspace "Gray"
    c.blur "0x.5"
  end
  image.format format
  image.write output_filename
  output_filename
end

def level_image(filename, black_point, white_point, gamma, format='jpg')
  output_filename = "#{filename}_level.#{format}"
  image = MiniMagick::Image.open(filename)
  image.level " #{black_point},#{white_point},#{gamma}"
  image.format format
  image.write output_filename
  output_filename
end

def charcoal_sketch_image(filename, format='jpg')
  output_filename = "#{filename}_charcoal_sketch.#{format}"
  image = MiniMagick::Image.open(filename)
  image.charcoal '1'
  image.format format
  image.write output_filename
  output_filename
end

# Here we're using RMagick for the polaroid and watermark capabilities
def polaroid_image(filename, format='jpg')
  output_filename = "#{filename}_polaroid.#{format}"
  image = Magick::Image.read(filename).first

#  There's a polaroid method
#     image = image.polaroid
#
#  But this example makes use of individual adjustments (taken from
#  the following article).
#  http://rmagick.rubyforge.org/Polaroid/polaroid.html
#

  image.border!(18, 18, "#f0f0ff")

# Bend the image
  image.background_color = "none"

  amplitude = image.columns * 0.01        # vary according to taste
  wavelength = image.rows  * 2

  image.rotate!(90)
  image = image.wave(amplitude, wavelength)
  image.rotate!(-90)

# Make the shadow
  shadow = image.flop
  shadow = shadow.colorize(1, 1, 1, "gray75")     # shadow color can vary to taste
  shadow.background_color = "white"       # was "none"
  shadow.border!(10, 10, "white")
  shadow = shadow.blur_image(0, 3)        # shadow blurriness can vary according to taste

# Composite image over shadow. The y-axis adjustment can vary according to taste.
  image = shadow.composite(image, -amplitude/2, 5, Magick::OverCompositeOp)

  image.rotate!(-5)                       # vary according to taste
  image.trim!

  image.write output_filename
  output_filename
end

def watermark_image(filename, text, format='jpg')
  output_filename = "#{filename}_watermark.#{format}"
  image = Magick::Image.read(filename).first

  mark = Magick::Image.new(200, 40) do
    self.background_color = 'none'
  end
  gc = Magick::Draw.new
  gc.annotate(mark, 0, 0, 0, 0, text) do
    self.gravity = Magick::CenterGravity
    self.pointsize = 20
    self.font_family = "Times"
    self.fill = "Gainsboro"
    self.stroke = "none"
  end
  mark.rotate!(-90)

  image = image.watermark(mark, 0.15, 0, Magick::EastGravity)
  image.write output_filename
  output_filename
end


def tile_image(filename, num_tiles_width, num_tiles_height)
  file_list=[]
  image = MiniMagick::Image.open(filename)
  original_width, original_height = image[:width], image[:height]
  slice_width = original_width / num_tiles_width
  slice_height = original_height / num_tiles_height
  i = 0
  num_tiles_height.times do |slice_h|
    num_tiles_width.times do |slice_w|
      output_filename = "filename_#{slice_w}_#{slice_h}.jpg"
      image = MiniMagick::Image.open(filename)
      image.crop "#{slice_width}x#{slice_height}+#{slice_w*slice_width}+#{slice_h*slice_height}"
      image.write output_filename
      file_list[i] = output_filename
      i += 1
    end
  end
  file_list
end

# Uses RMagick and ImageList
def append_images(filename, file_list, vertical_flag=false, file_suffix=nil, format='jpg')
  output_filename = "#{filename}#{file_suffix}.#{format}"
  ilg = Magick::ImageList.new
  file_list.each { |file|
    ilg.push(Magick::Image.read(file).first)
  }
  ilg.append(vertical_flag).write(output_filename)
  output_filename
end

def retile_images(filename, file_list, row_num, col_num)
  output_filename = "#{filename}_retile_#{row_num}x#{col_num}"
  tiles = []
  row_num.times do |row|
    tiles.push(append_images(output_filename,
                             file_list[row*col_num,col_num],
                             false,
                             "_"+row.to_s))
  end
  output_filename = append_images(output_filename, tiles, true)
  output_filename
end

def upload_file(filename)
  filepath = filename
  puts "\nUploading file to s3..."
  s3 = Aws::S3Interface.new(@params['aws_access'], @params['aws_secret'])
  s3.create_bucket(@params['aws_s3_bucket_name'])
  response = s3.put(@params['aws_s3_bucket_name'], filename, File.open(filepath))
  if response == true
    puts "Uploading successful."
    link = s3.get_link(@params['aws_s3_bucket_name'], filename)
    puts "\nYou can view the file here:",link
  else
    puts "Error placing the file in s3."
  end
  puts "\n"+"-"*60
end

def download_image
  filename = 'ironman.jpg'
  filepath = filename
  File.open(filepath, 'wb') do |fout|
    open(@params['image_url']) do |fin|
      IO.copy_stream(fin, fout)
    end
  end
  filename
end

@params = params

puts "Downloading image"

filename = download_image()

puts "\nOriginal image:"
upload_file(filename)

puts "\nGenerating mid-sized picture..."
processed_filename = resize_image(filename, nil, 200)
upload_file(processed_filename)

puts "\nGenerating small picture..."
processed_filename = resize_image(filename, nil, 100)
upload_file(processed_filename)

puts "\nGenerating square thumbnail..."
processed_filename = generate_thumb(filename, 75, 75)
upload_file(processed_filename)

puts "\nGenerating normalized picture..."
processed_filename = normalize_image(filename)
upload_file(processed_filename)

puts "\nGenerating picture with tuned levels..."
processed_filename = level_image(filename, 10, 250, 1.0)
upload_file(processed_filename)

puts "\nGenerating sketch_image.."
processed_filename = sketch_image(filename)
upload_file(processed_filename)

puts "\nGenerating charcoal_sketch..."
processed_filename = charcoal_sketch_image(filename)
upload_file(processed_filename)

puts "\nGenerating a polaroid look..."
processed_filename = polaroid_image(filename)
upload_file(processed_filename)

puts "\nPutting a watermark in..."
processed_filename = watermark_image(filename, "Powered by Iron.io")
upload_file(processed_filename)

puts "\nTiling image into 1x9..."
file_list = tile_image(filename, 3, 3)
processed_filename = retile_images(filename, file_list, 1, 9)
upload_file(processed_filename)

puts "\nRandomizing the order and retiling into 3x3..."
processed_filename = retile_images(filename, file_list.shuffle, 3, 3)
upload_file(processed_filename)
