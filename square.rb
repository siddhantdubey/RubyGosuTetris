class Square
    #this file lays out the base squares that will be used to make the more complicated shapes


    attr_reader :x, :y, :color
    def initialize(x, y, color)
      @x = x #the square is in a row and column. The column denoted by x and the row denoted by y
      @y = y
      @color = color
    end
  
    def draw
      #the draw method for the square
      stroke = 1
      Gosu.draw_rect(@x * Tetris::SIZE, @y * Tetris::SIZE, Tetris::SIZE, Tetris::SIZE, Gosu::Color::BLACK)
      Gosu.draw_rect(@x * Tetris::SIZE + stroke, @y * Tetris::SIZE + stroke, Tetris::SIZE - 2 * stroke, Tetris::SIZE - 2 * stroke, @color)
    end
  
    def fall_towards(y)
      #this will always make the the square fall towards the bottom
      move(y: 1) if @y < y
    end
  
    def move(x: 0, y: 0)
      #this is the method used to move the squares to the left right or down
      @x += x
      @y += y
    end
  
    def place(matrix)
      #this places the square within a matrix which is used in the block file to be able to manipulate the squares
      matrix[@x, @y] = self
    end
  
    def move_relative_to_matrices(matrix1, matrix2)
      #by finding the square inbetween two matrices, you allow for it to be rotated by comparing its position in matrix 1 to matrix 2 :)
      x1, y1 = matrix1.look(self)
      x2, y2 = matrix2.look(self)
      move(x: x2 - x1, y: y2 - y1)
    end
  
    def blocked?(offset_x, grid)
      #checks to see if the square is blocked off in the grid
      grid.blocked?(@x + offset_x, @y)
    end
  
    def haslanded?(grid)
      #checks to see if the block has been successfully placed in the grid and haslanded on top of either another square or the bottom of the grid
      grid.haslanded?(@x, @y)
    end
  
    def occupies?(x, y)
      #checks to see if the square is at grid[x, y] or column x and grid y
      @x == x && @y == y
    end
  
    def occupies_row?(y)
      #checks to see if the square is row y
      @y == y
    end

    def occupies_column?(x)
        #checks to see if the square is in column x
        @x == x
    end

    def to_s
      #this method was created for the purpose of debugging to make sure that squares were being placed in the correct spot in the grid
      return "#{x} #{y} #{color}"
    end
  end