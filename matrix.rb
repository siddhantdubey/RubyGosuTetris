class Matrix
    #A matrix is a 3 x 3 box in which squares are arranged to make different blocks. Methods in this class are used to move the shapes/blocks around.
    #A matrix is a 3 x 3 box in which squares are arranged to make different blocks. This is part of the normal tetris game. Methods in this class are used to move the shapes/blocks around.
    #This was the hardest part of the project in our opinion
    #sources: https://stackoverflow.com/questions/38594574/tetris-2d-array-logic (not in ruby which is annoying, but it was understandable enough)
    #no clue how to use the map method beforehand so this helped: https://www.rubyguides.com/2018/10/ruby-map-method/

    def initialize(rows = [])
      @arrayrows = rows
    end
  
    def [](x, y)
      #overloading indexing of arrays here to make it easier for other methods to be written
      @arrayrows.fetch(y, [])[x]
    end
  
    def []=(x, y, value)
      #also overloading indexing of arrays to format it in a way that would make other methods easier
      (@arrayrows[y] ||= [])[x] = value
      fixorientation
    end
  
    def rotate
      #helpful stackoverflow answer: https://stackoverflow.com/questions/233850/tetris-piece-rotation-algorithm/8131337
      #rotates the matrix around 
      self.class.new(@arrayrows.transpose.map(&:reverse))
    end
  
    def look(value)
      #looks for a certain value within the matrix b/c the standard methods in ruby wouldn't work as well as I would have liked for this one, also returns the index of the value, this will be used to move squares
      @arrayrows.each_with_index do |rows, y|
        rows.each_with_index do |val, x|
          return [x, y] if val == value
        end
      end
      nil
    end
  
    def trim
      #gets rid of nil value from matrices and removes everything that doesn't provide useful info, like empty columns and rows
      @arrayrows = @arrayrows.drop_while { |rows| rows.all?(&:nil?) }
      @arrayrows = @arrayrows.map { |column| column.drop(empty_columns) }
    end
  
    def fixorientation
      #aligns the rows in the matrix together
      @arrayrows.map! { |rows| Array(rows) }
      @arrayrows.map! { |rows| rows.concat([nil] * (width - rows.length)) }
    end
  
    def width
      #returns the width of the matrix
      @arrayrows.map(&:length).max
    end
  
    def empty_columns
      #returns columns that are empty, because we don't need to care about them until they're no longer empty
      @arrayrows.map { |rows| rows.find_index { |v| v } }.compact.min
    end
  end