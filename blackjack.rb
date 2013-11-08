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

class GameDeck
  
  attr_reader :deck

  def initialize(number_of_deck = 1)
    @deck = []
    @origin = create_deck(CardDeck.new.cards)
    @deck = @deck * number_of_deck
    scramble
  end

  def create_deck(source_deck)
    source_deck.each do |value|
      @deck << Card.new(value)
    end
  end

  def scramble
    @deck.shuffle!
  end

  def empty?
    return true if @deck.size = 0
  end
end

class Card
  attr_accessor :show
  attr_reader :name, :value, :suit
  
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

class Dealer
  MUST_STAY = 17
end

class Player

  attr_reader :name
  attr_accessor :balance

  def initialize(name)
    @name = name
    @balance = 10000
  end

  def status
    "#{name} has #{@balance}$"
  end

  def win(money)
    @balance = money + money + @balance
  end

  def win_bj(money)
    @balance = @balance + (money + money + money/2)
  end
end

class Hand
  attr_reader :player
  attr_accessor :bet, :status, :cards

  def initialize(player)
    @cards = []
    @player = player
    @bet = 0
    @status = :no_bust_no_bj
  end

  def receive_card(card_deck, show = true)
    card = card_deck.deck.shift
    card.show = show
    @cards << card
  end

  def is_blackjack?
    if @cards.size == 2 && value == 21 
      return true
    else 
      return false
    end
  end

  def to_s
    @cards.each{ |card| puts card.to_s }
  end

  def value
    aces = ace_number
    hand_value = @cards.map { |s| s.value }.reduce(0, :+)
    aces.times { hand_value -= 10 if hand_value > 21 }
    return hand_value
  end

  def ace_number
    count = 0
    @cards.each do |card|
     count = count + 1 if card.name == "Ace"
    end
    return count
  end

  def can_split?
    return true if value == 20 && ace_number == 0 && @cards.size == 2
  end

  def split
    splitted_card = @cards.pop
    return splitted_card
  end
end

class Match

  def initialize(dealer, players, game_type)
    @player_hands = []
    @dealer_hand = Hand.new(dealer) 
    @players = players.each {|player| @player_hands << Hand.new(player)}
    @deck = GameDeck.new(game_type)
    play
  end

  private

  def play
    bet
    deal_card_dealer(false)
    deal_card
    deal_card_dealer
    deal_card
    check_player_blackjack(@player_hands)
    check_dealer_blackjack

    if player_blackjack_how_many? == @player_hands.size && @dealer_hand.status == :blackjack
      who_win
    elsif player_blackjack_how_many? > 0 && @dealer_hand.status == :blackjack
      who_win
    elsif player_blackjack_how_many? == @player_hands.size && @dealer_hand.status == :no_bust_no_bj
      who_win
    else
      player_turn
      dealer_turn
      who_win
    end 

  end

  def deal_card_dealer(show = true)
    @dealer_hand.receive_card(@deck, show)
  end

  def deal_card
    @player_hands.each do |player|
      player.receive_card(@deck)
    end
  end

  def check_player_blackjack(player_hands)
    player_hands.each do |hand|
      if hand.is_blackjack?
        puts "Wow, #{hand.player.name} has Blackjack"
        hand.status = :blackjack
        end
    end
  end

  def player_blackjack_how_many?
    bj = 0
    @player_hands.each do |hand|
      if hand.status == :blackjack
        bj += 1
      end   
    end
    return bj
  end

  def check_dealer_blackjack 
    if @dealer_hand.is_blackjack?
        puts "Wow, dealer has Blackjack"
        @dealer_hand.status = :blackjack
    end   
  end

  def bet
    @player_hands.each do |hand|
      puts "Hi #{hand.player.name}, you have #{hand.player.balance}$"
      puts "How much do you want to bet?"
      loop do
        input = gets.chomp.to_i
        if input > hand.player.balance
          puts "You don't have this money!!"
        elsif input <= hand.player.balance
          hand.bet = input
          hand.player.balance -= input
          break
        else
          puts "Type amount"
        end
      end
    end
  end

  def player_turn

    puts "Dealer has these cards"
    @dealer_hand.to_s
    puts
    i = 0
    while (i < @player_hands.length)
      hand = @player_hands[i]
      if hand.status == :no_bust_no_bj

        puts "#{hand.player.name}, you have these cards: "
        hand.to_s

        while hand.value < 22

          puts
          puts 'What do you want do do?'
          puts '1) Hit'
          puts '2) Stay'
          puts '3) Split' if hand.can_split?
          
          choice = gets.chomp

          if choice == '1'
            puts 'You choose to turn card'
            hand.receive_card(@deck)
            puts "#{hand.player.name}, you have these cards: "
            hand.to_s
            
            if hand.value > 21
              puts "You busted with #{hand.value}, I'm sorry"
              hand.status = :busted
              break
            elsif hand.value == 21
              break              
            else
              puts "You have #{hand.value}. What do you want to do?"
            end
          elsif choice == '3'
            new_hand = Hand.new(hand.player)
            new_hand.cards << hand.split
            hand.receive_card(@deck)
            new_hand.receive_card(@deck)
            new_hand.bet = hand.bet
            @player_hands.insert(i,new_hand)
            i -= 1
            break
            
          elsif choice == '2'
            break
          else
            if !['1', '2', '3' ].include?(choice)
            puts 'Error: you must enter 1 or 2'
            end
          end
        end
      end

      i += 1
    end

  end

  def dealer_turn
    puts "Dealer has"
    @dealer_hand.cards.each {|card| card.show = true}
    @dealer_hand.to_s
    puts

    while @dealer_hand.value < Dealer::MUST_STAY
      puts "The dealer has #{@dealer_hand.value} and must turn another card"
      @dealer_hand.receive_card(@deck)
      puts "Dealer now has #{@dealer_hand.value}"
      @dealer_hand.to_s
    
      if @dealer_hand.value.between?(Dealer::MUST_STAY, 21)
        puts "Dealer has #{@dealer_hand.value} and must stay"
        break
      elsif @dealer_hand.value > 21
        puts 'Dealer bust'
        @dealer_hand.status = :busted
        break
      end
    end
  end

  def who_win
    case @dealer_hand.status
    when :no_bust_no_bj
      @player_hands.each do |hand|
        case hand.status 
        when :busted
          puts "#{hand.player.name} busted"
        when :blackjack
          puts "#{hand.player.name} win with Blackjack"
          hand.player.win_bj(hand.bet)
        when :no_bust_no_bj
          if hand.value >= @dealer_hand.value 
            puts "#{hand.player.name} win with #{hand.value} against #{@dealer_hand.value}"
            hand.player.win(hand.bet)
          else
            puts "#{hand.player.name} lose with #{hand.value} against #{@dealer_hand.value}"
          end
        end
      end
    when :busted
      @player_hands.each do |hand|
        case hand.status 
        when :busted
          puts "#{hand.player.name} busted"
        when :blackjack
          puts "#{hand.player.name} win with Blackjack"
          hand.player.win_bj(hand.bet)
        when :no_bust_no_bj
          puts "#{hand.player.name} win, dealer bust"
          hand.player.win(hand.bet)
        end
      end
    when :blackjack
      @player_hands.each do |hand|
        if hand.status == :blackjack
          puts "#{hand.player.name} wins with Blackjack"
          hand.player.win_bj(hand.bet)
        else
          puts "#{hand.player.name} loses, dealer has Blackjack"
        end
      end
     end 
  end

