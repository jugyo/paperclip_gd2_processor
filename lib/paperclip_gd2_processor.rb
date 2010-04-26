require 'gd2'

module GD2
  class Image
    def resize_and_crop!(w, h)
      w_rate = w / width.to_f
      h_rate = h / height.to_f
      if (1 - h_rate) > (1 - w_rate) # 縦方向の変化量の方が大きい場合
        #　横幅を基準にリサイズ
        resize!(w, height * w_rate)
        crop!(0, (height - h) / 2.0, w, h)
      else # 横方向の変化量の方が大きい場合
        #　縦幅を基準にリサイズ
        resize!(width * h_rate, h)
        crop!((width - w) / 2.0, 0, w, h)
      end
    end

    def resize_to_fit!(w, h)
      w_rate = w / width.to_f
      h_rate = h / height.to_f
      if (1 - h_rate) > (1 - w_rate) # 縦方向の変化量の方が大きい場合
        #　縦幅を基準にリサイズ
        resize!(width * h_rate, h)
      else # 横方向の変化量の方が大きい場合
        #　横幅を基準にリサイズ
        resize!(w, height * w_rate)
      end
    end

    def scale!(rate)
      resize!((width * rate).floor, (height * rate).floor)
    end
  end
end

module Paperclip
  class Gd2Thumbnail < Processor

    def initialize(file, options, attachment)
      super
      @geometry   = self.class.parse_geometry(options[:geometry])
      @crop       = options[:geometry][-1,1] == '#'
      @scale      = options[:geometry][-1,1] == '%'
      @file       = file
      @basename   = File.basename(@file.path)
      @format     = File.extname(attachment.path).sub(/^\./, '')
    end

    def make
      image = GD2::Image.import(@file.path, :format => @format)
      if @scale
        image.scale!(@geometry)
      elsif @crop
        image.resize_and_crop!(*@geometry)
      else
        image.resize_to_fit!(*@geometry)
      end
      dst = Tempfile.new(@basename)
      image.export(dst.path, :format => @format)
      dst
    end

    def self.parse_geometry(string)
      case string
      when /^([\.\d]+)x([\.\d]+)[\#]?$/i
        string.split(/x/i).map { |i| i.to_f }
      when /^([\.\d]+)%$/
        string[/[\.\d]+/].to_f / 100
      else
        raise ArgumentError, "invalid geometry: #{string}"
      end
    end
  end
end
