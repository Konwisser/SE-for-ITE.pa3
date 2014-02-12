require_relative '../eclipse_test_case_workaround'
require_relative '../../model/maze'

# This is a unit test for the model class Maze.
#
# Author:: Georg Konwisser (mailto:software@konwisser.de)
class MazeTest < Test::Unit::TestCase

	def test_load
		maze = Maze.new(4, 4)
		maze.load("111111111100010001111010101100010101101110101100000101111011101100000101111111111")

		(0..3).each do |col|
			(0..3).each do |row|
				assert(!maze.cell(col, row).nil?, "cell (#{col},#{row}) should exist")
			end
		end

		[[-1,0], [4,4], [2,4]].each do |coord|
			assert(maze.cell(coord[0], coord[1]).nil?, "cell #{coord} should not exist")
		end
	end

	def test_coordinates
		maze = Maze.new(4, 4)
		maze.load("111111111100010001111010101100010101101110101100000101111011101100000101111111111")

		cell_1_3 = maze.cell(1, 3)
		assert_equal(1, cell_1_3.column)
		assert_equal(3, cell_1_3.row)

		cell_1_2 = maze.cell(1, 2)
		assert_equal(1, cell_1_2.column)
		assert_equal(2, cell_1_2.row)
	end

	def test_neighbors
		maze = Maze.new(4, 4)
		maze.load("111111111100010001111010101100010101101110101100000101111011101100000101111111111")

		cell_1_3 = maze.cell(1, 3)

		cell_1_2 = cell_1_3.neighbor(:top)
		assert_equal(1, cell_1_2.column)
		assert_equal(2, cell_1_2.row)

		cell_2_2 = maze.cell(2, 2)
		assert_equal(cell_2_2, cell_1_2.neighbor(:right))
	end

	def test_walls
		maze = Maze.new(4, 4)
		maze.load("111111111100010001111010101100010101101110101100000101111011101100000101111111111")

		cell_1_3 = maze.cell(1, 3)
		assert(cell_1_3.wall?(:bottom))
		assert(!cell_1_3.wall?(:right))

		cell_2_2 = maze.cell(2, 2)
		assert(!cell_2_2.wall?(:left))
		assert(!cell_2_2.wall?(:top))
		assert(cell_2_2.wall?(:right))
		assert(cell_2_2.wall?(:bottom))
	end

	def test_display
		maze = Maze.new(4, 4)
		maze.load("111111111100010001111010101100010101101110101100000101111011101100000101111111111")
		maze.display()
	end

	def test_redesign
		maze = Maze.new(4, 4)
		maze.load("111111111100010001111010101100010101101110101100000101111011101100000101111111111")

		5.times do
			maze.redesign()
			puts "redesign:"
			maze.display()
			puts
		end
	end
end