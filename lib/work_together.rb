require_relative './work_together/version'
require_relative './work_together/student.rb'
require_relative './work_together/parser.rb'
require_relative './work_together/table.rb'
require_relative './work_together/pair_maker.rb'

class WorkTogether

  attr_accessor :roster, :students, :pair_maker

  def initialize(path_to_csv)
    @roster = path_to_csv
    @pair_maker = PairMaker.new
  end

  def generate_togetherness(options)
    make_students
    if options.include?("make-pairs")
      binding.pry
      pair_maker.public_send("make_pairs_#{options[0]}")
    elsif options.include?("make-tables")
    end
  end

  def make_students
    Parser.parse_and_make_students(roster)
    @students = Student.all
  end
end
