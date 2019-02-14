class Player
  attr_reader :name, :board

  def initialize(name, board)
    @name = name
    @board = board
  end

  def get_move(board)
    print "Where will #{@name} launch their missile? : "
    begin pos = gets.chomp
    end until pos.match(/^[0-9][0-9]$/) && board.valid_move?(pos.to_i)
    pos.to_i
  end

  def place_ships
    placement = ShipPlacement.new(self)
    placement.place_all_ships
  end
end
