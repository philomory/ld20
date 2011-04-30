module LD20
  class TestState < Chingu::GameState
    def setup
      @grid = Grid.new(FullMapTilesWide, FullMapTilesHigh-1)
      @grid.each_with_coords {|i,x,y| @grid[x,y] = [:floor1, :floor2].sample }
      @images = {
        floor1: Image["floor1.png"],
        floor2: Image["floor2.png"]
      }
    end
    
    def draw
      @grid.each_with_coords do |type,x,y|
        i = @images[type]
        x_pos = x * TileWidth
        y_pos = y * TileHeight + 32
        i.draw(x_pos,y_pos,0)
      end
      Image["border.png"].draw(0,32,100)
    end
  end
end