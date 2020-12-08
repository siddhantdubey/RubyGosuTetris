require "gosu"
require_relative "grid"
require_relative "square"
require_relative "shape"
require_relative "matrix"

class Tetris < Gosu::Window
  ROWS = 22 #the number of rows
  COLUMNS = 10 #the number of columns
  SIZE = 40 #the size of the squares


  #a lot of the different game scene stuff was taken from our sector_five code in class

  def initialize
    super(COLUMNS * SIZE, ROWS * SIZE)#creates the window based on number of rows and columns
    @fall_interval = 500 #used to determine how fast blocks fall, starts slow gets quicker as player score increases
    @grid = Grid.new(ROWS, COLUMNS) #creates the grid
    @current_shape = Shape.random(@grid) #makes the block to be placed
    
    
    @playingtime = Gosu.milliseconds #used to keep track of how long the game has been going on and how fast the blocks fall
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20) #font to draw most of the game's text
    @game_over = false #variable to store if the game is over or not
    
    #music source: https://commons.wikimedia.org/wiki/File:Tetris_theme.ogg
    @music = Gosu::Song.new('tetristheme.ogg') #loads the song for the game
    @music.volume = 0.1 #makes it much quieter, it is a VERY loud file
    @music.play(true) #starts playing the music
    
    @speed = 1 #this is used to use the fall() method so that the shapes fall towards the bottom
    @scene = :start #the current scene of the game, either start, game, or end. 

    @title_font = Gosu::Font.new(self, Gosu::default_font_name, 40) #the font for the title
  end

  def draw
    case @scene #different draws depending on the scene
    when :start #begins with drawing the welcome screen and brief instructions
      Gosu.draw_rect(0, 0, width, height, Gosu::Color::BLACK) #draws the background
      #the following is just text that shows up at the beginning of the game
      @title_font.draw("Welcome to Tetris!", 50, 140, 1, 1.0, 1.0, Gosu::Color::RED)
      @font.draw("Controls:", 100,  190, 1, 1.0, 1.0, Gosu::Color::WHITE)
      @font.draw("Down Arrow Key to move shapes down", 25,  240, 1, 1.0, 1.0, Gosu::Color::WHITE)
      @font.draw("Up Arrow Key to rotate shapes.", 25, 290, 1, 1.0, 1.0, Gosu::Color::WHITE)
      @font.draw("Left and right move shapes left and right.", 25, 340, 1, 1.0, 1.0, Gosu::Color::WHITE)
      @font.draw("The gray block deletes the column it is placed in", 10, 390, 1, 1.0, 1.0, Gosu::Color::WHITE)
      @font.draw("Press P to Play", 125, 440, 1, 1.0, 1.0, Gosu::Color::WHITE)
    when :game
      if !@game_over
        
          Gosu.draw_rect(0, 0, width, height, Gosu::Color::BLACK) #draws background
          @font.draw("Score: "  + @grid.score.to_s, 0, 50, 1, 1.0, 1.0, Gosu::Color::WHITE) #draws score
          @current_shape.draw #draws shape to be placed
          @grid.draw #draws grid with shapes
  
      else
        #done when game is over, immediately dissapears to make way for the end screen
        Gosu.draw_rect(0, 0, width, height, Gosu::Color::BLACK) #draws background
        @grid.draw #draws grid
        @font.draw("Score: " + @grid.score.to_s, 0, 50, 1, 1.0, 1.0, Gosu::Color::WHITE) #draws score
        @font.draw("Game Over!", 150, 400, 1, 1.0, 1.0, Gosu::Color::WHITE) #draws game over sign
      end
    when :end
      Gosu.draw_rect(0, 0, width, height, Gosu::Color::BLACK) #draws background
      @grid.draw #grid drawn
      @font.draw("Score: " + @grid.score.to_s, 0, 50, 1, 1.0, 1.0, Gosu::Color::WHITE) #draws score
      @font.draw("Game Over!", 150, 400, 1, 1.0, 1.0, Gosu::Color::WHITE) #shows player that game is over
      @font.draw("Press Q to quit.", 150, 500, 1, 1.0, 1.0, Gosu::Color::WHITE) #tells player to press Q to quit
    end
  end

  def update
    @game_over = @grid.full_column?
    case @scene
    #can only play the game while the scene is game, otherwise nothing is being moved and the grid is not being updated
    when :game
      if @grid.score >= 30 and @fall_interval > 100 
        @fall_interval = 500 - (@grid.score - 30)*10 #once the player gets a score of 30, the blocks speed up as score increases until the fall_interval is 100
      end
      if Gosu.milliseconds - @playingtime > @fall_interval
        @playingtime = Gosu.milliseconds #checking to make sure if it is time to place a block, if it is then move on to placing the blocks and handling game logic
        step
      end
    end
  end

  def step
     #checks to see if the game is over by going through each column and seeing if the column is full or not
    if !@game_over #as long as the game is not over then continue to pick new blocks, land them, and delete filled rows
      if @current_shape.haslanded?
        @current_shape.land
        @grid.delete_filled_rows
        @current_shape = Shape.random(@grid)
      else
        @current_shape.fall(@speed)
      end
    else
      #if the game is over then change the scene to the ending scene
      @scene = :end
    end
  end


  def button_down(key)
    case @scene #different button_down functinos for different scenes
    when :start
      button_down_start(key) #for start scene
    when :game 
      button_down_game(key) #for game scene
    when :end 
      button_down_end(key) #for end scene
    end
  end

  def button_down_start(key)
    if key == Gosu::KbP #in start scene press P to begin playing the game
      @scene = :game
    end
  end

  def button_down_game(key)
    #event handling during the game scene
    case key
      when Gosu::KbLeft then @current_shape.move_left #moves block to the left
      when Gosu::KbRight then @current_shape.move_right #moves block to the right
      when Gosu::KbDown then @current_shape.fall(@speed) #makes the block fall down
      when Gosu::KbUp then @current_shape.rotate #rotates the shape
      when Gosu::KbQ then close #closes the game
    end
  end

  def button_down_end(key)
    #event handling during end scene
    if key == Gosu::KbQ  #press Q to quit
      close
    end
  end

  def needs_cursor? #gosu method, game needs cursor
    true
  end
end

window = Tetris.new
window.show