# http://snipplr.com/view/62442/

require 'tilt'
require 'haml'
require 'debugger'

class ImageCruncher
  VERSION = "1.0.0"

  def self.quantize(src, number_of_colors)
    Magick::ImageList.new(src)
    .quantize(number_of_colors, Magick::RGBColorspace)
  end

  def self.extract_colors(image)
    image.color_histogram
    .map{|a| 
      {
        color: a[0],
        predominance: a[1]
      }    
    }
    .sort {|a, b| 
      b[:predominance] <=> a[:predominance]
    }
  end

  def self.crunch(src, number_of_colors )
    extract_colors(quantize(src, number_of_colors))    
  end

  def self.crunch_pretty(src, number_of_colors)
    crunch(src, number_of_colors).map {|a| 
      {
        color: a[:color].to_color(Magick::AllCompliance, false, 8, true), 
        predominance: a[:predominance]
      } 
    }
  end

  def self.generate_profile(src, number_of_colors)    
    template_file_path         = "../src/profile.html.haml"
    output_file_path           = "#{File.basename(src, ".*" )}_#{File.basename(template_file_path, ".*" )}"
    copied_image_file_path     = File.basename(src)
    quantized_image_file_path  = "quantized_#{File.basename(src)}"

    quantized_image = quantize(src, number_of_colors)

    output = Tilt.new(template_file_path).render (
      {
        title:           output_file_path,
        source_image:    copied_image_file_path,
        quantized_image: quantized_image_file_path,
        colors:          extract_colors(quantized_image).map {|a| 
          {
            color: a[:color].to_color(Magick::AllCompliance, false, 8, true), 
            predominance: a[:predominance]
          }        
        }
      }
    )    

    puts "... #{output_file_path}"
    File.open(output_file_path, 'w') { |f| f.puts(output) }

    FileUtils.cp src, copied_image_file_path
    quantized_image.write(quantized_image_file_path)
                   
  end
end
