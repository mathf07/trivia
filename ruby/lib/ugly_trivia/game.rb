module UglyTrivia
  class Player
    def initialize(name, position, score, prison)
        @position = position
        @score = score
        @prison = prison
        @name = name
    end
    def name
      @name
    end
    def position
      @position 
    end
    def score
      @score
    end
    def prison
      @prison
    end
  end

  class Game
    def initialize
      @players = []
      @places = Array.new(6, 0)
      @purses = Array.new(6, 0)
      @in_penalty_box = Array.new(6, nil)

      @pop_questions = []
      @science_questions = []
      @sports_questions = []
      @rock_questions = []

      @current_player = 0
      @is_getting_out_of_penalty_box = false

      50.times do |i|
        @pop_questions.push "Pop Question #{i}"
        @science_questions.push "Science Question #{i}"
        @sports_questions.push "Sports Question #{i}"
        @rock_questions.push create_rock_question(i)
      end
    end

    def create_rock_question(index)
      "Rock Question #{index}"
    end

    def is_playable?
      how_many_players >= 2
    end

    def add(player_name)
      @players.push(Player.new(player_name, 0, 0, false))
      @places[how_many_players] = 0
      @purses[how_many_players] = 0
      @in_penalty_box[how_many_players] = false

      puts "#{player_name} was added"
      puts "They are player number #{@players.length}"

      true
    end
    
    def how_many_players
      @players.length
    end
    def next_position(roll)
      @places[@current_player] += roll
      @places[@current_player] -= 12 if @places[@current_player] > 11
    end

    def roll(roll)
      puts "#{@players[@current_player].name} is the current player"
      puts "They have rolled a #{roll}"

      if @in_penalty_box[@current_player]
        if roll % 2 != 0
          @is_getting_out_of_penalty_box = true

          puts "#{@players[@current_player].name} is getting out of the penalty box"
          next_position(roll)
          puts "#{@players[@current_player].name}'s new location is #{@places[@current_player]}"
          puts "The category is #{current_category}"
          ask_question
        else
          puts "#{@players[@current_player].name} is not getting out of the penalty box"
          @is_getting_out_of_penalty_box = false
          end

      else

        next_position(roll)

        puts "#{@players[@current_player].name}'s new location is #{@places[@current_player]}"
        puts "The category is #{current_category}"
        ask_question
      end
    end

  private

    def ask_question
      puts @pop_questions.shift if current_category == 'Pop'
      puts @science_questions.shift if current_category == 'Science'
      puts @sports_questions.shift if current_category == 'Sports'
      puts @rock_questions.shift if current_category == 'Rock'
    end

    def current_category
      return 'Pop' if @places[@current_player] == 0
      return 'Pop' if @places[@current_player] == 4
      return 'Pop' if @places[@current_player] == 8
      return 'Science' if @places[@current_player] == 1
      return 'Science' if @places[@current_player] == 5
      return 'Science' if @places[@current_player] == 9
      return 'Sports' if @places[@current_player] == 2
      return 'Sports' if @places[@current_player] == 6
      return 'Sports' if @places[@current_player] == 10
      return 'Rock'
    end

  public
    def good_answer
      puts 'Answer was correct!!!!'
      @purses[@current_player] += 1
      puts "#{@players[@current_player].name} now has #{@purses[@current_player]} Gold Coins."
    end
    def was_correctly_answered
      if @in_penalty_box[@current_player]
        next_player
        if @is_getting_out_of_penalty_box
          good_answer
          winner = did_player_win()

          winner
        else
          true
        end

      else
        good_answer

        winner = did_player_win
        next_player
        
        winner
      end
    end
    
    def next_player
      @current_player += 1
      @current_player = 0 if @current_player == @players.length      
    end
    
    def wrong_answer
  		puts 'Question was incorrectly answered'
  		puts "#{@players[@current_player].name} was sent to the penalty box"
  		@in_penalty_box[@current_player] = true

      next_player
  		true
    end

  private

    def did_player_win
      !(@purses[@current_player] == 6)
    end
  end
end
