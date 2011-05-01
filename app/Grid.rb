module LD20
  class Grid
    include Enumerable
    attr_reader :width, :height
    
    def initialize(width,height)
      @width, @height = width, height
      @spaces = Array.new(@width) {Array.new(@height)}
    end
    
    def [](x,y)
      if (0...@width).include?(x) and (0...@height).include?(y)
        return @spaces[x][y]
      else
        return OutOfBounds
      end
    end
    
    def []=(x,y,val)
      if (0...@width).include?(x) and (0...@height).include?(y)
        @spaces[x][y] = val
      end
    end
    
    def each
      @spaces.each do |col|
        col.each do |obj|
          yield obj
        end
      end
    end
    
    def each_with_coords
      if block_given?
        @spaces.each_with_index do |col,x|
          col.each_with_index do |obj,y|
            yield obj, x, y
          end
        end
      else
        return Enumerator.new(self,:each_with_coords)
      end
    end
    
    
  end
end