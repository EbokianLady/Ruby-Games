class Computer
  attr_reader :name, :board, :last_move

  def initialize(name, board)
    @name = name
    @board = board
    @last_move = nil
  end

  def get_move(board)
    pos = board.hits.empty? ? searching(board) : target_acquired(board)
    @last_move = pos
    pos
  end

  def place_ships
    placement = ShipPlacement.new(self)
    placement.place_all_ships
  end

  private

  def random_move(board)
    board.possible_attacks(board.largest_unsunk).sample
  end

  # looks for the largest unsunk ship by moving that "size" in a random
  # direction from it's last targeted coords
  # will only choose coords from positions that can "fit" the sought ship
  def scan_for_largest(board)
    ship = board.largest_unsunk
    num = ship.size
    return nil if @last_move == nil
    options = []
    options << (@last_move-num) if (@last_move-num)/10 == @last_move/10
    options << (@last_move+num) if (@last_move+num)/10 == @last_move/10
    options << [@last_move-num*10, @last_move+num*10]
    options.flatten.select {|pos| board.valid_attack?(ship, pos)}.sample
  end

  # determines next move from @last_move by moving the sought ship's length in
  # any direction. Chooses randomly if directional search results in nil.
  def searching(board)
    puts "#{@name} is scanning the waters ..."
    pos = scan_for_largest(board)
    pos = random_move(board) if pos == nil
    pos
  end

  # chooses coords adjacent to hits, prioritizing direction when possible
  def target_acquired(board)
    puts "#{@name} has acquired a target.\nPrepare for imminent destruction."
    if board.hits.length == 1
      board.pos_cross(board.hits[0]).sample
    else
      target_direction(board, board.hits.sort)
    end
  end

  def target_direction(board, hits)
    options = []
    if hits[0]/10 == hits[1]/10
      hits.each {|pos| options << board.pos_horizontal(pos)}
    else
      hits.each {|pos| options << board.pos_vertical(pos)}
    end

    # just in case the direction yields no result, both directions for each pos
    hits.each {|pos| options << board.pos_cross(pos)} if options.flatten.empty?

    options.flatten.sample
  end
end
