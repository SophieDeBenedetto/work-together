require 'csv'
require_relative './student.rb'
class Parser

  def self.parse_and_make_students(file)
    CSV.foreach(file) do |row|
      make_student_attributes(row) unless row[0] == "first_name" || row[0].nil?
    end
    binding.pry
  end

  def self.make_student_attributes(row)
    name = "#{row[0]} #{row[1]}"
    progress = row[5]
    Student.new(name, progress)
  end
end