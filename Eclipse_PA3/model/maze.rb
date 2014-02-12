# This model class represents a single maze with all its fields and walls.
#
# Author:: Georg Konwisser (mailto:software@konwisser.de)
class Maze

	require_relative 'maze_cell'

	# Creates a new Maze object with _columns_num_ columns and _rows_num_ rows.
	def initialize(columns_num, rows_num)
		@rows_num, @columns_num = rows_num, columns_num

		# [row, column] as key, MazeCell objects as value
		@cells = {}

		init_cells
	end

	# binary_maze:: the string of ones and zeros which defines the whole maze
	def load(binary_maze)
		(0..(@rows_num - 1)).each do |row|
			(0..(@columns_num - 1)).each do |col|
				set_wall(col, row, :right, binary_maze)
				set_wall(col, row, :bottom, binary_maze)
			end
		end
	end

	# Returns the cell at the given coordinate or nil if the coordinates are out of
	# bound or illegal.
	def cell(column, row)
		@cells[[column, row]]
	end

	private

	# Sets a wall at the right or bottom side of the provided cell if _binary_maze_
	# has a '1' at the corresponding index.
	# col:: the column of the cell
	# row:: the row of the cell
	# dir:: either _:right_ or _:bottom_
	# binary_maze:: the string of ones and zeros which defines the whole maze
	def set_wall(col, row, dir, binary_maze)
		# row in the binary maze which contains the wall char, starting at 0
		bin_row = (dir == :right ? row * 2 + 1 : row * 2 + 2)

		# column in the binary maze which contains the wall char, starting at 0
		bin_col = (dir == :right ? col * 2 + 2 : col * 2 + 1)

		# the index of the character in the binary maze string which defines the right
		# wall of the requested cell
		char_index = bin_row * (2 * @columns_num + 1) + bin_col

		cell(col, row).set_wall(dir) if binary_maze[char_index] == '1'
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
		(0..(@rows_num - 1)).each do |row|
			(0..(@columns_num - 1)).each do |col|
				add_cell(col, row)
			end
		end
	end
end