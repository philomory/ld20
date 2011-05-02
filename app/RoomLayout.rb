module LD20
  class RoomLayout
    
    include Chingu::Helpers::ClassInheritableAccessor
    class_inheritable_accessor :available_layouts
    @available_layouts = []
    def available_layouts
      self.class.available_layouts
    end
    
    attr_reader :prize
    def initialize(room)
      @room = room
      @grid = room.terrain
      @room_item = '_'
      @item_blocked = '.'
      setup
      gen_layout
      populate
    end
    
    def setup
    end
    
    def gen_layout
      layout_data = @room.room_data[:layout_data]
      unless layout_data
        layout_name = pick_layout
        layout_data = read_layout_file(layout_name)
        munge_layout_data!(layout_data)
        @room.room_data[:layout_data] = layout_data
      end
      parse_layout_data(layout_data)
    end
    
    def pick_layout
      return self.class.available_layouts.sample
    end
    
    def read_layout_file(layout_name)
      filename = "#{ROOT}/data/layouts/#{layout_name}.layout"
      return File.read filename
    end
    
    def munge_layout_data!(data)
      if @puzzle
        num = data.count('?')
        picked = rand(num)
        data.gsub!('?').each_with_index {|c,i| i == picked ? 'P' : 'W' }
      else
        data.gsub!('?','W')
      end
      
      inum = data.count('i')
      unless inum.zero?
        picked = rand(inum)
        data.gsub!('i').each_with_index {|c,i| i == picked ? @room_item : '_' }
      end
      
      pnum = data.count('*')
      unless pnum.zero?
        marker = (@prize ? '!' : @room_item)
        picked = rand(pnum)
        data.gsub!('*').each_with_index {|c,i| i == picked ? marker : '_' }
      end
      
      raise if (data =~ /\!/ && !@prize)
      data.gsub!('b',@item_blocked) 
      
      #puts data
      #puts
    end
    
    def parse_layout_data(data)
      data.lines.first(10).each_with_index do |line,y|
        y += 2
        line.chomp!
        line.chars.each_with_index do |char, x|
          x += 2
          adjust_tile(x,y,char)
        end
      end
    end
    
    def adjust_tile(x,y,char)
      case char
      when 'W'
        @grid[x,y] = Wall
      when 'P'
        @grid[x,y] = Pushable
      when 'B'
        Prop::Breakable.place(x: x, y: y)
      when 'K'
        Prop::Key.place(x: x, y: y)
      when 'S'
        Prop::Switch.place(x: x, y: y, switch_id: @room.room_data[:switch_id])
      when '!'
        @prize.update(x: x, y: y)
        puts @prize
      end
    end
    
    def start_by_doing
    end
    
    def populate(num=[0,1,1,2])
      num = num.is_a?(Array) ? num.sample : num
      @room.room_data[:enemies] ||= {}
      @room.room_data[:enemies][:knight] ||= num
      @room.room_data[:enemies][:knight].times do
        Knight.create
      end
    end
    
  end
end