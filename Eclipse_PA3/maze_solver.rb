# This class uses a breadth first approach to solve mazes. Therefore the
# solutions are guaranteed to be the shortest possible.
#
# Author:: Georg Konwisser (mailto:software@konwisser.de)
class MazeSolver

	require "set"
	require_relative 'model/possible_step'

	# Returns a list of MazeCell objects representing a path from cell
	# (_beg_x_, _beg_y_) to cell (_end_x_, _end_y_). If there is no such path this
	# method returns _nil_.
	def trace(maze, beg_x, beg_y, end_x, end_y)
		start_cell = maze.cell(beg_x, beg_y)
		@target_cell = maze.cell(end_x, end_y)
		@visited_cells = Set.new [start_cell]
		@possible_steps = []

		# Succeeds even in the rare case that a maze consists of only one cell or the
		# start cell is dead but the start cell is also the end cell.
		return [start_cell] if start_cell == @target_cell

		add_possible_steps(nil, start_cell)
		try_possible_steps
	end

	private

	# Tries all steps which are currently in the @possible_steps list. If there are
	# no possible steps to try this returns _nil_. If one of the possible steps leads
	# to the target cell, the corresponding full path from start cell to target cell
	# is returned as a list of MazeCell objects. Otherwise each currently possible
	# step is taken from the list while all possible new steps after this one are
	# added to the list. Then this method calls itself to try the new possible steps.
	def try_possible_steps()
		return nil if @possible_steps.empty?

		Array.new(@possible_steps).each do |step|
			next_cell = step.next_cell
			return path(step) if next_cell == @target_cell

			@possible_steps.delete_at(0)
			@visited_cells << next_cell
			add_possible_steps(step, next_cell)
		end

		try_possible_steps()
	end

	# Returns a list of MazeCell objects representing the complete path which ends
	# with _last_step_.
	# last_step:: a step which leads to the @target_cell
	def path(last_step)
		path_helper(last_step, last_step.next_cell)
	end

	def path_helper(prev_step, cur_cell)
		# recursion termination
		return [cur_cell] if prev_step.nil?

		# recursive call to add all previously visited cells
		path_helper(prev_step.previous_step, prev_step.start_cell) << cur_cell
	end

	# Assuming we are currently in cell _cur_cell_ this adds all possible steps in
	# this situation. Steps which lead to cells which were already visited by other
	# steps are not added. Also impossible steps (e.g. through walls) are not added.
	# prev_step::
	# 	the step which led to _cur_cell_ or _nil_ if _cur_cell_ is the start cell
	# cur_cell:: the cell we are currently in
	def add_possible_steps(prev_step, cur_cell)
		[:left, :top, :right, :bottom].each do |dir|
			next_cell = cur_cell.neighbor(dir)
			next if next_cell.nil? || @visited_cells.include?(next_cell)

			@possible_steps << PossibleStep.new(prev_step, cur_cell, dir)
		end
	end
end