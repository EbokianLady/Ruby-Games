class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(9)
  end

  def [](pos)
    @grid[pos]
  end

  def []=(pos, mark)
    @grid[pos] = mark
  end

  def best_move(mark, vs_mark)
    if can_win?(mark)
      locate_nil(can_win?(mark))
    elsif can_win?(vs_mark)
      locate_nil(can_win?(vs_mark))
    elsif @grid[4] == nil
      4
    elsif tactical_move?(vs_mark)
      random_edge
    elsif random_corner
      random_corner
    else
      random_edge
    end
  end

  def render
    abc = "ABC"
    print "\n\n    1   2   3\n"
    rows.each_with_index do |row, i|
      print "#{abc[i]} "
      row.each {|el| print el.is_a?(Symbol) ? "| #{el} " : "|   "}
      print "|\n"
    end
  end

  def triples
    rows + rows.transpose + diagonals
  end

  def valid_pos?(pos)
    return false if pos.to_s != pos.to_s[/^[0-8]$/]
    return false if @grid[pos] != nil
    true
  end

  private

  def all_positions
    rows = [[0, 1, 2], [3, 4, 5], [6, 7, 8]]
    diags = [[0, 4, 8], [2, 4, 6]]
    rows + rows.transpose + diags
  end

  def can_win?(mark)
    index = nil
    triples.each_with_index do |tri, i|
      index = i if (tri.count(mark) == 2 && tri.count(nil) == 1)
    end
    return false unless index
    index
  end

  def diagonals
    [[grid[0], grid[4], grid[8]], [grid[2], grid[4], grid[6]]]
  end

  def locate_nil(index)
    all_positions[index].each {|i| return i if @grid[i] == nil}
  end

  def random_corner
    [0, 2, 6, 8].select {|pos| @grid[pos] == nil}.sample
  end

  def random_edge
    [1, 3, 5, 7].select {|pos| @grid[pos] == nil}.sample
  end

  def tactical_move?(vs)
    corners = [0, 2, 6, 8].map {|pos| @grid[pos]}
    return true if corners == [vs, nil, nil, vs]
    return true if corners == [nil, vs, vs , nil]
    false
  end

  def rows
    [@grid[0..2], @grid[3..5], @grid[6..8]]
  end
end
