# This model class represents a single step during the solution of a maze. It
# consists of only three things:
# 1. the previous step
# 2. the cell this step starts from
# 3. the direction this step goes from the cell it starts from
#
# Author:: Georg Konwisser (mailto:software@konwisser.de)
class Step
	# the step which led to this step
	attr_reader :previous_step

	# the maze cell this step starts from
	attr_reader :from_cell

	# the direction this step goes from the cell it starts from
	attr_reader :direction

	# Creates a new Step object.
	# previous_step:: the step which led to this step
	# from_cell:: the maze cell this step starts from
	# direction::
	#	the direction this step goes from the cell it starts from
	#	(:left, :top, :right, or :bottom)
	def initialize(previous_step, from_cell, direction)
		@previous_step = previous_step
		@from_cell = from_cell
		@direction = direction
	end

	# the cell this steps leads to
	def to_cell
		@from_cell.neighbor(@direction)
	end
end