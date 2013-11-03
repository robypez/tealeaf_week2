require "pry"

class CardDeck 
  attr_reader :cards

  UNIVERSALDECK = [{ card: 'Ace', suit: :spades },
                   { card: '2', suit: :spades },
                   { card: '3', suit: :spades },
                   { card: '4', suit: :spades },
                   { card: '5', suit: :spades },
                   { card: '6', suit: :spades },
                   { card: '7', suit: :spades },
                   { card: '8', suit: :spades },
                   { card: '9', suit: :spades },
                   { card: '10', suit: :spades },
                   { card: 'Jack', suit: :spades },
                   { card: 'Queen', suit: :spades },
                   { card: 'King', suit: :spades },
                   { card: 'Ace', suit: :hearts },
                   { card: '2', suit: :hearts },
                   { card: '3', suit: :hearts },
                   { card: '4', suit: :hearts },
                   { card: '5', suit: :hearts },
                   { card: '6', suit: :hearts },
                   { card: '7', suit: :hearts },
                   { card: '8', suit: :hearts },
                   { card: '9', suit: :hearts },
                   { card: '10', suit: :hearts },
                   { card: 'Jack', suit: :hearts },
                   { card: 'Queen', suit: :hearts },
                   { card: 'King', suit: :hearts },
                   { card: 'Ace', suit: :diamonds },
                   { card: '2', suit: :diamonds },
                   { card: '3', suit: :diamonds },
                   { card: '4', suit: :diamonds },
                   { card: '5', suit: :diamonds },
                   { card: '6', suit: :diamonds },
                   { card: '7', suit: :diamonds },
                   { card: '8', suit: :diamonds },
                   { card: '9', suit: :diamonds },
                   { card: '10', suit: :diamonds },
                   { card: 'Jack', suit: :diamonds },
                   { card: 'Queen', suit: :diamonds },
                   { card: 'King', suit: :diamonds },
                   { card: 'Ace', suit: :clubs },
                   { card: '2', suit: :clubs },
                   { card: '3', suit: :clubs },
                   { card: '4', suit: :clubs },
                   { card: '5', suit: :clubs },
                   { card: '6', suit: :clubs },
                   { card: '7', suit: :clubs },
                   { card: '8', suit: :clubs },
                   { card: '9', suit: :clubs },
                   { card: '10', suit: :clubs },
                   { card: 'Jack', suit: :clubs },
                   { card: 'Queen', suit: :clubs },
                   { card: 'King', suit: :clubs }
                  ]
  
  def initialize (game_type = "blackjack")
    case game_type
    when "blackjack"
     @cards = blackjack(UNIVERSALDECK)
    end
  end

  def blackjack(universal_deck)
    universal_deck.each do |card|
      if card[:card] == "Ace"
        value = 11
      elsif card[:card].to_i == 0
        value = 10
      else
        value = card[:card].to_i
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

  def bet(money)
    @balance -= money
  end

  def status
    "#{name} wins #{@win} times, lose #{loss} times. #{blackjack} blackjack"
  end

end



class GameDeck
  
  attr_reader :deck

  def initialize(number_of_deck = 1)
    @deck = CardDeck.new.cards * number_of_deck
    self.scramble
  end

  def take_card
    @deck.shift
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
  attr_reader :owner, :hand, :value, :ace_number

  def initialize(owner, hand = [])
    @hand = hand
    @owner = owner
    @value = 0
    @ace_number = 0

  end

  def receive_card(card)
    if card.is_ace?
      @ace_number += 1
    end
    @hand << card.params
    @value += card.value
  end

  def check_a?
    @hand.any? { |card| card[:card] == 'Ace' }
  end

  def check_blackjack?
    if @hand.size == 2 && @value == 21 
      return true
    else 
      return false
    end
  end

  def compensate_ace_value
    @ace_number.times { @value -= 10 if @value > 21 }
    return @value
  end

  def to_s
    @hand.each{ |card| puts "#{card[:card]} of #{card[:suit]}" }
  end

  def bust?
    return true if @value > 21 else return false
  end

end

class Card
  attr_accessor :show
  attr_reader :suit, :name, :value, :params

  def initialize(card, show = true)
    @value = card[:value]
    @suit = card[:suit]
    @name = card[:card]
    @params = card
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

#I need to go develop a working demo to write the match object

class Match(*players)
@@match_numbers

  def initialize

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
    game = GameDeck.new(4)
   
  end

  def run
    self.welcome_message

    while true 
      choice = gets.chomp
      case choice
      when "1"
        puts "game"
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
card1 = Card.new(game.take_card)
card2 = Card.new(game.take_card)
player_hand = Hand.new("player")
player_hand.receive_card(card1)
player_hand.receive_card(card2)

binding.pry

