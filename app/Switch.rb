module LD20
  class Prop::Switch < Prop
    def setup
      @switch_id = @options[:properties][:switch_id]
      @image = Image['switch.png']
    end
  end
end