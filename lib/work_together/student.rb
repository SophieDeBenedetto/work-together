class Student

  @@all = []

  attr_accessor :name, :progress

  def initialize(name, progress)
    @name = name
    @progress = progress
    @@all << self
  end

  def self.all
    @@all 
  end
end
