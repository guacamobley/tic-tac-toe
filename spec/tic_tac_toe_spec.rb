require "./tic_tac_toe.rb"

RSpec.describe ("tic tac toe") do
  describe ("#winner") do
    it "detects when X has won the top row" do
      board = Board.new(3)
      1.upto(9) {|index|
        board.get_square(index).mark = [1,2,3].include?(index) ? "X" : ""
      }

      expect(board.winner).to eql("X")
    end
    it "detects when X has won a diagonal" do
      board = Board.new(3)
      1.upto(9) {|index|
        board.get_square(index).mark = [1,5,9].include?(index) ? "X" : ""
      }
      expect(board.winner).to eql("X")
    end
    it "detects when X has won a full board" do
      board = Board.new(3)
      1.upto(9) {|index|
        board.get_square(index).mark = [1,3,5,7,8].include?(index) ? "X" : "O"
      }
      expect(board.winner).to eql("X")
    end
    it "detects when O has won a full board" do
      board = Board.new(3)
      1.upto(9) {|index|
        board.get_square(index).mark = [1,3,5,7].include?(index) ? "O" : "X"
      }
      expect(board.winner).to eql("O")
    end

    it "detects when no one has won a full board" do
      board = Board.new(3)
      1.upto(9) {|index|
        board.get_square(index).mark = [1,2,5,6,7].include?(index) ? "X" : "O"
      }
      expect(board.winner).to eql(false)
    end
  end

  describe ("#tie?") do
    it "detects when there is a tie" do
      board = Board.new(3)
      1.upto(9) {|index|
        board.get_square(index).mark = [1,2,5,6,7].include?(index) ? "X" : "O"
      }
      expect(board.tie?).to eql(true)
    end
    it "detects when the board is not yet full" do
      board = Board.new(3)
      1.upto(8) {|index|
        board.get_square(index).mark = [1,2,5,6].include?(index) ? "X" : "O"
      }
      expect(board.tie?).to eql(false)
    end
  end
end
