class Matrix
    #A matrix is a 3 x 3 box in which squares are arranged to make different blocks. Methods in this class are used to move the shapes/blocks around.

    def initialize(rows = [])
      @rows = rows
    end
  
    def [](x, y)
      #overloading indexing of arrays here to make it easier for other methods to be written
      @rows.fetch(y, [])[x]
    end
  
    def []=(x, y, value)
      #also overloading indexing of arrays to format it in a way that would make other methods easier
      (@rows[y] ||= [])[x] = value
      align
    end
  
    def rotate
      #rotates the matrix around 
      self.class.new(@rows.transpose.map(&:reverse))
    end
  
    def look(value)
      #looks for a certain value within the matrix b/c the standard methods in ruby wouldn't work as well as I would have liked for this one, also returns the index of the value, this will be used to move squares
      @rows.each_with_index do |row, y|
        row.each_with_index do |val, x|
          return [x, y] if val == value
        end
      end
      nil
    end
  
    def trim
      #gets rid of nil value from matrices and removes everything that doesn't provide useful info, like empty columns and rows
      @rows = @rows.drop_while { |row| row.all?(&:nil?) }
      @rows = @rows.map { |column| column.drop(empty_columns) }
    end
  
    def align
      #aligns the rows in the matrix together
      @rows.map! { |row| Array(row) }
      @rows.map! { |row| row.concat([nil] * (width - row.length)) }
    end
  
    def width
      #returns the width of the matrix
      @rows.map(&:length).max
    end
  
    def empty_columns
      #returns columns that are empty, because we don't need to care about them until they're no longer empty
      @rows.map { |row| row.find_index { |v| v } }.compact.min
    end
  end