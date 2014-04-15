require './tree_node'

class KnightPathFinder
  attr_accessor :root_tree
  def initialize(start_point)
    @start_point = start_point
    @root_tree = TreeNode.new(start_point)

  end

  def find_path(end_point)
    self.root_tree.path(end_point)
  end

  def move_tree
    queue = [self.root_tree]
    locations_visited = [self.root_tree.value]

    until objects_visited.empty?
      current_object = queue.shift
      current_location = current_object.value

      next_moves = find_possible_moves(current_location)

      next_moves.each do |child|
        unless locations_visited.include?(child)
          child_node = TreeNode.new(child)
          queue << child_node
          locations_visited << child_node.value
          current_object.add_child(child_node)
        end
      end

      current_location
    end

  end

  def find_possible_moves(current_position)
    moves =[[1,2], [1,-2], [-1, 2], [-1, -2], [2, 1], [2, -1], [-2, 1], [-2, -1]]

    positions = moves.map do |x, y|
      [current_position[0]+x, current_position[1]+y]
    end

    positions.delete_if do |position|
      (position[0] > 8 || position[0] < 0) || (position[1] > 8 || position[1] < 0)
    end
  end

end



point = KnightPathFinder.new([0,0])
point.move_tree



p point.root_tree.path([6,2])
