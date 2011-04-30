def gen_layout
  setup
  entry
  pre_item
  item
  post_item
  magic_key
  goal
end

def setup
  @stages_pre_item_range = (2..4)
  @stages_post_item_range = (2..4)
  @rooms_per_normal_stage = (2..4)
  @rooms_added_for_item_step = (1..3)
  @rooms_added_for_magic_key_step = (0..2)
    
  @dungeon_map = {}
  @stages = []
  @all_rooms = []
  @latest_room = nil
  @next_switch_id = 0
  @current_step = nil
end

def entry
  @current_step = :entry
  room = {
    x: 0,
    y: 0,
    step: :entry,
    type: :entry,
    available_edges: [:n,:s,:e,:w],
    connected_rooms: {}
  }
  
  start_new_stage
  add_room(room)
end

def current_stage
  @stages.size - 1
end

def start_new_stage
  @stages << []
end

def add_room(room)
  room[:stage] = current_stage
  @stages.last << room
  coords = [room[:x],room[:y]]
  @dungeon_map[coords] = room
  @all_rooms << room
  @latest_room = room
end

def step_room(*args)
  case @current_step
  when :pre_item then pre_item_room(*args)
  when :item then post_item_room(*args)
  when :post_item then post_item_room(*args)
  else
    raise "Blarg! Bad room step: #{@current_step}"
  end
end

def pick_a_room(options = {})
  options = {open_only: true, this_stage: true, untyped: false}.update(options)
  base_set = options[:this_stage] ? @stages.last : @all_rooms
  filter_set_1 = options[:open_only] ? base_set.reject {|r| r[:available_edges].empty? } : base_set
  filter_set_2 = options[:untyped] ? filter_set_1.reject {|r| r.key?(:type) } : filter_set_1
  filter_set_2.sample
end

def pre_item
  @current_step = :pre_item
  number_of_stages = @stages_pre_item_range.to_a.sample
  number_of_stages.times do
    pre_item_stage
  end
end

def pre_item_stage
  type_of_obstacle = [:key_lock,:switch_lock].sample
  number_of_rooms = @rooms_per_normal_stage.to_a.sample - 1
  number_of_rooms.times do
    room_to_branch = pick_a_room
    if room_to_branch
      pre_item_room(room_to_branch)
    else
      type_of_obstacle = :switch_lock
      puts "Boo! No rooms in this stage that can be branched!"
      break
    end
  end
  branch_obstacle(type_of_obstacle)
end

def pre_item_room(room_to_branch,door_type=:normal)
  direction = room_to_branch[:available_edges].sample
  x,y = coords_in_direction(room_to_branch,direction)
  room = {
    x: x,
    y: y,
    step: @current_step,
    available_edges: [:n,:s,:e,:w],
    connected_rooms: {}
  }
  add_room(room)
  connect_rooms(room_to_branch,room,direction,door_type)
end

def item
  @current_step = :item
  @latest_room[:step] = :item
  @latest_room[:type] = :item
  
  type_of_obstacle = [:item_key_lock, :item_switch_lock].sample
  number_of_rooms = @rooms_added_for_item_step.to_a.sample
  number_of_rooms.times do
    room_to_branch = pick_a_room(this_stage: false)
    item_step_room(room_to_branch)
  end
  branch_obstacle(type_of_obstacle)
end

def item_step_room(room_to_branch)
  direction = room_to_branch[:available_edges].sample
  x,y = coords_in_direction(room_to_branch,direction)
  room = {
    x: x,
    y: y,
    step: :item,
    available_edges: [:n,:s,:e,:w],
    connected_rooms: {}
  }
  add_room(room)
  connect_rooms(room_to_branch,room,direction,:item_blocked)
end

def post_item
  @current_step = :post_item
  
  number_of_stages = @stages_post_item_range.to_a.sample
  number_of_stages.times do
    post_item_stage
  end
end

