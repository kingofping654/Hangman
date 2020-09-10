#Allows the a game to be saved so you can return to your progress
require 'yaml'

#Simple instructions for how to play the game.
instructions = puts "Welcome to Hangman! In this game the computer selects a word and you have to try to guess it. Each turn you will type in a single letter and press enter. If the letter is correct you will be shown where that letter would be in the word. The more you guess correctly the more you will see the word come together! if you get a letter wrong you will begin forming a person on the gallows. You have 7 chances to guess the correct letter. If you would like to save and quit when prompted for a letter instead type sq and hit enter. At this point the game will create a hangman_save.yml file. If you would like to return to this save on startup when the game asks if you would like to play your last saved game type yes and hit enter. if not type anything else and hit enter. Keep in mind you only get one save file and it will automatically overwrite any previous saves. The words should not contain any special characters or numbers so just type in letters. To start a new game type: game_start = Hangman.new(\"your name here\") (on the next line) game_start.run (on the next line) game_start.chosen_word. Good luck and I hope you have fun.\n\n"

#A module holding all of the art for the game. Each method renders a different stage of hangman. 
module GameArt

  def render_empty_gallows
  File.readlines("empty_gallows.txt") do |line|
    puts line
    
  end
end

def render_head
  File.readlines("head.txt") do |line|
    puts line
    
  end
end

def render_body
  File.readlines("body.txt") do |line|
    puts line
  
  end
end

def render_left_arm
  File.readlines("left_arm.txt") do |line|
    puts line
    
  end
end

def render_right_arm
  File.readlines("right_arm.txt") do |line|
    puts line
    
  end
end

def render_left_leg
  File.readlines("left_leg.txt") do |line|
    puts line
    
  end
end

def render_right_leg
  File.readlines("right_leg.txt") do |line|
    puts line
    
  end
end

def render_dead
  File.readlines("dead.txt") do |line|
    puts line
    
  end
end
end

#The main class where the game is held
class Hangman 
  
  #Adds the GameArt module so that it can be called upon during the game. This also gives acsess to reading whatever the word is. The player can also turn off the would you like to load your save message. 
  include GameArt
  attr_reader :chosen_word
  attr_accessor :load_save

#This begins the class and obtains the player name with a default value if none is given. It also starts many other important variables so that they may be saved later. This also randomly assigns the computer a name based on the array of names in @computer.  
def initialize(player = "Player 1")
  @player = player
  @load_save = true
  @dead = true
  @mistakes = 0
  @guess = String.new
  @word_blank = String.new 
  @chosen_word = ''
  @word_length = ''
  @word_blank = ''
  @split_word = Array.new
  @incorrect_letter = Array.new
  @computer = ["Hal", "Kit", "Bat-Computer", "Karen", "NICOLE", "Glados", "Bishop", "EDI", "Cortana", "Guilty Spark", "John Henry Eden", "ADA", "Dummy Plug", "Shodan", "Jarvis", "The Magi", "Sigma", "SARA", "Lappy-486", "Stem", "Ava", "Samantha"].sample
    end
    
