class Table
  @@all = []

  def initialize(student_array)
    @students = student_array
    @@all << self unless student_array.include?([])
  end

  def students
    @students
  end

  def self.all
    @@all
  end
end