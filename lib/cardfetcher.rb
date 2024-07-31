require 'net/http'
require 'json'
require_relative 'decklist'

class Card
  attr_reader :id, :name, :type, :desc, :atk, :def, :color

  def initialize(data)
    @id = data['id']
    @name = data['name']
    @type = data['type']
    @desc = data['desc']
    @atk = data['atk']
    @def = data['def']
    @color = set_color(@type)
  end

  def to_s
    colorize(@name, @color)
  end

  private

  def set_color(type)
    case @type
    when /Monster/i
      31
    when /Spell/i
      32
    when /Trap/i
      "38;5;201"
    else 
      0
    end
  end

  def colorize(text, color_code)
    "\e[#{color_code}m#{text}\e[0m"
  end
end

class CardDatabase
  BASE_URL = 'https://db.ygoprodeck.com/api/v7/cardinfo.php'

  def self.fetch_card(name)
    uri = URI("#{BASE_URL}?name=#{URI.encode_www_form_component(name)}")
    response = Net::HTTP.get_response(uri)
    
    case response
    when Net::HTTPSuccess
      data = JSON.parse(response.body)
      if data['data'] && !data['data'].empty?
        Card.new(data['data'][0])
      else
        puts "Card not found: #{name}"
        nil
      end
    else
      puts "Failed to fetch card: #{name}. HTTP Status: #{response.code}"
      nil
    end
  rescue JSON::ParserError
    puts "Failed to parse response for card: #{name}"
    nil
  rescue SocketError
    puts "Network error while fetching card: #{name}"
    nil
  rescue => e
    puts "Unexpected error while fetching card #{name}: #{e.message}"
    nil
  end
end

class Deck
  attr_reader :cards, :failed_cards

  def initialize
    @cards = []
    @failed_cards = []
  end

  def add_card(name)
    card = CardDatabase.fetch_card(name)
    if card
      @cards << card
    else
      @failed_cards << name
    end
  end

  def remove_card(name)
    @cards.delete_if { |card| card.name == name }
  end

  def to_s
    @cards.join(", ")
  end
end

# Usage
deck = Deck.new

#MONSTER_ARR.each do |card| deck.add_card(card)

# Usage
deck = Deck.new

MONSTER_ARR.each { |card| deck.add_card(card) }
deck.add_card("Crossout Designator")
deck.add_card("Solemn Warning")
deck.add_card("Solemn Strike")

puts "Successfully added cards:"
puts deck

puts "\nFailed to add these cards:"
puts deck.failed_cards.join(", ")