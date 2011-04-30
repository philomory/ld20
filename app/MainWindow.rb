include Gosu

Image.autoload_dirs << "#{ROOT}/media/gfx"
Sound.autoload_dirs << "#{ROOT}/media/sfx"
Song.autoload_dirs  << "#{ROOT}/media/music"

module LD20
  class MainWindow < Chingu::Window
    attr_reader :dungeon
    def initialize
      super(WindowWidth,WindowHeight)
      self.input = {escape: :exit}
      @dungeon = DungeonLayout.new
      push_game_state RoomState.new(room_x:0, room_y:0)
      
    end
  end
end