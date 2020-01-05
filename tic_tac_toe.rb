class Square
  attr_accessor :mark

  def initialize
    @mark = ""
  end

  def empty?
    mark == ""
  end

  def ==(other)
    return false if self.empty? || other.empty?
    self.mark == other.mark ? true : false
  end

end

class Board
  attr_reader :squares
  attr_reader :size

  def get_square number
    #get a square from the array based on the number on the display
    square_column = (number -1) % size
    square_row = (number - square_column) / size

    squares[square_row][square_column]
  end

  def initialize size
    @size = size
    @squares = Array.new(size) {Array.new(size) {Square.new}}
  end

  def display
    squares.each_with_index {|row,row_index|
      display_separator(@size) unless row_index == 0
      display_row(row,row_index)
    }
  end


  def winner?
    if check_for_winner
      true
    else
      false
    end
  end

  def winner
    check_for_winner
  end

  def tie?
    !winner? && full?
  end

  private

  def full?
    #return true if the board is full.  false otherwise
    squares.all? do |row|
      row.none? { |square| square.empty?}
    end
  end

  def check_for_winner
    #returns the symbol that won
    lines_to_check.each do |line|
      if line.reduce { |a, b| (a == b) ? a : false}
        return line[0].mark unless line[0].empty?
      end
    end

    return false
  end

  def lines_to_check
    lines = get_rows + get_columns + get_diagonals
  end


  def get_rows
    #return an array of rows
    rows = []
    size.times{|index|
      rows << squares[index-1]
    }
    rows
  end

  def get_columns
    #return an array of columns
    columns = []
    size.times{|column_index|
      column = []
      size.times{|row_index|
        column << squares[row_index-1][column_index-1]
      }
      columns << column
    }
    columns
  end

  def get_diagonals
  #return the diagonals
    diagonal1 = []
    diagonal2 = []
    size.times{|row_index|
      size.times{|column_index|
        diagonal1 << squares[row_index][column_index] if row_index == column_index
        diagonal2 << squares[row_index][column_index] if row_index + column_index + 1 == size
      }
    }
    diagonals = [diagonal1,diagonal2]
  end


  def display_row row, row_index
    row.each_with_index{|square,square_index|
      print "|" unless square_index == 0

      square_to_display = square.empty? ? (row_index) * size + square_index + 1 : square.mark

      #ensures 2 characters are printed.  This allows games up to 9x9 to look similar
      print (square_to_display.to_s + ' ')[0,2]
    }
    print "\n"
  end

  def display_separator size
    (size * 3 - 1).times {print "-"}
    print "\n"
  end


end


class Game

  attr_accessor :whose_turn
  attr_reader :mark1,:mark2
  attr_reader :board



  def winner?
    board.winner?
  end

  def tie?
    board.tie?
  end

  def initialize board_size, mark1, mark2
    @board = Board.new(board_size)
    @mark1 = mark1
    @mark2 = mark2
    @whose_turn = mark1
  end

  def self.create_game
    Game.new 3, "X", "O"
  end

  def play_game
    until winner? || tie?

      board.display

      choice = prompt_player

      process_choice(choice)

      swap_turns
    end

    board.display

    if winner?
      display_winner
    else
      display_tie
    end
  end

  private

  def swap_turns
    self.whose_turn=((whose_turn == mark1) ? mark2 : mark1)
  end

  def display_winner
    winner = board.winner
    puts "Good job '#{winner}'!  You won!"
  end

  def display_tie
    puts "'#{mark1}' and '#{mark2}' tied!"
  end


  def process_choice choice
    board.get_square(choice).mark = whose_turn
  end

  def prompt_player
    #gets player choice
    loop{
      print "#{whose_turn}'s turn: in which square would you like to place your mark (1-#{board.size*board.size})?  "
      choice = 0
      begin
        choice = gets.chomp.to_i
        if (choice < 1 || choice > board.size*board.size)
          raise "user input should be between 1 and #{board.size*board.size}" 
        end
        board.get_square(choice)
      rescue
        puts "Error! Please choose from one of the displayed numbers"
        retry
      end
      return choice if board.get_square(choice).empty?
      puts "Please choose from one of the displayed numbers"
    }
  end
end

#game = Game.create_game

#game.play_game


