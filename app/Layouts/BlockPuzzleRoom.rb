module LD20
  class BlockPuzzleRoom < RoomLayout
    @available_layouts = %w{empty_room}
    def munge_layout_data!(data)
      data.gsub!(/./,'.')
      place_walls(data,@puzzle.solution,0,0)
    end
    
    def parse_layout_data(data)
      super
      place_blocks(data,@puzzle.all_blocks,10,0)
    end

    def setup
      @puzzle = @room.room_data[:puzzle]
      unless @puzzle
        @puzzle = BlockPushPuzzleLayout.new
        @room.room_data[:puzzle] = @puzzle
      end
    end

    def solution
      @puzzle.solution
    end
    
    def populate(*args)
    end
    
    def adjust_tile(x,y,char)
      unless char == 'P'
        super
      end
    end
    
    def place_walls(data,blocks,top_x,top_y)
      blocks.each do |block|
        x, y = block
        x += top_x
        y += top_y
        index = x + y * (MapTilesWide + 1)
        data[index] = 'W'
      end
    end
    
    def place_blocks(data,blocks,top_x,top_y)
      blocks.each do |block|
        x, y = block
        x += top_x
        y += top_y
        index = x + y * (MapTilesWide + 1)
        data[index] = 'P'
        Prop::PushableBlock.place(x: x+2, y: y+2, puzzle_pos: block)
      end
    end
    
  end
end
