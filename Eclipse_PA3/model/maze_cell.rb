# This model class represents a single cell of a maze. A cell stores its
# coordinates as well as up to four neighbor cells. If one of the neighbors is
# not accessible because of a wall in the maze, this cell does not store a
# reference to this neighbor.
#
# Author:: Georg Konwisser (mailto:software@konwisser.de)
class MazeCell
	# the x coordinate (across) of this cell. e.g. the cell (x,y)=(0,0) is in the
	# upper left corner of the maze
	attr_reader :column

	# the y coordinate (down) of this cell. e.g. the cell (x,y)=(0,0) is in the upper
	# left corner of the maze
	attr_reader :row

	# Creates a new MazeCell object with the given coordinates. e.g. the cell
	# (_column_, _row_)=(0,0) is in the upper left corner of the maze. Initially the
	# cell has no neighbors and walls in all four directions.
	def initialize(column, row)
		@column, @row = column, row
		@neighbors = {}
	end

	# Sets the given _neighbor_ cell as a neighbor of this cell and vice versa.
	# direction::
	#	:left, :top, :right, or :bottom. E.g. :left would define _neighbor_ as the
	# 	left neighbor cell of this cell and also set this cell as the right neighbor
	#	of _neighbor_.
	# neighbor::
	# 	the neighbor cell to be set (and updated as mentioned above) or _nil_ if
	# 	there is a wall or neighbor in the given direction
	# raises exception:: if direction is not :left, :top, :right, or :bottom
	def set_neighbor(direction, neighbor)
		validate_direction(direction)

		set_neighbor_non_rec(direction, neighbor)
		neighbor.set_neighbor_non_rec(OPPOSITES[direction], self) if !neighbor.nil?
	end

	# Returns the neighbor cell in the given direction or _nil_ if there is a wall in
	# this direction.
	# raises exception:: if direction is not :left, :top, :right, or :bottom
	def neighbor(direction)
		validate_direction(direction)
		@neighbors[direction]
	end

	# Defines that there is a wall in the given direction of this cell.
	# raises exception:: if direction is not :left, :top, :right, or :bottom
	def set_wall(direction)
		validate_direction(direction)
		set_neighbor_non_rec(direction, nil)
	end

	# Returns _true_ if there is wall in the given direction of this cell, otherwise
	# _false_.
	# raises exception:: if direction is not :left, :top, :right, or :bottom
	def wall?(direction)
		validate_direction(direction)
		@neighbors[direction].nil?
	end

	protected

	# Sets the given _neighbor_ cell as a neighbor of this cell but does not update
	# _neighbor_.
	# direction::
	#	:left, :top, :right, or :bottom. E.g. :left would define _neighbor_ as the
	# 	left neighbor cell of this cell and also set this cell as the right neighbor
	#	of _neighbor_.
	# neighbor::
	# 	the neighbor cell to be set or _nil_ if there is a wall or neighbor in the
	#	given direction
	def set_neighbor_non_rec(direction, neighbor)
		prev_neighbor = @neighbors[direction]
		@neighbors[direction] = neighbor

		return if prev_neighbor.nil?

		prev_neighbor.set_neighbor_non_rec(OPPOSITES[direction], nil)
	end

	private

	# Hash which defines the opposites of the directions :left, :top; :right, and
	# :bottom
	OPPOSITES = {left: :right, right: :left, top: :bottom, bottom: :top}

	def validate_direction(direction)
		message = "direction can only be :left, :top, :right, or :bottom"
		raise message if !OPPOSITES.has_key?(direction)
	end

	def to_s
		"(#{@column},#{@row})"
	end
end