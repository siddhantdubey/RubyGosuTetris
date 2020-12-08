class Grid
    #this grid class is very similar to the one we wrote in class in terms of ideas, but quite different in execution and the different methods
    attr_reader :score, :blocks, :rows, :column

    def initialize(rows, columns)
      @numrows = rows #the number of rows in the grid
      @numcolumns = columns #the number of columns
      @blocks = [] #the array that contains all the squares in the grid
      @score = 0  #this will keep track of the player score throughout the game
    end
  
    def land(block)
      @blocks << block #once a square lands on the grid it is added to the array of squares in the grid
    end
  
    def blocked?(x, y)
      x < 0 || x >= @numcolumns || occupied?(x, y) #checks to see if a certain part on the grid is already blocked out
    end
  
    def haslanded?(x, y)
      y >= @numrows - 1 || occupied?(x, y + 1) #checks to see if a square has haslanded yet or not
    end
    
    def full_column?
      #this is a method used to check if a column is full, used to checkk to see if the game is over
      #this sometimes doesn't work exactly right, but it gets the job done
        (0..@numcolumns).each do |y|
            column = column(y)
            # puts @blocks #this line was used for debugging
            if column.length == @numrows
                return true
            end
        end
        return false
    end

    def delete_filled_rows
      #this is used to delete a completed row and then add to the score of the person playing the game, this will be run each step in the game ruby file
      (0...@numrows).each do |y|
        row = row(y)
        if row.length == @numcolumns
          destroy(row)
          drop(y)
          @score += 10
        end
      end
    end
  
    def draw
      #drawing the grid is the same thing as drawing each square which is what is done here
      @blocks.each(&:draw)
    end
  
    def explode(block)
      #this explode function is for the single grey square that is a "bomb". It deletes the column that it lands on
      column = column(block.x)
      destroy(column)
    end
  
    def row(y)
      #returns the squares in row y
      @blocks.select { |block| block.occupies_row?(y) }
    end
    
    def column(y)
      #returns the blocks in column y
      @blocks.select { |block| block.occupies_column?(y)}
    end

    def drop(y)
      #this is what allows for the squares to be dropped from their current position after rows have been deleted
      @blocks.each { |block| block.fall_towards(y) }
    end
  
    def destroy(blocks)
      #this function is used to destroy squares
      @blocks -= blocks
    end
  
    def occupied?(x, y)
      #this function is used to check if a square on the grid is occupied
      @blocks.any? { |block| block.occupies?(x, y) }
    end
  end