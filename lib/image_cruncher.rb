# http://snipplr.com/view/62442/

class ImageCruncher
  VERSION = "1.0.0"

  def crunch(src, number_of_colors=8)
    image = Magick::ImageList.new(src)
    colors = []
    q = image.quantize(number_of_colors, Magick::RGBColorspace)
    q.color_histogram.sort {|a, b| b[1] <=> a[1]}
 
    
  end

end
