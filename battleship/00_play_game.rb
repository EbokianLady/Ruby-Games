require_relative 'board.rb'
require_relative 'computer.rb'
require_relative 'player.rb'
require_relative 'ship_placement.rb'
require_relative 'ship.rb'
require 'colorize'

class Game
  attr_reader :player1, :player2, :current, :target

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @current = player1
    @target = player2
  end

  def self.set_up
    puts "\n\n____________WELCOME TO BATTLESHIP____________\n\n"
    puts "To play:"
    puts "Assign each player as a human or a computer."
    puts "Human players can place their own ships,"
    puts "  or have them placed randomly."
    puts "Once the battle begins,"
    puts "  choose your 2-digit coordinate. Then enter."
    puts "  (ie. 25)"
    puts "May the best Captain win!"
    player1 = create_player(1)
    player1.place_ships
    player2 = create_player(2)
    player2.place_ships
    game = Game.new(player1, player2)
    game.play_game
  end

  def self.create_player(num)
    print "\nIs Player #{num} a Computer or Human? (c/h) : "
    begin answer = gets.chomp.downcase
    end until answer.match(/[ch]/) #c or h, otherwise #gets repeats
    if answer == "c"
      Computer.new("Comp#{num}", Board.new)
    else
      print "What is their name? : "
      name = gets.chomp
      Player.new(name, Board.new)
    end
  end

  def play_game
    puts "\n\n  LET THE NAVAL BATTLE BEGIN!\n".colorize(:blue).bold
    until over?
      play_turn
      break if over?
      switch_players
    end
    render_boards
    puts "GAME OVER!".colorize(:red).bold
    puts "#{@current.name} has won the battle.\n\n"
  end

  # only renders the boards for Human players
  def play_turn
    puts "#{"----"*8}\n"
    render_boards if @current.is_a?(Player)
    render_enemy_ships if @current.is_a?(Player)
    pos = @current.get_move(@target.board)
    @target.board.attack(pos)
    puts
  end

  def switch_players
    if @current == @player1
      @current, @target = @player2, @player1
    else
      @current, @target = @player1, @player2
    end
  end

  def render_boards
    @target.board.render
    puts "#{"----"*8}\n"
    @current.board.render(false)
    puts "#{"----"*8}\n"
  end

  def render_enemy_ships
    puts "Enemy ships remaining:"
    puts "#{@target.board.remaining_ships}\n\n"
  end

  def over?
    @target.board.lost?
  end
end

if __FILE__ == $PROGRAM_NAME
  Game.set_up
end
