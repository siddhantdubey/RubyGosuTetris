class Grid
    #this grid class is very similar to the one we wrote in class in terms of ideas, but quite different in execution and the different methods
    attr_reader :score, :squares, :rows, :column

    def initialize(rows, columns)
      @rows = rows #the number of rows in the grid
      @columns = columns #the number of columns
      @squares = [] #the array that contains all the squares in the grid
      @score = 0  #this will keep track of the player score throughout the game
    end
  
    def land(square)
      @squares << square #once a square lands on the grid it is added to the array of squares in the grid
    end
  
    def blocked?(x, y)
      x < 0 || x >= @columns || occupied?(x, y) #checks to see if a certain part on the grid is already blocked out
    end
  
    def landed?(x, y)
      y >= @rows - 1 || occupied?(x, y + 1) #checks to see if a square has landed yet or not
    end
    
    def column_full?
      #this is a method used to check if a column is full, used to checkk to see if the game is over
        (0..@columns).each do |y|
            column = column(y)
            if column.length == @rows
                return true
            end
        end
        return false
    end

    def delete_filled_rows
      #this is used to delete a completed row and then add to the score of the person playing the game, this will be run each step in the game ruby file
      (0...@rows).each do |y|
        row = row(y)
        if row.length == @columns
          destroy(row)
          drop(y)
          @score += 10
        end
      end
    end
  
    def draw
      #drawing the grid is the same thing as drawing each square which is what is done here
      @squares.each(&:draw)
    end
  
    def explode(square)
      #this explode function is for the single grey square that is a "bomb". It deletes the column that it lands on
      column = column(square.x)
      destroy(column)
    end
  
    def row(y)
      #returns the squares in row y
      @squares.select { |square| square.occupies_row?(y) }
    end
    
    def column(y)
      #returns the squares in column y
      @squares.select { |square| square.occupies_column?(y)}
    end

    def drop(y)
      #this is what allows for the squares to be dropped 
      @squares.each { |square| square.fall_towards(y) }
    end
  
    def destroy(squares)
      #this function is used to destroy squares
      @squares -= squares
    end
  
    def occupied?(x, y)
      #this function is used to check if a square on the grid is occupied
      @squares.any? { |square| square.occupies?(x, y) }
    end
  end