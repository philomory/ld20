require 'ostruct'

module LD20
  #Floor1 = OpenStruct.new
  #Floor1.image_file = "floor1.png"
  #Floor1.walkable = true
  #Floor1.passes_projectiles = true
  #
  #Floor2 = OpenStruct.new
  #Floor2.image_file = "floor2.png"
  #Floor2.walkable = true
  #Floor2.passes_projectiles = true
  #Floor = OpenStruct.new(
  #  image_file: "floor.png",
  #  walkable: true,
  #  passable: true,
  #  passes_projectiles: true,
  #)
  #Floor1 = Floor2 = Floor
  #
  #Wall = OpenStruct.new
  #Wall.image_file = "wall.png"
  #Wall.walkable = false
  #Wall.passes_projectiles = false
  
  Terrain = Struct.new(:walkable,:passable,:dangerous,:swimable,:image) do
    alias_method :image_file, :image
    alias_method :passes_projectiles, :passable
    def initialize(*args, &blk)
      if args.last.is_a?(Hash)
        h = args.pop
      end
      super(*args)
      if h
        members.each {|m| self[m] = h[m.to_sym]}
      end
      self[:passable] = true if self[:passable].nil?
      self[:walkable] = true if self[:walkable].nil?
      @special_effect = blk
      def special(*args)
        @special_effect.call(*args) if @special_effect
      end
      def impassible_for_player?
        !walkable
      end
    end
  end
  
  Floor = Terrain.new(image: "floor.png")  
  Floor1 = Floor2 = Floor
  
  Wall = Terrain.new(passable: false, walkable: false, image: "wall.png")
  
  Water = Terrain.new(walkable: false, swimable: true, dangerous: true, image: "water.png")
  Pit = Hole = Terrain.new(walkable: false, dangerous: true, image: "hole.png") do |player_or_object|
    player_or_object.fall if player_or_object.respond_to?(:fall)
  end
  
  Floor1Covered = Floor1.dup
  Floor1Covered.walkable = false
  Floor1Covered.passable = true
  
  Floor2Covered = Floor2.dup
  Floor2Covered.walkable = false
  Floor2Covered.passable = true
  
  OutOfBounds = OpenStruct.new
  OutOfBounds.walkable = false
  OutOfBounds.passes_projectiles = false
  

  
  
end