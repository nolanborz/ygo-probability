require_relative 'decklist'

class Deck
  attr_reader :monsters, :spells, :traps

  def initialize(monsters, spells, traps)
    @monsters = monsters.dup
    @spells = spells.dup
    @traps = traps.dup
    @total = monsters.length + spells.length + traps.length
  end
  def deck_count
    puts "Monsters: #{@monsters.length.to_s.ljust(3)} | " \
         "Spells: #{@spells.length.to_s.ljust(3)} | " \
         "Traps: #{@traps.length.to_s.ljust(3)} | " \
         "Total: #{@total}"
  end
end

agg = Deck.new(MONSTER_ARR, SPELL_ARR, TRAP_ARR)

agg.deck_count