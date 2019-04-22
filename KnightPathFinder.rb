require "set"

class KnightPathFinder
    attr_accessor :root_node, :considered_positions, :start_pos

    def initialize(pos)
        self.start_pos = pos
        self.root_node = PolyTreeNode.new(pos)
        self.considered_positions = [pos]
        self.build_move_tree()
    end

    def build_move_tree()
        self.start_pos = self.root_node
        moves = [self.start_pos]

        until moves.empty?
            start_pos = moves.shift 
            start_pos.children = self.new_move_positions(start_pos.value)
            start_pos.children.each {|child| start_pos.add_child(child)}
            moves += start_pos.children
        end

    end

    def self.valid_moves(pos)
        left_up = [1, -2]
        left_down = [-1, -2]
        down_left = [-2, -1]
        down_right = [-2, 1]
        right_down = [-1, 2]
        right_up = [1, 2]
        up_right = [2, 1]
        up_left = [2, -1]

        valid = []

        [left_up, left_down, down_left, down_right, right_down, 
        right_up, up_right, up_left].each do |move|
            if pos[0] + move[0] >= 0 && pos[1] + move[1] >= 0 && pos[0] + move[0] <= 8 && pos[1] + move[1] <= 8
                valid << [pos[0] + move[0], pos[1] + move[1]]
            end
        end

        valid
    end

    def new_move_positions(pos)
        moves = KnightPathFinder.valid_moves(pos)
        unconsidered_moves = []
        moves.each do |move|
            if !considered_positions.include?(move)
                considered_positions << move 
                unconsidered_moves << move
            end
        end
        to_PolyTreeNode(unconsidered_moves)
    end

    def to_PolyTreeNode(arr)
        poly_arr = []
        arr.each {|elem| poly_arr << PolyTreeNode.new(elem)}
        poly_arr
    end

    def find_path(end_pos)
        queue = [self.root_node]
        visited = Set.new()
        until queue.empty?
            p (pos = queue.shift).children
            return pos if pos.value == end_pos
            visited.add(pos)
            pos.children.each do |child|
                queue << child if !queue.include?(child) && !visited.include?(child)
            end
        end

        nil
    end

end

class PolyTreeNode

    attr_accessor :children, :value, :parent

    def initialize(pos)
        self.value = pos 
        self.children = []
        self.parent = nil
    end

    def parent=(parent)
        @parent.children.delete(self) if @parent != nil && @parent != parent
        @parent = parent
        parent.children << self if parent != nil && !parent.children.include?(self)
    end

    def add_child(child_node)
        child_node.parent=(self)
    end

end

# left_up = [1, -2]
# left_down = [-1, -2]
# down_left = [-2, -1]
# down_right = [-2, 1]
# right_down = [-1, 2]
# right_up = [1, 2]
# up_right = [2, 1]
# up_left = [2, -1]

# [left_up, left_down, down_left, down_right, right_down, 
# right_up, up_right, up_left].each do |move|
#     p move
# end


pos = PolyTreeNode.new([0, 1])
k = KnightPathFinder.new([3, 3])

k.build_move_tree
k.find_path([5, 4])
# p k.considered_positions
