# Alternative version of Mastermind that will not pass the rspec tests
# Includes 6 colors and adjustable number of pegs and guesses
# Requires the colorize gem

require "colorize"

PEGS = {
  "R" => :red,
  "O" => :light_red,
  "Y" => :yellow,
  "G" => :green,
  "B" => :blue,
  "P" => :magenta
}

class Mastermind
  attr_reader :secret_code, :remaining_turns

  def initialize(length, turns)
    @length = length
    @secret_code = Mastermind.random(length)
    @remaining_turns = turns
    @won = false
  end

  def self.set_up
    puts "\n\nWelcome to MASTERMIND\n".colorize(:red)
    puts "Guess the right color pegs in the right order."
    puts "Your options are : R O Y G B P"

    print "\nHow many pegs would you like to guess? : "
    begin length = gets.chomp
    end until length.match(/^\d+$/)

    print "How many guesses would you like to have? : "
    begin turns = gets.chomp
    end until turns.match(/^\d+$/)

    puts "\nBEGIN PLAY".colorize(:blue)
    Mastermind.new(length.to_i, turns.to_i).play_game
  end

  def play_game
    until @won == true || @remaining_turns == 0
      play_turn
    end
    puts @won ? "\nCongrats! You've won." : "\nSorry, try again."
    render_pegs(@secret_code)
  end

  private

  def self.random(length)
    pegs = []
    length.times { pegs << PEGS.keys.sample }
    pegs
  end

  def play_turn
    @remaining_turns -= 1
    guess = get_guess
    @won = true if guess == @secret_code

    render_pegs(guess)
    guess_results(guess)
  end

  def get_guess
    print "\nWhat is your guess? : "
    guess = gets.chomp.upcase

    until guess.match(/^(R|O|Y|G|B|P)+$/) && guess.length == @length
      puts "\nIncorrect length or colors."
      print "Please enter #{@length} colors (R O Y G B P) : "
      guess = gets.chomp.upcase
    end

    guess.chars
  end

  def guess_results(guess)
    puts "exact: #{num_exact_match(guess)}\nnear: #{num_near_match(guess)}"
    puts "remaining guesses : #{@remaining_turns}"
    puts "--------------------"
  end

  def num_exact_match(guess)
    exact = 0
    (0...@length).each { |i| exact += 1 if @secret_code[i] == guess[i] }
    exact
  end

  def num_near_match(guess)
    match_hash = {}
    guess.each do |peg|
      num = @secret_code.count(peg) > guess.count(peg) ? guess.count(peg) : @secret_code.count(peg)
      match_hash[peg] = num
    end
    match_hash.values.sum - num_exact_match(guess)
  end

  def render_pegs(pegs)
    puts
    pegs.each { |peg| print peg.colorize(PEGS[peg])}
    puts "\n\n"
  end
end

if __FILE__ == $PROGRAM_NAME
  Mastermind.set_up
end
