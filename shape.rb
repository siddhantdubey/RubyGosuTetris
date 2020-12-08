class Shape
  #the shapes array details all the different block shapes that will be used in the game
  SHAPES = [
    [[[0, 0], [0, 1], [1, 0], [1, 1]], Gosu::Color::BLUE],
    [[[0, 0], [0, 1], [0, 2], [0, 3]], Gosu::Color::AQUA],
    [[[0, 0], [1, 0], [1, 1], [2, 1]], Gosu::Color::RED],
    [[[0, 1], [1, 1], [1, 0], [2, 0]], Gosu::Color::GREEN],
    [[[0, 0], [1, 0], [1, 1], [1, 2]], Gosu::Color.argb(0xff_ffa500)],
    [[[0, 0], [1, 0], [0, 1], [0, 2]], Gosu::Color::YELLOW],
    [[[1, 0], [0, 1], [1, 1], [2, 1]], Gosu::Color::FUCHSIA], 
    [[[0, 0], [0, 0], [0,0], [0, 0]], Gosu::Color::GRAY] #this is the "bomb" block that will delete the column in which it lands
  ]

  def self.random(grid)
    #picks a random shape to use
    coordinates, color = SHAPES.sample
    blocks = coordinates.map { |x, y| Square.new(x, y, color) }
    new(blocks, grid) 
  end

  def initialize(blocks, grid)
    @blocks = blocks #the blocks that make up the shape
    @grid = grid #the grid the shape belongs to
  end

  def draw
    @blocks.each(&:draw) #draws the block by drawing the blocks that make up the shape
  end

  def fall(speed)
    move(y: speed) unless haslanded? #moves the shape unless the shape has already haslanded in the grid
  end

  def rotate
    if @blocks[0].color == Gosu::Color::GRAY #the gray block won't rotate and will crash if the move_relative_to_matrices method is used, so preventing rotation is the solution. This doesn't affect gameplay because the gray block is only one block so rotating it wouldn't matter anyways.
      puts "Can't rotate this block." #this will let the player know what's happening.
    else
      matrix = Matrix.new #creates a matrix for the shape to be placed in allowing for it to be rotated
      @blocks.each { |block| block.place(matrix) } #adds the blocks in the matrix
      matrix.trim #removes unnecessary bits of the matrix
      rotated = matrix.rotate #creates the roated matrix to compare to so that the blocks can be rotated
      @blocks.each { |block| block.move_relative_to_matrices(matrix, rotated) } #this line actually rotates the entire shape by comparing the position of blocks in the old matrix to the new rotated matrix
    end    
  end

  def land
    #this handles the landing of the shapes
    if @blocks[0].color == Gosu::Color::GRAY #the bomb shape doesn't actually land, it just blows up (deletes) the column
      @blocks.each{|block| @grid.explode(block)} #explodes the column the shape was placed in
    else
      @blocks.each { |block| @grid.land(block) } #if the shape isn't a bomb, it just places it like in normal tetris
    end
  end

  def haslanded?
    @blocks.any? { |block| block.haslanded?(@grid) } #checks to see if the shape has haslanded yet by checking to see if each block has haslanded
  end

  def move_right
    move(x: 1) unless blocked?(1) #handles moving right unles the position is blocked off
  end

  def move_left
    move(x: -1) unless blocked?(-1) #handles moving left unless the position is blocked off
  end

  private #these following methods are private and can only be accessed within this file

  def move(x: 0, y: 0)
    #moves the shapes
    @blocks.each { |block| block.move(x: x, y: y) }
  end

  def blocked?(offset_x)
    #checks to see if the shape's area is blocked off
    @blocks.any? { |block| block.blocked?(offset_x, @grid) }
  end
end