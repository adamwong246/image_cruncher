# http://snipplr.com/view/62442/

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


end
