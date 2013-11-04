require "pry"

class CardDeck 
  attr_reader :cards

  UNIVERSALDECK = [{ card_name: 'Ace', suit: :spades },
                   { card_name: '2', suit: :spades },
                   { card_name: '3', suit: :spades },
                   { card_name: '4', suit: :spades },
                   { card_name: '5', suit: :spades },
                   { card_name: '6', suit: :spades },
                   { card_name: '7', suit: :spades },
                   { card_name: '8', suit: :spades },
                   { card_name: '9', suit: :spades },
                   { card_name: '10', suit: :spades },
                   { card_name: 'Jack', suit: :spades },
                   { card_name: 'Queen', suit: :spades },
                   { card_name: 'King', suit: :spades },
                   { card_name: 'Ace', suit: :hearts },
                   { card_name: '2', suit: :hearts },
                   { card_name: '3', suit: :hearts },
                   { card_name: '4', suit: :hearts },
                   { card_name: '5', suit: :hearts },
                   { card_name: '6', suit: :hearts },
                   { card_name: '7', suit: :hearts },
                   { card_name: '8', suit: :hearts },
                   { card_name: '9', suit: :hearts },
                   { card_name: '10', suit: :hearts },
                   { card_name: 'Jack', suit: :hearts },
                   { card_name: 'Queen', suit: :hearts },
                   { card_name: 'King', suit: :hearts },
                   { card_name: 'Ace', suit: :diamonds },
                   { card_name: '2', suit: :diamonds },
                   { card_name: '3', suit: :diamonds },
                   { card_name: '4', suit: :diamonds },
                   { card_name: '5', suit: :diamonds },
                   { card_name: '6', suit: :diamonds },
                   { card_name: '7', suit: :diamonds },
                   { card_name: '8', suit: :diamonds },
                   { card_name: '9', suit: :diamonds },
                   { card_name: '10', suit: :diamonds },
                   { card_name: 'Jack', suit: :diamonds },
                   { card_name: 'Queen', suit: :diamonds },
                   { card_name: 'King', suit: :diamonds },
                   { card_name: 'Ace', suit: :clubs },
                   { card_name: '2', suit: :clubs },
                   { card_name: '3', suit: :clubs },
                   { card_name: '4', suit: :clubs },
                   { card_name: '5', suit: :clubs },
                   { card_name: '6', suit: :clubs },
                   { card_name: '7', suit: :clubs },
                   { card_name: '8', suit: :clubs },
                   { card_name: '9', suit: :clubs },
                   { card_name: '10', suit: :clubs },
                   { card_name: 'Jack', suit: :clubs },
                   { card_name: 'Queen', suit: :clubs },
                   { card_name: 'King', suit: :clubs }
                  ]
  
  def initialize (cards = [], game_type = "blackjack")

    case game_type
    when "blackjack"
     @cards = blackjack(UNIVERSALDECK)
    end
  end

  def blackjack(universal_deck)
    universal_deck.each do |card|
      if card[:card_name] == "Ace"
        value = 11
      elsif card[:card_name].to_i == 0
        value = 10
      else
        value = card[:card_name].to_i
      end
      card[:value] = value
    end
  end

end

class People

  attr_accessor :balance, :blackjack, :win, :loss, :type

  def initialize(type = :dealer, balance = 0, win = 0, loss = 0, blackjack = 0)
    @blackjack = blackjack
    @loss = loss
    @win = win  
    @balance = balance
    @type = type

  end

  def print_balance
    @balance
  end

end

class Dealer < People
  MUST_STAY = 17

  def initialize
    super
  end

  def status
    "Dealer wins #{@win} times, lose #{loss} times. #{blackjack} blackjack"
  end

end


class Player < People

  attr_reader :name

  def initialize(name)
    @name = name
    super(:player,10000)
  end

  def lose(money)
    @balance -= money
  end

  def win(money)
    @balance += money
  end

  def status
    "#{name} wins #{@win} times, lose #{loss} times. #{blackjack} blackjack"
  end

end


class GameDeck
  
  attr_reader :deck

  def initialize(number_of_deck = 1)
    @deck = []
    @origin = create_deck(CardDeck.new.cards)
    @deck = @deck * number_of_deck
    scramble
  end

  def create_deck(source_deck)
    source_deck.each_with_index do |value, index|
      index = Card.new(value)
      @deck << index
    end
  end

  def scramble
    @deck.shuffle!
  end

  def card_number
    @deck.size
  end

  def empty?
    return true if @deck.size = 0
  end

end

class Hand
  attr_reader :owner, :hand

  def initialize(owner, hand = [])
    @hand = hand
    @owner = owner

  end

  def receive_card(card_deck)
    card = card_deck.deck.shift
    @hand << card
    
  end

  def check_a?
    @hand.any? { |card| card.name == 'Ace' }
  end

  def check_blackjack?
    if @hand.size == 2 && @value == 21 
      return true
    else 
      return false
    end
  end

  def compensate_ace_value
    aces = ace_number
    hand_value = value
    aces.times { hand_value -= 10 if hand_value > 21 }
    return hand_value
  end

  def to_s
    @hand.each{ |card| puts "#{card.name} of #{card.suit}" }
  end

  def bust?
    return true if value > 21
  end

  def value
    @hand.map { |s| s.value }.reduce(0, :+)
  end

  def ace_number
    count = 0
    @hand.each do |card|
     count = count + 1 if card.name == "Ace"
    end
    return count
  end

end

class Card
  attr_accessor :show
  attr_reader :suit, :name, :value

  def initialize(card, show = true)
    @value = card[:value]
    @suit = card[:suit]
    @name = card[:card_name]
    @show = show
  end

  def show?
    @show
  end 

  def is_ace?
    return true if @name == "Ace"
  end

  def to_s
    if @show
      "#{name} of #{suit}"
    else
      "The card is hidden"
    end
  end

end

#I need to develop a working demo to fill the match class

class Match
@@stats_wins = 0
@@stats_lose = 0
@@stats_blackjack = 0
@@total_matches = 0

# here I will pass players as array of objects. 

  def initialize(*players)
    @@total_matches += 1
  end


  def self.table_statistic
    "#{@@stats_wins} total wins, #{@@stats_blackjack} blackjack and \
     #{@@stats_lose} loses in #{@@total_matches} matches"
  end

  def match_win
    @@stats_wins += 1
  end

  def match_lose
    @@stats_lose += 1
  end

  def match_blackjack
    @@stats_blackjack += 1
  end

  def play
    #here i will put the single match procedure
  end

end

class BlackJack

  module Messages
    def welcome_message
      puts "Welcome to Las Vegas. Do you want to play Blackjack? "
      puts
      puts "1) Yes, I play"
      puts "2) No, I leave"
    end
  end

  include Messages

  def initialize
    dealer = Dealer.new
  end

  def run
    self.welcome_message

    while true 
      choice = gets.chomp
      case choice
      when "1"
        puts "gioco"
      when "2"
        exit
      else
        puts "Wrong selection, type again"
      end
    end
  end

  

end

blackjack = BlackJack.new
game = GameDeck.new
hand = Hand.new("roby")
hand.receive_card(game)
hand.receive_card(game)
hand.receive_card(game)


binding.pry

