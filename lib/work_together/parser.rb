require 'csv'
require_relative './student.rb'
class Parser

  def self.parse_and_make_students(file)
    CSV.parse(file, headers: true).each do |row|
      make_student_with_attributes(row.to_h) unless row[0] == "first_name" || row[0].nil?
    end
  end

  def self.make_student_with_attributes(row)
    row.delete_if {|k, v| !Student.instance_methods.include?(k.to_sym)}
    Student.new.tap do |student|
      row.each do |attribute, value|
        student.public_send("#{attribute}=", value)
      end
    end
  end
end