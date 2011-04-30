require 'ostruct'

module LD20
  Floor1 = OpenStruct.new
  Floor1.image_file = "floor1.png"
  
  Floor2 = OpenStruct.new
  Floor2.image_file = "floor2.png"
  
  Wall = OpenStruct.new
  Wall.image_file = "wall.png"
  
  class DoorCover < Chingu::GameObject
    def setup
      puts "Created a door cover!"
    end
  end
end