# This model class represents a single step during the solution of a maze. It
# consists of only three things:
# 1. the previous step
# 2. the current cell
# 3. the direction to be tried being in the current cell
#
# Author:: Georg Konwisser (mailto:software@konwisser.de)
class PossibleStep
	# the step which led to this step
	attr_reader :previous_step

	# the maze cell this step starts from
	attr_reader :start_cell

	# the next direction to be tried
	attr_reader :next_direction

	# Creates a new Step object.
	# previous_step:: the step which led to this step
	# start_cell:: the maze cell this step starts from
	# next_direction::
	#	the next direction to be tried (:left, :top, :right, or :bottom)
	def initialize(previous_step, start_cell, next_direction)
		@previous_step = previous_step
		@start_cell = start_cell
		@next_direction = next_direction
	end

	# the cell this steps leads to
	def next_cell
		@start_cell.neighbor(@next_direction)
	end
end