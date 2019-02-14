class ShipPlacement
  def initialize(player)
    @player = player
    @board = player.board
  end

  def place_all_ships
    if @player.is_a?(Computer)
      randomly_place_all
    else
      print "Would #{@player.name} like to place their own ships? (y/n) : "
      begin answer = gets.chomp.downcase
      end until answer.match(/[yn]/) #y or n, otherwise #gets repeats
      answer == "y" ? manually_place_all : randomly_place_all
      puts
      @board.render(false)
    end
  end

  def place_ship(ship, coords)
    ship.coords = coords
    coords.each {|pos| @board.grid[pos] = ship}
  end

  private

  def coord_options(ship, pos)
    options = @board.possible_ship_coords(ship).select {|seg| seg[0] == pos}
    options.select {|seg| seg.all? {|pos| @board.grid[pos] == " "}}
  end

  def horizontal_vertical?(options)
    return options[0] if options.length == 1
    print "Horizontal or vertical? (h/v) : "
    begin answer = gets.chomp.downcase
    end until answer.match(/[hv]/)
    answer == "h" ? options[0] : options[1]
  end

  def manually_place_all
    @board.ships.each {|ship| manually_place_one(ship)}
  end

  def manually_place_one(ship)
    puts
    @board.render(false)
    puts "\nWhere would you like to place your #{ship.name} (#{ship.size})?"
    print "Enter the top-left most coordinate : "
    begin pos = gets.chomp
    end until (pos.match(/^[0-9][0-9]$/) && !coord_options(ship, pos.to_i).empty?)
    coords = horizontal_vertical?(coord_options(ship, pos.to_i))
    place_ship(ship, coords)
  end

  def randomly_place_all
    @board.ships.each {|ship| randomly_place_one(ship)}
  end

  def randomly_place_one(ship)
    coords = @board.possible_ship_coords(ship).sample
    place_ship(ship, coords)
  end
end
