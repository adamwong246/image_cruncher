# http://snipplr.com/view/62442/

require 'tilt'
require 'haml'
require 'debugger'

class ImageCruncher
  VERSION = "1.0.0"

  def self.crunch(src, number_of_colors )
    Magick::ImageList.new(src)
    .quantize(number_of_colors, Magick::RGBColorspace)
    .color_histogram
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

  def self.crunch_pretty(src, number_of_colors)
    crunch(src, number_of_colors).map {|a| 
      {
        color: a[:color].to_color(Magick::AllCompliance, false, 8, true), 
        predominance: a[:predominance]
      } 
    }
  end

  def self.generate_profile(src, number_of_colors)    
    template_file = "../src/profile.html.haml"
    file_name_output = "#{File.basename(src, ".*" )}_#{File.basename(template_file, ".*" )}"
    copied_image = File.basename(src)

    template = Tilt.new(template_file)
    output_string = template.render (
      {
        title:        file_name_output,
        source_image: copied_image,
        colors:       crunch_pretty(src, number_of_colors)        
      }
    )    

    puts "... #{file_name_output}"
    File.open(file_name_output, 'w') { |f| f.puts(output_string) }

    FileUtils.cp src, copied_image
                   
  end
end
