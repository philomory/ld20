module LD20
  class Weapon < Chingu::GameObject
    attr_reader :damage
    
    def breaks_blocks?
      false
    end
    
    def impacted
    end
    
  end
end