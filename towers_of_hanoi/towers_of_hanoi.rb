class TowersOfHanoi
  attr_reader :towers

  def initialize(number_disks=3)
    @towers = [[], [], []]
    @num = number_disks
    place_disks(number_disks)
  end

  def self.set_up
    print "\n\n__________WELCOME TO TOWERS OF HANOI__________\n\n"
    print "To play:\n"
    print "You must move all the disks from Tower 1 to either 2 or 3.\n"
    print "• You can only move the uppermost from a tower.\n"
    print "• You cannot move a larger disk onto a smaller one.\n"
    print "Type the tower numbers with a space to separate. Then Enter.\n"
    print "i.e. (1 2)\n\n"
    print "How many disks would you like to play with? (3 is default) : "
    num = gets.chomp.to_i
    print "\n\n"
    game = TowersOfHanoi.new(num)
    game.play
  end

  def play
    turns = 0
    render
    until won?
      from, to = get_play
      move_disk(from, to)
      render
      turns += 1
    end
    render
    print "CONGRATULATIONS! You won!\nIt took you #{turns} turns.\n\n"
  end

  private

  def get_play
    print "What tower are you moving from, to? : "
    i = true
    while i
      input = gets.chomp
      if !(input[/^(1|2|3)\s(1|2|3)$/] == input)
        print "Incorrect format or numbers. Try again : "
        next
      end
      from, to = input.split.map {|n| n.to_i - 1}
      if !valid_move?(from, to)
        print "Invalid move. Try again : "
        next
      end
      i = false
    end
    [from, to]
  end

  def move_disk(from, to)
    disk = @towers[from].pop
    @towers[to] << disk
  end

  def place_disks(number_disks)
    (1..number_disks).each {|num| @towers[0].unshift((num*2)-1)}
  end

  def render
    print "\n"
    (0..@num-1).to_a.reverse.each do |i|
      @towers.each do |tower|
        tower[i] ? (print "|#{r_pad("x"*tower[i])}") : (print "|#{r_pad(" ")}")
      end
      print "|\n"
    end
    print " #{r_pad("1")} #{r_pad("2")} #{r_pad("3")}"
    print "\n\n"
  end

  def r_pad(var)
    var.to_s.center(@num*2+3)
  end

  def valid_move?(from, to)
    return false if @towers[from].empty?
    return true if @towers[to].empty?
    return false if @towers[from][-1] > @towers[to][-1]
    true
  end

  def won?
    return true if (@towers[1].length == @num) || (@towers[2].length == @num)
    false
  end
end

if __FILE__ == $PROGRAM_NAME
  TowersOfHanoi.set_up
end
