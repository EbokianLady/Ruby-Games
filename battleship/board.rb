class Board
  attr_reader :grid, :ships, :hits

  def initialize
    @grid = Array.new(100) {" "}
    @ships = create_ships
    @hits = []
    @possibilities = (0..99).to_a
  end

  def attack(pos)
    if @grid[pos].is_a?(Ship)
      puts "\n#{HITS.sample.colorize(:red).bold}"
      @grid[pos].hit
      @grid[pos].sunk? ? @hits -= @grid[pos].coords : @hits << pos
      @grid[pos] = "x".colorize(:red).bold
    else
      puts "\n#{MISSES.sample.colorize(:blue).bold}"
      @grid[pos] = "o".colorize(:blue)
    end
  end

  def create_ships
    ships = []
    SHIPS.each {|name, size| ships << Ship.new(name, size)}
    ships
  end

  def empty?(pos)
    @grid[pos] == " "
  end

  def largest_unsunk
    @ships.reject {|ship| ship.status == "sunk"}[0]
  end

  def lost?
    @grid.none? {|pos| pos.is_a?(Ship)}
  end

  def pos_cross(pos)
    (pos_horizontal(pos) + pos_vertical(pos))
  end

  def pos_horizontal(pos)
    options = []
    options << pos-1 if pos/10 == (pos-1)/10
    options << pos+1 if pos/10 == (pos+1)/10
    options.select {|pos| valid_move?(pos)}
  end

  def pos_vertical(pos)
    options = []
    options << pos-10 if pos >= 10
    options << pos+10 if pos < 90
    options.select {|pos| valid_move?(pos)}
  end

  # final options will include multiples of the same pos, therefore random odds
  # are higher for more likely positions
  def possible_attacks(ship)
    options = []
    straights.each {|line| line.each_cons(ship.size) {|seg| options << seg}}
    options.select {|seg| seg.all? {|pos| valid_move?(pos)}}.flatten
  end

  def possible_ship_coords(ship)
    options = []
    straights.each {|line| line.each_cons(ship.size) {|seg| options << seg}}
    options.select {|seg| seg.all? {|pos| empty?(pos)}}
  end

  def remaining_ships
    unsunk = @ships.reject {|ship| ship.status == "sunk"}
    unsunk.map {|ship| "#{ship.name}(#{ship.size})"}.join(",\n")
  end

  def render(fow = true) #fow is fog_of_war
    s = fow ? " " : :s
    column = %w[00 10 20 30 40 50 60 70 80 90]
    print "    0  1  2  3  4  5  6  7  8  9\n"
    show = @grid.map {|pos| pos.is_a?(Ship) ? s : pos}
    show.each_slice(10) {|row| puts row.unshift(column.shift).join('  ')}
  end

  def rows
    rows = []
    (0..99).each_slice(10) {|row| rows << row}
    rows
  end

  def straights
    rows + rows.transpose
  end

  # #valid_attack? differs from #valid_move? in that it removes empty coords
  # that are "walled in" and do not leave enough space for the sought ship
  def valid_attack?(ship, pos)
    possible_attacks(ship).include?(pos)
  end

  def valid_move?(pos)
    (@grid[pos] == " " || @grid[pos].is_a?(Ship))
  end
end

# randomizes the hit/miss dialogue just for fun
HITS = ["A HIT!", "Ka-BOOM!", "Boooom!", "Ba-BOMB!"]
MISSES = ["Splish", "Sploosh", "Splash", "Ker-plunk"]

SHIPS = {
  "Aircraft Carrier" => 5,
  "Battleship" => 4,
  "Cruiser" => 3,
  "Submarine" => 3,
  "Destroyer" => 2
}
