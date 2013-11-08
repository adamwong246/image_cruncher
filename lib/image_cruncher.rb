# http://snipplr.com/view/62442/

class ImageCruncher
  VERSION = "1.0.0"

  def crunch(arg, number_of_colors=8)
    image = Magick::ImageList.new(src)
    colors = []
    q = image.quantize(7, Magick::RGBColorspace)
    palette = q.color_histogram.sort {|a, b| b[1] <=> a[1]}
 
    (0..6).each do |i|
        c = palette[i].to_s.split(',').map {|x| x[/\d+/]}
        c.pop
        c[0], c[1], c[2] = [c[0], c[1], c[2]].map { |s| 
            s = s.to_i
            if s / 255 > 0 # not all ImageMagicks are created equal....
                s = s / 255
            end
            s = s.to_s(16)
            if s.size == 1 
                '0' + s
            else
                s
            end
        }
        colors << '#' + c.join('')
    end
 
    return colors
  end

end
