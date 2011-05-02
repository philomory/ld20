module LD20
  class GoalRoom < RoomLayout
    @available_layouts = %w{treasure_room}
    def populate(*args); end
    def setup
      Prop::Portal.create(x: WindowWidth/2, y: (WindowHeight + MapYOffset)/2) 
    end
  end
end
