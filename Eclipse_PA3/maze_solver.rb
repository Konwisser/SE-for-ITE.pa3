# This class uses a breadth first approach to solve mazes. Therefore the
# solutions are guaranteed to be the shortest possible.
#
# Author:: Georg Konwisser (mailto:software@konwisser.de)
class MazeSolver

	require "set"
	require_relative 'model/step'
	require_relative 'model/maze_cell'

	# Returns a list of MazeCell objects representing a path from cell
	# (_beg_x_, _beg_y_) to cell (_end_x_, _end_y_). If there is no such path this
	# method returns _nil_.
	def trace(maze, beg_x, beg_y, end_x, end_y)
		start_cell = maze.cell(beg_x, beg_y)
		@target_cell = maze.cell(end_x, end_y)
		@visited_cells = Set.new [start_cell]
		@steps_queue = []

		# Succeeds even in the rare case that a maze consists of only one cell or the
		# start cell is dead but the start cell is also the end cell.
		return [start_cell] if start_cell == @target_cell

		add_possible_steps(nil, start_cell)
		try_possible_steps
	end

	private

	# Examines all possible steps which are currently in the queue, returns a
	# successful path as soon as a step is found which leads to the target cell,
	# removes each examined step, and adds new possible steps to the end of the queue
	# which result from doing the current step. If this process leads to an empty
	# queue there are no possible steps left and _nil_ is returned indicating that
	# there is no possible path to the target cell.
	def try_possible_steps()
		while !@steps_queue.empty? do
			step = @steps_queue.delete_at(0)
			@visited_cells << next_cell = step.to_cell
			return path(step) if next_cell == @target_cell

			add_possible_steps(step, next_cell)
		end

		return nil
	end

	# Returns a list of MazeCell objects representing the complete path which ends
	# with _step_.
	# step:: a step which leads to the @target_cell
	def path(step)
		# recursion termination
		return [step.from_cell, step.to_cell] if step.previous_step.nil?

		# recursive call to add all previously visited cells
		path(step.previous_step) << step.to_cell
	end

	# Assuming we are currently in cell _cur_cell_ this adds all possible steps in
	# this situation. Steps which lead to cells which were already visited by other
	# steps are not added. Also impossible steps (e.g. through walls) are not added.
	# prev_step::
	# 	the step which led to _cur_cell_ or _nil_ if _cur_cell_ is the start cell
	# cur_cell:: the cell we are currently in
	def add_possible_steps(prev_step, cur_cell)
		MazeCell::DIRECTIONS.each do |dir|
			next_cell = cur_cell.neighbor(dir)
			next if next_cell.nil? || @visited_cells.include?(next_cell)

			@steps_queue << Step.new(prev_step, cur_cell, dir)
		end
	end
end