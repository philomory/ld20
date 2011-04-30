module LD20
  class RoomState < Chingu::GameState
    attr_reader :terrain
    include RoomData
    def initialize(options = {})
      @room_x, @room_y = options[:room_x], options[:room_y]
      
      on_input(:r) { switch_game_state(self.class.new(options)) }
      #on_input(:p,PauseState)
      
      super
      #px, py = *options[:player_pos] || [PlayerStartX, PlayerStartY]
      
      load_room_data
      #@terrain = load_terrain
      #load_props
      #load_enemies
      #load_prize
      #@player = PlayerSprite.create(:x => px, :y => py, :basic_player => $window.basic_player)      
      #@HUD = HUD.create(:player => @player)
      @ready = true
    end
    
    def update
      super
      
      #@player.each_bounding_box_collision(Enemy) do |player, enemy|
      #  player.hit_by(enemy)
      #end
      #
      #@player.each_bounding_box_collision(Prop) do |player, prop|
      #  prop.player_collision(player)
      #end
      #
      #PlayerSword.each_bounding_box_collision(Enemy) do |sword, enemy|
      #  enemy.hit_by(sword)
      #end
      #
      #Prop.each_bounding_box_collision(Enemy) do |prop, enemy|
      #    prop.enemy_collision(enemy)
      #end
      #
      #Prop.each_bounding_box_collision(PlayerSword) do |prop, weapon|
      #    prop.weapon_collision(weapon)
      #end
      
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
      @room[:connected_rooms][dir][:door_type] = :normal
    end
    
    def terrain_at(x_pos,y_pos)
      grid_x = x_pos / TileWidth
      grid_y = (y_pos - MapYOffset) / TileHeight
      @terrain[grid_x,grid_y]
    end
    
    def check_for_prize
      if @prize and Enemy.size.zero?
        #Sound['award.ogg'].play
        Prop.place(@prize)
      end
    end
    
  end
end