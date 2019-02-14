class Ship
  attr_accessor :coords
  attr_reader :name, :size, :hp, :status

  def initialize(name, size)
    @name = name
    @size = size
    @hp = size
    @status = "unhit"
    @coords = nil
  end

  def hit
    @hp -= 1
    @hp == 0 ? sunk : @status = "hit"
  end

  def sunk
    puts "Blub-blub_blub. \nThe #{@name} has been sunk."
    @status = "sunk"
  end

  def sunk?
    @status == "sunk"
  end
end
