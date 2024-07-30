require 'net/http'
require 'json'
require_relative 'decklist'

class Card
  attr_reader :id, :name, :type, :desc, :atk, :def

  def initialize(data)
    @id = data['id']
    @name = data['name']
    @type = data['type']
    @desc = data['desc']
    @atk = data['atk']
    @def = data['def']
  end
end

class CardDatabase
  BASE_URL = 'https://db.ygoprodeck.com/api/v7/cardinfo.php'

  def self.fetch_card(name)
    uri = URI("#{BASE_URL}?name=#{URI.encode_www_form_component(name)}")
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
    Card.new(data['data'][0])
  rescue
    puts "Failed to fetch card: #{name}"
    nil
  end
end

class Deck
  attr_reader :cards

  def initialize
    @cards = []
  end

  def add_card(name)
    card = CardDatabase.fetch_card(name)
    @cards << card if card
  end

  def to_s
    @cards.map(&:name).join(", ")
  end
end

# Usage
deck = Deck.new

MONSTER_ARR.each do |card| deck.add_card(card)
end

puts deck