# This model class represents a single maze with all its fields and walls.
#
# Author:: Georg Konwisser (mailto:software@konwisser.de)
class Maze

	require_relative 'maze_cell'
	require_relative '../maze_solver'
	require_relative '../maze_loader'

	# the total number of rows in this maze (counting only cells, not walls)
	attr_reader :rows

	# the total number of columns in this maze (counting only cells, not walls)
	attr_reader :columns

	# Creates a new Maze object with _columns_num_ columns and _rows_num_ rows.
	def initialize(columns_num, rows_num)
		@rows, @columns = rows_num, columns_num

		# [row, column] as key, MazeCell objects as value
		@cells = {}

		init_cells
	end

	# Loads the maze from the provided string by creating corresponding data
	# structures.
	# binary_maze:: the string of ones and zeros which defines the whole maze
	def load(binary_maze)
		MazeLoader.new.set_walls(self, binary_maze)
	end

	# Returns the cell at the given coordinate or nil if the coordinates are out of
	# bound or illegal.
	def cell(column, row)
		@cells[[column, row]]
	end

	def display()
		puts "\n#{'+-' * @columns}+"

		(0..(@rows - 1)).each do |row|
			print '|'
			disp_row(row, :right, ' |', '  ')

			print "\n+"
			disp_row(row, :bottom, '-+', ' +')
			puts ''
		end
	end

	def solve(start_x, start_y, end_x, end_y)
		MazeSolver.new.trace(self, start_x, start_y, end_x, end_y).nil?
	end

	def trace(start_x, start_y, end_x, end_y)
		MazeSolver.new.trace(self, start_x, start_y, end_x, end_y)
	end

	private

	def disp_row(row, direction, wall_print, no_wall_print)
		(0..(@columns - 1)).each do |col|
			print cell(col, row).wall?(direction) ? wall_print : no_wall_print
		end
	end

	# Adds a new cell with the given coordinates. If neighbors of this cell were
	# already added, this sets the references from this cell to its neighbors and
	# vice versa.
	# returns:: the newly created cell
	def add_cell(column, row)
		new_cell = @cells[[column, row]] = MazeCell.new(column, row)

		new_cell.set_neighbor(:left, @cells[[column - 1, row]])
		new_cell.set_neighbor(:top, @cells[[column, row - 1]])
		new_cell.set_neighbor(:right, @cells[[column + 1, row]])
		new_cell.set_neighbor(:bottom, @cells[[column, row + 1]])

		new_cell
	end

	# initializes the cell grid without any walls
	def init_cells()
		(0..(@rows - 1)).each do |row|
			(0..(@columns - 1)).each do |col|
				add_cell(col, row)
			end
		end
	end
end