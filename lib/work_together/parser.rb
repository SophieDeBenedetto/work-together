require 'csv'
require_relative './student.rb'

class Parser

  def self.parse_and_make_students(file)
    CSV.foreach(file) do |row|
      name = "#{row[0]} #{row[1]}"
      progress = row[5]
      Student.new(name, progress)
    end
  end
end