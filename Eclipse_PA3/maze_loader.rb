# This utility class sets the walls between maze cells based on a binary
# representation of the whole maze.
#
# Author:: Georg Konwisser (mailto:software@konwisser.de)
class MazeLoader

	def set_walls(maze, binary_maze)
		(0..(maze.rows - 1)).each do |row|
			(0..(maze.columns - 1)).each do |col|
				set_wall(maze, col, row, :right, binary_maze)
				set_wall(maze, col, row, :bottom, binary_maze)
			end
		end
	end

	private

	# Sets a wall at the right or bottom side of the provided cell if _binary_maze_
	# has a '1' at the corresponding index.
	# maze:: the maze to be updated
	# col:: the column of the cell
	# row:: the row of the cell
	# dir:: either _:right_ or _:bottom_
	# binary_maze:: the string of ones and zeros which defines the whole maze
	def set_wall(maze, col, row, dir, binary_maze)
		# row in the binary maze which contains the wall char, starting at 0
		bin_row = (dir == :right ? row * 2 + 1 : row * 2 + 2)

		# column in the binary maze which contains the wall char, starting at 0
		bin_col = (dir == :right ? col * 2 + 2 : col * 2 + 1)

		# the index of the character in the binary maze string which defines the right
		# wall of the requested cell
		char_index = bin_row * (2 * maze.columns + 1) + bin_col

		maze.cell(col, row).set_wall(dir) if binary_maze[char_index] == '1'
	end
end