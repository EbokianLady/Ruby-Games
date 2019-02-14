class Player
  attr_reader :name, :mark

  def initialize(name, mark, vs)
    @name = name
    @mark = mark
    @vs_mark = vs
  end

  def get_move(board)
    convert = {"a" => 0, "b" => 3, "c" => 6}
    i = true

    while i
      print "\nWhere will #{@name} place their #{@mark}? : "
      move = gets.chomp.downcase

      if move != move[/^(a|b|c)[1-3]$/]      #confirm valid letter-number combo
        puts "Invalid format. Try again."
        next
      end

      pos = (convert[move[0]] + move[1].to_i - 1)

      if !board.valid_pos?(pos)
        puts "That position is already marked. Try again."
        next
      end

      break
    end
    pos
  end
end
