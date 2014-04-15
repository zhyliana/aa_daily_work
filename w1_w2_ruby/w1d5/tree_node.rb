class TreeNode
  attr_accessor :children, :value, :parent
  def initialize(value, children = [])
    @parent = nil
    @value = value
    @children = children
  end

  def remove_child(child_node)
    @children.delete(child_node)
    child_node.parent = nil
  end

  def add_child(child_node)

    self.children << child_node

    if child_node.parent != nil
      # do self.remove_child(child_node) instead
      child_index = child_node.parent.children.index(child_node)
      child_node.parent.children[child_index] = nil

    end

    child_node.parent = self

  end

  def dfs(value)
    current_node = self
    return self if self.value == value
    current_node.children.each do |child|
      return child if child.dfs(value) != nil
    end
    nil
  end

  def bfs(value)
    queue = [self] #root!

    while !queue.empty?
      current_node = queue.shift

      if current_node.value == value
        return current_node
      else
        queue.concat(current_node.children)
        # current_node.children.each do |child|
        #   queue.push(child)
        # end
      end

    end
    nil

  end

  def path(target_pos)
    target_node = self.bfs(target_pos).value
    target_node_object = bfs(target_pos)
    path =[target_node]
    until target_node_object.parent == nil
      path << target_node_object.parent.value
      target_node_object = target_node_object.parent
    end
    path.reverse
  end

end

a = TreeNode.new(10)
b = TreeNode.new(3)
c = TreeNode.new(4)
d = TreeNode.new(2)
e = TreeNode.new(1)
f = TreeNode.new(7)

a.add_child(b)
a.add_child(c)
b.add_child(d)
b.add_child(e)
c.add_child(f)







