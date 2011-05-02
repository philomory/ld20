module LD20
  class Enemy < Chingu::GameObject
    traits :velocity, :timer, :collision_detection
    trait :bounding_box, :scale => 0.8
  end
end