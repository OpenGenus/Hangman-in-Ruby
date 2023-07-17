require 'ruby2d'

set title: "Hangman"
set background: 'white'


class Hangman
  def initialize
    @word = select_word
    @incorrect_guesses = []
    @correct_guesses = []
    @max_guesses = 6
    @game_over = false
  end

  def select_word
    words = ["ruby", "hangman", "games", "programming", "openai"]
    words.sample
  end

  def handle_key_press(event)
    guess = event.key.downcase

    if valid_guess?(guess) && !@game_over
      if @word.include?(guess)
        @correct_guesses << guess
        if won?
          @game_over = true
        end
      else
        @incorrect_guesses << guess
        if loss?
          @game_over = true
        end
      end
    end
  end

  def valid_guess?(guess)
    guess.length == 1 && guess.match?(/[a-z]/) && !(@correct_guesses.include?(guess) || @incorrect_guesses.include?(guess))
  end

  def won?
    visible_word == @word
  end

  def loss?
    @incorrect_guesses.length >= @max_guesses
  end

  def visible_word
    visible = ""
    @word.chars.each do |char|
      visible << (@correct_guesses.include?(char) ? char : "_")
    end
    visible
  end

  def display_board
    hint = ""
    if @word == "ruby"
      hint = "computer language"
      elsif
        @word == "hangman"
        hint = "swinging male"
      elsif
        @word == "games"
        hint = "what we play"
      elsif
        @word == "programming"
        hint = "make the computer speak"
      else
        @word == 'openai'
        hint = "artificial intelligence"
    end
    Text.new(visible_word, color: 'blue', x: 10, y: 10, size: 50)
    Text.new("Incorrect Guesses: #{@incorrect_guesses}", color:'black', x: 10, y: 100)
    Text.new("Guesses Remaining: #{guesses_remaining}", color:'black', x: 10, y: 130)
    Text.new("A hint: #{hint}", color: 'blue', x: 10, y: 160)
    stick_figure
  end

  def display_game_over
    if loss?
      Text.new("GAME OVER", color:'red', x: 200, y: 100, size: 60)
      Text.new("The word was: #{@word}", color:'black', x: 220, y: 200, size: 30)
      Text.new(message, color:'black', x: 220, y: 250, size: 30)
      stick_figure
    else
      Text.new("YOU WON, CONGRATS", color: 'blue', x: 80, y: 100, size: 60)
      Text.new(message, color:'black', x: 250, y: 300, size: 30)
    end
  end

  def stick_figure
    Square.new(
      x: 300, y: 500,
      size: 50,
      color: 'blue',
      z: 10
    )
    Line.new(
      x1: 325, y1: 300,
      x2: 325, y2: 500,
      width: 10,
      color: 'lime',
      z: 20
    )
    Line.new(
      x1: 325, y1: 300,
      x2: 450, y2: 300,
      width: 10,
      color: 'lime',
      z: 20
    )
    Line.new(
      x1: 450, y1: 300,
      x2: 450, y2: 350,
      width: 10,
      color: 'lime',
      z: 20
    )
    head = Circle.new(
      x: 450, y: 370,
      radius: 20,
      sectors: 32,
      color: 'fuchsia',
      z: 10
    )
    body = Line.new(
      x1: 450, y1: 390,
      x2: 450, y2: 500,
      width: 10,
      color: 'fuchsia',
      z: 20
    )
    arm_one = Line.new(
      x1: 450, y1: 410,
      x2: 375, y2: 410,
      width: 10,
      color: 'fuchsia',
      z: 20
    )
    arm_two = Line.new(
      x1: 450, y1: 410,
      x2: 525, y2: 410,
      width: 10,
      color: 'fuchsia',
      z: 20
    )
    leg_one = Line.new(
      x1: 450, y1: 500,
      x2: 400, y2: 575,
      width: 10,
      color: 'fuchsia',
      z: 20
    )
    leg_two = Line.new(
      x1: 450, y1: 500,
      x2: 500, y2: 575,
      width: 10,
      color: 'fuchsia',
      z: 20
    )
    
    if @incorrect_guesses.length == 0
      head.remove
      body.remove
      arm_one.remove
      arm_two.remove
      leg_one.remove
      leg_two.remove
      elsif 
        @incorrect_guesses.length == 1
        head.add
        body.remove
        arm_one.remove
        arm_two.remove
        leg_one.remove
        leg_two.remove
      elsif
        @incorrect_guesses.length == 2
        head.add
        body.add
        arm_one.remove
        arm_two.remove
        leg_one.remove
        leg_two.remove
      elsif
        @incorrect_guesses.length == 3
        head.add
        body.add
        arm_one.add
        arm_two.remove
        leg_one.remove
        leg_two.remove
      elsif
        @incorrect_guesses.length == 4
        head.add
        body.add
        arm_one.add
        arm_two.add
        leg_one.remove
        leg_two.remove
      elsif
        @incorrect_guesses.length == 5
        head.add
        body.add
        arm_one.add
        arm_two.add
        leg_one.add
        leg_two.remove
      else
        @incorrect_guesses.length == 6
        head.add
        body.add
        arm_one.add
        arm_two.add
        leg_one.add
        leg_two.add
    end
  end


  def guesses_remaining
    @max_guesses - @incorrect_guesses.length
  end

  def game_over
    @game_over
  end

  def message
    "Press 'spacebar' to restart"
  end
end

set width: 800, height: 600

game = Hangman.new

on :key_down do |event|
  game.handle_key_press(event)
  if event.key == 'space'
    game = Hangman.new
  end
end

update do
  clear
  if game.game_over
    game.display_game_over
  else
    game.display_board
  end
end

show