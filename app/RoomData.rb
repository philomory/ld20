module LD20
  module RoomData
    def load_room_data
      @room = $window.dungeon.dungeon_map[[@room_x,@room_y]]
      puts @room
      @terrain = Grid.new(FullMapTilesWide, FullMapTilesHigh)
      fill_floor
      place_walls
      handle_doors
    end
    
    def fill_floor
      @terrain.each_with_coords {|i,x,y| @terrain[x,y] = [Floor1, Floor2].sample }
    end
    
    def place_walls
      @terrain.each_with_coords do |i,x,y|
        if [0,1,18,19].include?(x) || [0,1,12,13].include?(y)
          @terrain[x,y] = Wall
        end
      end
    end
    
    def handle_doors
      [:n,:s,:e,:w].each do |dir|
        if (door = @room[:connected_rooms][dir])
          door_type = door[:type]
          remove_walls_in_direction(dir)
          switch_id = door[:switch_id]
          add_door(dir,door_type,switch_id)
        else
          add_door_cover(dir)
        end
      end
    end
    
    def remove_walls_in_direction(dir)
      coords = case dir
      when :n then [[9,10],[0,1]]
      when :s then [[9,10],[12,13]]
      when :e then [[18,19],[6,7]]
      when :w then [[0,1],[6,7]]
      end
      x_coords,y_coords = *coords
      y_coords.each do |y|
        x_coords.each do |x|
          @terrain[x,y] = [Floor1,Floor2].sample
        end
      end
    end
    
    def add_door_cover(dir)
      options = case dir
      when :n then {x: WindowWidth/2, y: TileHeight + MapYOffset, angle: 0}
      when :s then {x: WindowWidth/2, y: WindowHeight - TileHeight, angle: 180}
      when :w then {x: TileWidth, y: (WindowHeight + MapYOffset)/2, angle: 270}
      when :e then {x: WindowWidth - TileWidth, y: (WindowHeight + MapYOffset)/2, angle: 90}
      else; raise "That's not a direction! #{dir.inspect}"
      end
      options.merge!(image: Image["door_cover.png"], zorder: 501, update: false, color: WallColor)
      Chingu::GameObject.create(options)
    end
    
    def add_door(dir,door_type,switch_id=nil)
      door_klass = case door_type
      when :key_locked then KeyLockedDoor
      when :switch_locked then SwitchLockedDoor
      when :magic_door then MagicDoor
      when :item_blocked then ItemBlockedDoor
      end
      return unless door_klass
      options = case dir
      when :n then {x: WindowWidth/2, y: TileHeight + MapYOffset, angle: 0}
      when :s then {x: WindowWidth/2, y: WindowHeight - TileHeight, angle: 180}
      when :w then {x: TileWidth, y: (WindowHeight + MapYOffset)/2, angle: 270}
      when :e then {x: WindowWidth - TileWidth, y: (WindowHeight + MapYOffset)/2, angle: 90}
      else; raise "That's not a direction! #{dir.inspect}"
      end
      options.merge!(dir: dir,switch_id: switch_id)
      door_klass.create(options)
    end
  end
end