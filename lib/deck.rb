require_relative 'decklist'
class Card
  attr_reader :name, :type, :color
  def initialize(name, type)
    @name = name
    @type = type
    @color = set_color(type)
  end

  def to_s
    colorize(@name, @color)
  end

  def set_color(type)
    case type
    when :monster
      31
    when :spell
      32
    when :trap
      "38;5;201"
    else 
      0
    end
  end

  def colorize(text, color_code)
    "\e[#{color_code}m#{text}\e[0m"
  end
end

class Deck
  attr_reader :cards

  def initialize(monsters, spells, traps)
    @cards = []
    monsters.each { |name| @cards << Card.new(name, :monster) }
    spells.each { |name| @cards << Card.new(name, :spell) }
    traps.each { |name| @cards << Card.new(name, :trap) }
    @cards.shuffle!
  end

  def deck_count
    monster_count = @cards.count { |count| card.type == :monster }
    spell_count = @cards.count { |count| card.type == :spell }
    trap_count = @cards.count { |count| card.type == :trap }
    total = @cards.length

    puts puts "Monsters: #{monster_count.to_s.ljust(3)} | " \
    "Spells: #{spell_count.to_s.ljust(3)} | " \
    "Traps: #{trap_count.to_s.ljust(3)} | " \
    "Total: #{total}"
  end

  def sample_hand(cards = 5)
    puts @cards.first(cards)
  end
  def draw(cards = 1)
    puts @cards.shift(cards)
  end
  def shuffle!
    @cards.shuffle!
  end
end

ancient = Deck.new(MONSTER_ARR, SPELL_ARR, TRAP_ARR)

ancient.draw