#This method chooses which word to use from the 5desk.txt file. It also ensures the word is between 5 and 12 letters long. The word is downcased for covenience later on. a word blank is created by subbing in the letters of the chosen word with '_'. @word_length shows the player how many letters are in their word. @split_word turns the word into an array for use later. It ends by printing out how many letters are in the word. 
def chosen_word
    word_array = File.read('5desk.txt').split
    word_array.select! { |word| word.length > 4 && word.length < 13 }
    @chosen_word = word_array[rand(0..word_array.length - 1)].downcase
    @word_blank = @chosen_word.gsub(/[a-z]/, '_')
    @word_length = @chosen_word.length
    @split_word = @chosen_word.downcase.split(//)
    puts "#{@player} Your word is #{@word_length} letters long, Good luck!\n"
  end


def start_game
  #@word_blank will be updated with each correct letter.
  print "\n#{@word_blank}\n\n"

  #This is so that for however many turns the player has no mistakes they are only shown the empty gallows once.
   if @mistakes == 0
   puts render_empty_gallows
  end
    
  #This will turn on once the player makes a mistake and show them what letters they have guessed but are wrong. 
   if !@incorrect_letter.empty? 
      print "\nIncorrect Letters: #{@incorrect_letter}\n"
    end
  #@guess holds whatever letter the player guesses to be in the word.  
  @guess = gets.chomp.downcase
  
  #An if...else to give the player a chance to back out of saving and quiting in case they decide to keep playing. if they do save and quit the save_game method runs. If not they are prompted to type a letter like normal.
  if @guess == 'sq'
    puts "Are you sure you would like to save? This will overwrite your previous save file.(Yes/No)"
    @guess = gets.chomp.downcase
  if @guess == 'yes'
      save_game
  else
      puts 'Type a letter and press enter:'
      @guess = gets.chomp.downcase
  end
  end
   
  #This attempts to get the player to only type letters they have not guessed as an answer.
  if @guess.length > 1 || @guess =~ /\d/ || @incorrect_letter.include?(@guess) || @word_blank.include?(@guess) 
      puts "\nPlease only type one letter that you have not already guessed"
    @guess = gets.chomp.downcase
  end
end

#This method checks to see if the players guess in start_game matches any letters in @split_word. If the letter is in the word it adds it to @word_blank at its appropriate spot(s). if not they get a point added to @mistakes and pushes the guess to @incorrect_letter.
def checker
    if !@split_word.include?(@guess)
      @mistakes += 1
      @incorrect_letter.push(@guess)
    end

   @split_word.each_with_index do |letter, index|
    if letter == @guess
      @word_blank[index] = @guess
    end
  end 
   
   #Based on how many mistakes the player has made a different piece of art is shown. render_empty_gallows is not shown as that is handled in start_game.
   if @mistakes == 1
    puts render_head
   elsif @mistakes == 2
    puts render_body
   elsif @mistakes == 3
    puts render_left_arm
   elsif @mistakes == 4
    puts render_right_arm
   elsif @mistakes == 5
    puts render_left_leg
   elsif @mistakes == 6
    puts render_right_leg
   elsif @mistakes == 7
    @dead = false
    puts render_dead
  end
win_lose  
end
  
  #This checks to see if the player has either made 7 mistakes and lost or guessed the word correctly and won. They are given a different message depending on the results but both winners and losers have a chance at a rematch
  def win_lose
  if @word_blank == @split_word.join
    puts "\nGood job #{@player}, you guessed #{@computer}\'s word! Would you like to play again?(Yes/No)\n"
    rematch = gets.chomp.downcase
  
    elsif @mistakes == 7
    puts "\nSorry, #{@player} #{@computer}\'s word was #{@chosen_word}. Would you like to play again?(Yes/No)"
    rematch = gets.chomp.downcase
  end
 
  if rematch == "yes"
    
    new_game = Hangman.new("#{@player}")
    new_game.chosen_word
    new_game.run
  
  elsif rematch == 'no'
   puts "\nThank you for playing!"
   exit
  end
end
 
#A method that will save the game or overwrite any existing save. it will create a hangman_save.yml file that you can restore from later.
def save_game   
  File.open('hangman_save.yml', 'w') { |f| YAML.dump(self,f)}
      exit
    end

#This will load your previous game if one is available and if not display a message and start a new game. Either way @load_save will be turned to false so it doesn't ask you to load a save again.
def load_game
      File.open('hangman_save.yml') do |f|
      @saved_game = YAML.load_file(f)
      @saved_game.load_save = false
      @saved_game.run
    end
  rescue StandardError
    puts 'No save file detected. Starting new game....'
    @load_save = false
    run
  end

  #This is where the game begins and will loop till a win/lose condition is met. This is also where you are asked if you would like to load a previous save.
  def run
    if @load_save == true
      puts 'Would you like to play your last saved game? (Yes/No)'
      gets.chomp.downcase == 'yes' ? load_game : (puts "\n#{@computer} is coming up with your word.\n")
      chosen_word
    end
   loop do 
    start_game
    checker
    win_lose
  end
end
end






  game_start = Hangman.new("Grant")
  game_start.run
  game_start.chosen_word
  