end

class BlackJack

  module Interface

    def game_type
      
      puts "You can play Blackjack with a single deck or 4 deck. Choose game type "
      puts
      puts "1) Single Deck"
      puts "2) Four Deck"

      choice_2 = gets.chomp
      case choice_2
      when "1"
        @game_type = 1
      when "2"
        @game_type = 4
      end
      
    end

    def players_number
      puts "How many players?"
      @players_number = gets.chomp.to_i
    end

    def clear_screen
     puts "\e[H\e[2J"
    end
   
    def menu
      loop do

        check_player_balance

        puts "What do you want to do? "
        puts
        puts " 1) Play "
        puts " 2) Show players stats"
        puts " 3) Remove player from match"
        puts " 4) Add player to match"
        puts " 5) Change game type"
        puts " q) quit"
        input = gets.chomp

        case input
        when "1"
          clear_screen
          match = Match.new(@dealer, @players, @game_type)
        when "2"
          clear_screen
          show_players
        when "3"
          clear_screen
          delete_player
        when "4"
          clear_screen
          create_single_player
        when "5"
          clear_screen
          game_type
        when "q"
          puts "bye bye"
          exit
        else
          clear_screen
          puts "Comando non valido '#{input}'"
        end
      end
    end
  end

  include Interface

  def initialize
    @players = []
    @game_type = 1
    run
  end

  private

  def run
    @dealer = Dealer.new
    clear_screen
    puts "Welcome to Las Vegas. Let's play Blackjack "
    players_number
    create_players(@players_number)
    menu
  end 

  def create_players(players_number)
    players_number.times do |player|
      create_single_player
    end
  end

  def show_players
    @players.each_with_index do |player, index|
      puts "#{index+1}) #{player.status}"
    end
  end

  def create_single_player
    puts "Enter player name"
    name = gets.chomp.capitalize
    @players << Player.new(name)
  end

  def delete_player
    show_players
    puts
    puts "Which player you want do delete?"
    player_to_del = gets.chomp.to_i
    @players.delete_at(player_to_del-1)
  end

  def check_player_balance
    @players.each_with_index do |player, index|
      if player.balance == 0
        puts "#{player.name} is out of the game, no money"
        @players.delete_at(index)
      end
    end
  end

end

blackjack = BlackJack.new

# binding.pry

