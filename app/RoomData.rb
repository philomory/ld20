module LD20
  module RoomData
    def load_room_data
      @room_data = $window.dungeon.dungeon_map[[@room_x,@room_y]]
      #puts @room_data
      @terrain = Grid.new(FullMapTilesWide, FullMapTilesHigh)
      fill_floor
      place_walls
      handle_doors
      layout
    end
    
    def layout
      @layout = case @room_data[:type]
      when :entry then EntryRoom.new(self)
      when :normal, nil then NormalRoom.new(self)
      when :switch then SwitchRoom.new(self)
      when :key then [KeyRoom,KeyPrizeRoom,KeyPrizeRoom].sample.new(self)
      when :item_blocked_switch then ItemBlockedSwitchRoom.new(self)
      when :item_blocked_key then ItemBlockedKeyRoom.new(self)
      when :magic_key then MagicKeyRoom.new(self)
      when :item then TreasureRoom.new(self)
      when :goal then GoalRoom.new(self)
      when :boss then BossRoom.new(self)
      else
        warn "unrecognized room type: #{@room_data[:type]}"
        NormalRoom.new(self)
      end
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
      [:north,:south,:east,:west].each do |dir|
        if (door = @room_data[:connected_rooms][dir])
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
      when :north then [[9,10],[0,1]]
      when :south then [[9,10],[12,13]]
      when :east then [[18,19],[6,7]]
      when :west then [[0,1],[6,7]]
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
      when :north then {x: WindowWidth/2, y: TileHeight + MapYOffset, angle: 0}
      when :south then {x: WindowWidth/2, y: WindowHeight - TileHeight, angle: 180}
      when :west then {x: TileWidth, y: (WindowHeight + MapYOffset)/2, angle: 270}
      when :east then {x: WindowWidth - TileWidth, y: (WindowHeight + MapYOffset)/2, angle: 90}
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
      when :north then {x: WindowWidth/2, y: TileHeight + MapYOffset, angle: 0}
      when :south then {x: WindowWidth/2, y: WindowHeight - TileHeight, angle: 180}
      when :west then {x: TileWidth, y: (WindowHeight + MapYOffset)/2, angle: 270}
      when :east then {x: WindowWidth - TileWidth, y: (WindowHeight + MapYOffset)/2, angle: 90}
      else; raise "That's not a direction! #{dir.inspect}"
      end
      options.merge!(dir: dir,switch_id: switch_id)
      door_klass.create(options)
    end
    
    def add_enemy
      Knight.create
    end
    
  end
end