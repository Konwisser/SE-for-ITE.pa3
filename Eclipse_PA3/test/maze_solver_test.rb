require_relative 'eclipse_test_case_workaround'
require_relative '../model/maze'
require_relative '../maze_solver'

# This is a unit test for the utility class MazeSolver.
#
# Author:: Georg Konwisser (mailto:software@konwisser.de)
class MazeSolverTest < Test::Unit::TestCase

	def test_find_path
		maze = Maze.new(4, 4)
		maze.load("111111111100010001111010101100010101101110101100000101111011101100000101111111111")

		expected_coords = [[1,1], [0,1], [0,2], [1,2], [2,2], [2,1], [2,0], [3,0], [3,1], [3,2], [3,3]]
		check_path_bidirectional(maze, expected_coords, 1, 1, 3, 3)
	end

	def check_path_bidirectional(maze, expected_coords, start_x, start_y, end_x, end_y)
		calculated = MazeSolver.new.trace(maze, start_x, start_y, end_x, end_y)
		check_path(maze, expected_coords, calculated)

		calculated = MazeSolver.new.trace(maze, end_x, end_y, start_x, start_y)
		check_path(maze, expected_coords.reverse, calculated)
	end

	def check_path(maze, expected_coords, calculated)
		assert_equal(expected_coords.length, calculated.length)

		(0..(expected_coords.length - 1)).each do |i|
			expected = maze.cell(expected_coords[i][0], expected_coords[i][1])
			assert_equal(expected, calculated[i])
		end
	end

	def test_find_shortest_path
		#		1 1 1 1 1 1 1 1 1
		#		1 0 0 0 1 0 0 0 1
		#		1 1 1 0 1 0 1 0 1
		#		1 0 0 0 1 0 1 0 1
		#		1 0 1 1 1 0 1 0 1
		#		1 0 0 S 0 0 1 0 1
		#		1 1 1 0 1 1 1 0 1
		#		1 0 0 0 1 0 0 E 1
		#		1 1 1 0 1 0 1 0 1
		#		1 0 0 0 0 0 1 0 1
		#		1 1 1 1 1 1 1 1 1
		# starting in S and going down leads in 6 steps to E whereas going right from S
		# takes 8 steps to E
		maze = Maze.new(4, 5)
		maze.load("111111111100010001111010101100010101101110101100000101111011101100010001111010101100000101111111111")
		# maze.display()

		expected_coords = [[1,2], [1,3], [1,4], [2,4], [2,3], [3,3]]
		check_path_bidirectional(maze, expected_coords, 1, 2, 3, 3)
	end

	def test_no_path_exists
		#		1 1 1 1 1 1 1 1 1
		#		1 0 0 0 1 0 1 0 1
		#		1 1 1 0 1 0 1 0 1
		#		1 0 0 0 1 0 1 0 1
		#		1 0 1 1 1 0 1 0 1
		#		1 0 0 S 0 0 1 0 1
		#		1 1 1 0 1 1 1 0 1
		#		1 0 0 0 1 0 1 E 1
		#		1 1 1 0 1 0 1 0 1
		#		1 0 0 0 0 0 1 0 1
		#		1 1 1 1 1 1 1 1 1
		maze = Maze.new(4, 5)
		maze.load("111111111100010101111010101100010101101110101100000101111011101100010101111010101100000101111111111")
		maze.display()

		assert_equal(nil, MazeSolver.new.trace(maze, 1, 2, 3, 3))
	end

	def test_already_there
		maze = Maze.new(4, 5)
		maze.load("111111111100010101111010101100010101101110101100000101111011101100010101111010101100000101111111111")
		maze.display()

		check_path(maze, [[1, 2]], MazeSolver.new.trace(maze, 1, 2, 1, 2))
	end

end