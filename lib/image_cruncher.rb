# http://snipplr.com/view/62442/

class ImageCruncher
  VERSION = "1.0.0"

  def self.crunch(src, number_of_colors )
    Magick::ImageList.new(src)
    .quantize(number_of_colors, Magick::RGBColorspace)
    .color_histogram.sort {|a, b| b[1] <=> a[1]}     
  end

end
