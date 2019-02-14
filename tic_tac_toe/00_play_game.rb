require_relative "board.rb"
require_relative "computer.rb"
require_relative "player.rb"

class Game
  attr_reader :board, :player1, :player2

  def initialize(player1, player2)
    @board = Board.new
    @player1 = player1
    @player2 = player2
    @current = @player1
  end

  def self.set_up
    print "\n\n__________WELCOME TO TIC-TAC-TOE__________\n\n"
    print "To play:\n"
    print "You must get three marks in a row before your opponent.\n"
    print "Type the row letter then column number. Then Enter.\n"
    print "i.e. (a2)\n\nBut first:\n"
    print "Is player 1 a computer or player? (p or c) : "
    if gets.chomp.downcase == "p"
      print "What is their name? : "
      name = gets.chomp
      player1 = Player.new(name, :X, :O)
    else
      player1 = Computer.new("Computer_1", :X, :O)
    end

    print "\nIs player 2 a computer or player? (p or c) : "
    if gets.chomp.downcase == "p"
      print "What is their name? : "
      name = gets.chomp
      player2 = Player.new(name, :O, :X)
    else
      player2 = Computer.new("Computer_2", :O, :X)
    end

    game = Game.new(player1, player2)
    game.play_game
  end

  def play_game
    until over?
      play_turn
      break if won?
      switch_players
    end

    @board.render
    puts "\nGAME OVER!"
    print won? ? "#{@current.name} has won.\n\n" : "It's a draw.\n\n"
  end

  private

  def over?
    @board.grid.none? {|el| el == nil}
  end

  def place_mark(pos, mark)
    @board[pos] = mark
  end

  def play_turn
    @board.render
    move = @current.get_move(@board)
    place_mark(move, @current.mark)
  end

  def switch_players
    @current == @player1 ? @current = @player2 : @current = @player1
  end

  def won?
    @board.triples.any? do |tri|
      tri.all? {|el| el == :X} || tri.all? {|el| el == :O}
    end
  end
end


if __FILE__ == $PROGRAM_NAME
  Game.set_up
end
