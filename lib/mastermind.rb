class Code

  PEGS = {
    "R" => :red,
    "G" => :green,
    "B" => :blue,
    "Y" => :yellow,
    "O" => :orange,
    "P" => :purple
  }

  def self.parse(str)
    pegs = str.split("")

    pegs.map! do |letter|
      raise Exception.new("contains invalid colors") if !PEGS.has_key?(letter.upcase)
      PEGS[letter.upcase]
    end

    Code.new(pegs)
  end

  def self.random
    keys_arr = PEGS.keys
    pegs = []

    4.times do |i|
      current_str = keys_arr.sample
      pegs << PEGS[current_str]
    end

    Code.new(pegs)
  end

  attr_reader :pegs

  def initialize(pegs)
    @secret_code = pegs
    @pegs = pegs
  end

  def [](i)
    pegs[i]
  end

  def exact_matches(other_code)
    num_of_matches = 0

    4.times do |i|
      if self[i] == other_code[i]
        num_of_matches += 1
      end
    end

    num_of_matches
  end

  def near_matches(other_code)
    near_matches = 0

    peg1_count = Hash.new(0)
    peg2_count = Hash.new(0)

    4.times do |i|
      peg1_count[self[i]] += 1
      peg2_count[other_code[i]] += 1
    end

    return near_matches if peg1_count.length == 1

    peg1_count.each do |k, v|
      if peg2_count.has_key?(k) && peg2_count[k] > 0
        near_matches += 1
        peg2_count[k] -= 1
      end
    end

    near_matches
  end

  def ==(other_code)
    return false unless other_code.is_a?(Code)
    if self.exact_matches(other_code) == 4
      return true
    end
    false
  end
end

class Game

  def initialize(code = Code.random)
    @secret_code = code
    @guesses = 10
  end

  def play
    puts "Welcome to Mastermind!"

    until game_over?
      p @secret_code
      current_guess = get_guess
      if current_guess == @secret_code
        return "You win!"
      end
      display_matches(current_guess)
      @guesses -= 1
      puts "You have #{@guesses} left!"
    end

    puts "You lose!"
    puts "The secret code is #{@secret_code}!"
  end

  def game_over?
    return true if @guesses == 0
  end

  def get_guess
    puts "Enter a guess: (ie, XXXX)"
    begin
      Code.parse(gets.chomp)
    rescue Exception
      puts "Error parsing code!"
      retry
    end
  end

  def display_matches(guess)
    exact_matches = @secret_code.exact_matches(guess)
    near_matches = @secret_code.near_matches(guess)
    puts "You have #{exact_matches} exact matches!"
    puts "You have #{near_matches} near matches!"
  end
end

if __FILE__ == $PROGRAM_NAME
  Game.new.play
end
