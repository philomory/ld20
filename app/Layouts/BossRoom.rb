module LD20
  class BossRoom < RoomLayout
    @available_layouts = %w{boss_room}
    def populate(*args) 
      OldMan.create(x: BossX, y: BossY)
    end
  end
end
