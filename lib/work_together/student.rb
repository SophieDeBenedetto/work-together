class Student

  @@all = []

  attr_accessor :first_name, :last_name, :completion, :github_username, :email, :active_track

  def initialize
    @@all << self
  end

  def self.all
    @@all 
  end

  def name
    "#{first_name} #{last_name}"
  end

  def progress
    self.completion
  end
  
end
