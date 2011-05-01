require 'ostruct'

module LD20
  Floor1 = OpenStruct.new
  Floor1.image_file = "floor1.png"
  Floor1.walkable = true
  
  Floor2 = OpenStruct.new
  Floor2.image_file = "floor2.png"
  Floor2.walkable = true
  
  Wall = OpenStruct.new
  Wall.image_file = "wall.png"
  Wall.walkable = false
  
  Floor1Covered = Floor1.dup
  Floor1Covered.walkable = false
  
  Floor2Covered = Floor2.dup
  Floor2Covered.walkable = false
  
  OutOfBounds = OpenStruct.new
  OutOfBounds.walkable = false
  
end