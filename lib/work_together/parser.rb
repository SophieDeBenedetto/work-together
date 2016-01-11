require 'csv'
class Parser

  def self.parse_students(file)
    CSV.parse(file, headers: true).map do |row|
      row
    end
  end
end