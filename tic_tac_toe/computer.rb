class Computer
  attr_reader :name, :mark

  def initialize(name, mark, vs)
    @name = name
    @mark = mark
    @vs_mark = vs
  end

  def get_move(board)
    board.best_move(@mark, @vs_mark)
  end
end
