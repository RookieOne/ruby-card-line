require("csv")

class Card
  attr_reader :title, :number
  def initialize(title, number)
    @title = title
    @number = number
  end

  def before?(other_card)
    @number <= other_card.number
  end
end

class Deck
  def initialize(filename)
    @cards = []
    CSV.foreach(filename) do |row|
      @cards.push(Card.new(row[0], row[1]))
    end
  end

  def get_card
    @cards.shuffle!.pop
  end

  def empty?
    @cards.empty?
  end

  def cards_left
    @cards.length
  end
end

class CardLine
  def initialize(card)
    @cards = [card]
  end

  def get_card_at(index)
    @cards[index]
  end

  def add_card(card)
    @cards.push(card).sort_by! { |card| card.number }
  end

  def display
    puts ""
    puts "**************************"
    @cards.each_with_index do |card, i|
      puts "#{i} - #{card.title} #{card.number}"
    end
    puts "**************************"
    puts ""
  end
end

class Game
  def initialize
    @deck = Deck.new("movies.csv")
    first_card = @deck.get_card
    @card_line = CardLine.new(first_card)
    @score = 0
  end

  def play
    clear_screen
    while(!@deck.empty?) do
      puts "Your current score is #{@score}"
      puts "There are #{@deck.cards_left} cards left"
      @card_line.display
      puts "Where should we place the next card?"
      card = @deck.get_card

      puts ""
      puts "*************************"
      puts card.title
      puts "*************************"
      puts ""

      choice = get_choice
      index = choice[1].to_i
      clear_screen

      case choice[0]
      when "after"
        left_card = @card_line.get_card_at(index)
        right_card = card
      when "before"
        left_card = card
        right_card = @card_line.get_card_at(index)
      end
      
      if left_card.before?(right_card)
        puts "CORRECT!"
        @score += 1
        @card_line.add_card(card)
      else
        puts "Sorry that isn't correct."
      end
    end

    puts "Game is over. Your final score is #{@score}"
    @card_line.display
  end

  def clear_screen
    system "clear" or system "cls"
  end

  def get_choice
    puts "Type either 'before #' or 'after #'"
    choice = gets.chomp.split
  end
end

Game.new.play