unless defined?(Chingu)
  require 'app/axiom_of_choice'
  require 'app/retryable'
  require 'app/Grid'
  require 'app/terrain'
end

module LD20
  class BlockPushPuzzleLayout
    attr_reader :solution, :all_blocks
    
    def initialize(opts = {})
      @width = opts[:width] || 5
      @height = opts[:height] || 5
      @number_of_blocks = opts[:blocks] || 5
      @number_of_pulls = opts[:pulls] || 3
      
      @terrain = Grid.new(@width,@height)
      
      fill_floor
      mark_outer_border
      
      retryable(tries: 5) do
        reset
        move_blocks
      end
      
    end
    
    def reset
      #@walked = Grid.new(6,6)
      @puller_pos = [0,0]
      @pulled_blocks = []
      place_random_blocks
    end
    
    
    def fill_floor
      @terrain.each_with_coords {|t,x,y| @terrain[x,y] = :floor }
    end
    
    def mark_outer_border
      @terrain.each_with_coords do |t,x,y|
        if [0,@width-1].include?(x) || [0,@height-1].include?(y)
          @terrain[x,y] = :outer_border
        end
      end
    end
    
    def place_random_blocks
      available_spaces = []
      (@width-2).times do |x|
        (@height-2).times do |y|
          available_spaces << [x+1,y+1]
        end
      end
      @all_blocks = available_spaces.sample(@number_of_blocks)
      @unpushed_blocks = []
      @solution = Set.new([])
      @all_blocks.each do |b| 
        @unpushed_blocks << b.dup
        @solution << b.dup
      end
    end
      
    def display(blocks = @all_blocks)
      @height.times do |y|
        @width.times do |x|
          if blocks.include?([x,y])
            print '#'
          else
            print '.'
          end
        end
        puts
      end
      puts
    end  
    
      
    def move_blocks
      @number_of_pulls.times do
        pick_and_move_block
      end
    end
    
    def pick_and_move_block
      reachable = reachable_squares(@puller_pos)
      all_pulls = @unpushed_blocks.map {|block| block_pulls(block,reachable) }.flatten
      pull = all_pulls.sample
      @puller_pos = pull[:player_end]
      @unpushed_blocks.delete(pull[:block])
      @all_blocks.delete(pull[:block])
      @all_blocks << pull[:player_start]
      @pulled_blocks << pull[:player_start]
    end
    
    def block_pulls(block,reachable=nil)
      pulls = []
      block_x, block_y = *block
      [[1,0],[-1,0],[0,1],[0,-1]].each do |delta|
        d_x, d_y = *delta
        player_start_x = block_x + d_x
        player_start_y = block_y + d_y
        next if reachable && !(reachable.include?([player_start_x,player_start_y]))
        player_end_x = player_start_x + d_x
        player_end_y = player_start_y + d_y
        if open_for_block?(player_start_x,player_start_y) and open_for_player?(player_end_x,player_end_y)
          pull = {
            block: block,
            player_start: [player_start_x,player_start_y],
            player_end: [player_end_x,player_end_y],
            delta: delta
          }
          pulls << pull
        end
      end
      return pulls
    end
    
    def open_for_block?(x,y)
      !(@all_blocks.include?([x,y])) && @terrain[x,y] == :floor
    end
    
    def open_for_player?(x,y)
      !(@all_blocks.include?([x,y])) && [:floor,:outer_border].include?(@terrain[x,y])
    end
    
    def reachable_squares(origin)
      closed = Set.new
      open = Set.new([origin])
      blocked = Set.new(@all_blocks)
      until open.empty?
        now = open.pop
        closed.add now
        [[1,0],[-1,0],[0,1],[0,-1]].each do |delta|
          consider = [now[0] + delta[0],now[1] + delta[1]]
          next if open.include?(consider) || closed.include?(consider) || blocked.include?(consider) || @terrain[*consider] == OutOfBounds
          open.add consider
        end
      end
      closed
    end
    
    
  end
end