def post_item_stage
  type_of_obstacle = [:key_lock, :switch_lock, :item_key_lock, :item_switch_lock].sample
  number_of_rooms = @rooms_per_normal_stage.to_a.sample - 1
  number_of_rooms.times do
    room_to_branch = pick_a_room
    if room_to_branch
      post_item_room(room_to_branch)
    else
      type_of_obstacle = case type_of_obstacle
      when :key_lock then :switch_lock
      when :item_key_lock then :item_switch_lock
      end
      puts "Boo! No rooms in this stage that can be branched! (Post-item)"
      break
    end
  end
  branch_obstacle(type_of_obstacle)
end

def post_item_room(*args)
  pre_item_room(*args)
end

def magic_key
  @current_step = :magic_key
  @latest_room[:step] = :magic_key
  
  number_of_rooms = @rooms_added_for_magic_key_step.to_a.sample
  number_of_rooms.times do
    room_to_branch = pick_a_room
    door_type = [:normal, :item_blocked].sample
    post_item_room(room_to_branch,door_type)
  end
  @latest_room[:type] = :magic_key
end

def goal
  @current_step = :goal
  start_new_stage
  room_to_branch = pick_a_room(untyped: true, this_stage: false)
  direction = room_to_branch[:available_edges].sample
  x,y = coords_in_direction(room_to_branch,direction)
  room = {
    x: x,
    y: y,
    step: :goal,
    available_edges: [],
    connected_rooms: {}
  }
  add_room(room)
  connect_rooms(room_to_branch,room,direction,:magic_door)
end

def branch_obstacle(type)
  case type
  when :key_lock then branch_key_lock
  when :switch_lock then branch_switch_lock
  when :item_key_lock then branch_item_key_lock
  when :item_switch_lock then branch_item_switch_lock
  else
    raise "That's not a valid obstacle type! (#{type})"
  end
end

def branch_key_lock
  room_to_branch = pick_a_room
  room_for_key = pick_a_room(open_only: false, untyped: true)
  
  room_for_key[:type] = :key
  start_new_stage
  step_room(room_to_branch,:key_locked)
end

def branch_switch_lock
  room_to_branch = pick_a_room(this_stage: false)
  room_for_switch = pick_a_room(open_only: false, untyped: true)
  
  room_for_switch[:type] = :switch
  room_for_switch[:switch_id] = @next_switch_id
  
  start_new_stage
  step_room(room_to_branch,:switch_locked)
  @next_switch_id += 1
end

def branch_item_key_lock
  room_to_branch = pick_a_room
  room_for_key = pick_a_room(open_only: false, this_stage: false, untyped: true)
  
  room_for_key[:type] = :item_blocked_key
  start_new_stage
  step_room(room_to_branch,:key_locked)
end

def branch_item_switch_lock
  room_to_branch = pick_a_room(this_stage: false)
  room_for_switch = pick_a_room(open_only: false, untyped: true)
  
  room_for_switch[:type] = :item_blocked_switch
  room_for_switch[:switch_id] = @next_switch_id
  
  start_new_stage
  step_room(room_to_branch,:switch_locked)
  @next_switch_id += 1
end

def connect_rooms(branching_room,new_room,direction,door_type=:normal)
  connect_one_way(branching_room,new_room,direction,door_type)
  connect_one_way(new_room,branching_room,opposite_direction(direction),:normal)
end

def connect_one_way(first_room,second_room,direction,door_type)
  first_room[:available_edges].delete(direction)
  second_coords = [second_room[:x],second_room[:y]]
  door_details = {
    room: second_coords,
    type: door_type
  }
  door_details[:switch_id] = @next_switch_id if door_type == :switch_locked
  first_room[:connected_rooms][direction] = door_details
end

def coords_in_direction(room,dir)
  x, y = room[:x], room[:y]
  delta = case dir
  when :n then [ 0,-1]
  when :s then [ 0, 1]
  when :e then [ 1, 0]
  when :w then [-1, 0]
  end
  x += delta[0]
  y += delta[1]
  [x,y]
end

def opposite_direction(dir)
  case dir
  when :n then :s
  when :s then :n
  when :e then :w
  when :w then :e
  else
    raise "Ballyoo! That's not a direction!"
  end
end

require 'pp'

gen_layout

pp @dungeon_map
puts @dungeon_map.size