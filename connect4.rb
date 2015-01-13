# This program runs a game of connect4 between two players: X and O. X plays first.

class Board
	attr_accessor :columns

	def initialize
		@columns = Array.new(7) {Column.new}
	end

	def play
		while true
			self.print_board
			puts "#{@@turn}'s turn! Please select a column"
			column = self.read_column
			if @columns[column].is_full?
				print "\nThat column is full! Please select again"
			# drop_chip returns a winning move
			elsif drop_chip(column)
				self.print_board
				puts "#{@@turn} WINS!"
				break
			# after drop_chip returns, reporting no winning move, a full board 
			# leads to a draw
			elsif self.is_full?
					self.print_board
					puts "It's a draw! Well played!"
					break
			end
		end
	end

	def read_column
		while true
			column = gets.chomp
			# verify input is integer
			if !column.is_integer?
				puts "You must enter a number! Please try again"
				next
			else
				column = column.to_i
			end
			# verify integer input is within valid range
			if column < 0 || column > 6
				puts "Sorry, you entered an invalid column! Please try again"
				next
			end

			return column
		end
	end

	def print_board
		print "\n"
		# rows
		for i in 0..5
			# columns
			print "| "
			for j in 0..6
				print "#{self.columns[j].rows[5-i]} "
			end
			print "|\n"
		end
		puts "|---------------|"
		print "| 0 1 2 3 4 5 6 |\n\n"
	end

	def is_full?
		for i in 0..6
			return false	if !@columns[i].is_full?
		end
		return true
	end

	def drop_chip(column)

		@columns[column].add_chip
		row = self.check_row(@columns[column].last_slot)
		col = self.check_column(column)
		pos = self.check_diag_pos(@columns[column].last_slot, column)
		neg = self.check_diag_neg(@columns[column].last_slot, column)

		# if a winning move is played, one of the checks will be true
		if (row || col || pos || neg)
			return true
		
		# if there was no winning move, but all columns are now full, drop_chip
		# returns -1 to report a draw
		elsif 		
			for i in 0..6

			end
		end

		# Change turns
		if @@turn == "X"
			@@turn = "O"
		elsif @@turn == "O"
			@@turn = "X"
		end

		# no winning move, so drop_chip returns false and the game continues
		return false
	end

	def check_row(row)
		line = Array.new(7)
		for i in 0..6
			line[i] = @columns[i].rows[row]
		end
		check_line(line)
	end

	def check_column(column)
		line = Array.new(7)
		for i in 0..5
			line[i] = @columns[column].rows[i]
		end
		check_line(line)
	end

	# check the diagonal that goes from bottom-left to top-right
	def check_diag_pos(row, column)
		line = Array.new
		current_row = row
		current_col = column
		# find lowest point on positive diagonal
		while (current_row > 0 && current_col > 0) do
			current_row-= 1
			current_col-= 1
		end

		# fill the line with the diagonal from bottom to top
		while (current_row < 6 && current_col < 7) do
			line << @columns[current_col].rows[current_row]
			current_row+= 1
			current_col+= 1
		end

		return check_line(line)
	end

	# check the diagonal that goes from top-left to bottom-right
	def check_diag_neg(row, column)
		line = Array.new
		current_row = row
		current_col = column
		# find lowest point on positive diagonal

		while (current_row < 5 && current_col > 0)
			current_row+= 1
			current_col-= 1
		end
		# fill the line with the diagonal from bottom to top
		while (current_row >= 0 && current_col < 7)
			line << @columns[current_col].rows[current_row]
			current_row-= 1
			current_col+= 1
		end

		return check_line(line)
	end

	# take a line of length between 1 and 7, and check for 4 consecutive slots 
	# that have state == @@turn
	def check_line(line)
		# ignore any lines too short to connect four
		unless line.length < 4
			i = 0
			# clear line of any leading blanks
			while line[i] == "-"
				i+= 1
			end
			# check for a row of four consecutive slots belonging to whoever played
			# last (@@turn is not changed until after all four lines are checked)
			count = 0
			until i == line.length+1
				if count == 4
					# if four consecutive slots are found, returning true will be
					# carried back up to indicate a winning move
					return true
				elsif line[i] == @@turn
					count += 1
				else
					count = 0
				end
				###################################
				# print line[i]
				###################################
				i += 1
			end

			################################### 
			# print "\n"
			###################################
			# if four consecutive slots are not found, check_line returns false
			return false
		end
	end
end

class Column
	attr_accessor :rows

	def initialize
		@rows = Array.new(6) {"-"}
	end

	def next_slot
		for i in 0..5
			return i if @rows[i] == "-" 
		end
			# a full column means no next slot, so return -1
			return -1
	end

	def last_slot
		# empty column
		if self.next_slot == 0
			return 0
		# full column
		elsif self.next_slot == -1
				return 5
		else
			return self.next_slot - 1
		end
	end

	def add_chip
		# Find lowest unfilled slot
		row = self.next_slot
		# Add chip
		@rows[row] = @@turn
	end

	def is_full?
		return !(@rows.include?("-"))
	end

end


# added is_integer? for input verification. found code below
# http://stackoverflow.com/questions/1235863/test-if-a-string-is-basically-an-integer-in-quotes-using-ruby
class String
	def is_integer?
		self.to_i.to_s == self
	end
end
################################################################################

@@turn = "X"
board = Board.new
board.play