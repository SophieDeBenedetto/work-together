require_relative './work_together/version'
require_relative './work_together/student.rb'
require_relative './work_together/parser.rb'
require_relative './work_together/table.rb'
require_relative './work_together/pair_maker.rb'

class WorkTogether

  attr_accessor :roster, :students, :pair_maker

  def initialize(path_to_csv=nil)
    @roster = path_to_csv
    @pair_maker = PairMaker.new
  end

  def generate_togetherness(options)
    make_students
    flag = options[1][2..-1]
    if options.include?("pairs")
      pair_maker.public_send("make_pairs_#{flag}", self.students)
      display_tables
    elsif options.include?("tables")
      pair_maker.public_send("make_tables_#{flag}", self.students)
      display_tables
    elsif options.include?("--help")
      help
    else
      puts "Please enter a valid command. Type work-together --help for more."
    end
  end

  def display_tables
    Table.all.each_with_index do |table, i|
        puts "Group #{i + 1}:"
        table.students.each do |student|
          puts student.name
        end
        puts "-------------------"
      end
  end

  def help
    puts "Available commands:"
      puts "work-together pairs --random path/to/csv-roster         generate pairs randomly"
      puts "work-together pairs --progress path/to/csv-roster       generate pairs grouped by similar progress"
      puts "work-together pairs --mindful path/to/csv-roster        generate pairs with one person who is more advanced, one person less advanced"
      puts "work-together tables --random path/to/csv-roster        generate tables randomly"
      puts "work-together tables --random path/to/csv-roster        generate tables grouped by similar progress"
      puts "work-together tables --random path/to/csv-roster        generate tables with some people more advanced, some less"
  end

  def make_students
    Parser.parse_and_make_students(roster)
    @students = Student.all
  end
end
