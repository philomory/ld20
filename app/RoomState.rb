module LD20
  class RoomState < Chingu::GameState
    attr_reader :terrain, :room_data, :doors
    attr_accessor :prize
    include RoomData
    def initialize(options = {})
      @room_x, @room_y = options[:room_x], options[:room_y]
      
      on_input(:r) { switch_game_state(self.class.new(options)) }
      #on_input(:p,PauseState)
      
      super
      px, py = *options[:player_pos] || [PlayerStartX, PlayerStartY]
      
      load_room_data
      @player = PlayerSprite.create(:x => px, :y => py, :basic_player => $window.basic_player)      
      @HUD = HUD.create(:player => @player)
      @ready = true
      @first_run = true
    end
    
    def update
      if @first_run
        @first_run = false
        @layout.start_by_doing
        return
      end
      super
      
      @player.each_bounding_box_collision(Enemy) do |player, enemy|
        player.hit_by(enemy)
      end
      
      @player.each_bounding_box_collision(Prop) do |player, prop|
        prop.player_collision(player)
      end
            
      Enemy.each_bounding_box_collision(Weapon) do |enemy, weapon|
        enemy.hit_by(weapon)
      end
      
      Prop.each_bounding_box_collision(Weapon) do |prop, weapon|
        prop.weapon_collision(weapon)
      end
      
      ClosedDoor.each_bounding_box_collision(Weapon) do |door, weapon|
        door.collided_with_weapon(weapon)
      end
      
    end
    
    def draw
      return unless @ready
      @terrain.each_with_coords do |type,x,y|
        next unless type.image_file
        x_pos = x * TileWidth
        y_pos = y * TileHeight + MapYOffset
        Image[type.image_file].draw(x_pos,y_pos,0)
      end
      Image['doors.png'].draw(0,MapYOffset,500,1,1,WallColor)
      super
    end
    
    def unlock_door(dir)
      @room_data[:connected_rooms][dir][:type] = :normal
    end
    
    def remove_layout_entry(x,y)
      x -= 2
      y -= 2
      index = x + y * (MapTilesWide + 1)
      #puts @room_data[:layout_data][index]
      @room_data[:layout_data][index]='.'
    end
    
    def terrain_at(x_pos,y_pos)
      grid_x = x_pos / TileWidth
      grid_y = (y_pos - MapYOffset) / TileHeight
      @terrain[grid_x,grid_y]
    end
    
    def check_for_prize
      if @layout.prize and !@room_data[:prize_collected] and Enemy.size.zero?
        #Sound['award.ogg'].play
        Prop.place(@layout.prize.update(prize: true))
      end
    end
    
    def transition(direction)
      new_coords = @room_data[:connected_rooms][direction][:room]
      room_x, room_y = *new_coords
      p_coords = case direction
      when :west then [PlayerXEntryEast, @player.y]
      when :east then [PlayerXEntryWest, @player.y]
      when :north then [@player.x, PlayerYEntrySouth]
      when :south then [@player.x, PlayerYEntryNorth]
      end
      p_x, p_y = *p_coords

      switch_game_state(RoomState.new(room_x: room_x, room_y: room_y, player_pos: [p_x,p_y], player: @player))
    end
    
    def boss_warp
      room_x, room_y = *$window.dungeon.boss_room
      switch_game_state(RoomState.new(room_x: room_x, room_y: room_y, player_pos: PlayerPosForBoss, player: @player))
    end
    
    def win_boss_fight
      Enemy.destroy_all
    end
    
  end
end