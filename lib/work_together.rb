require_relative './work_together/version'
require_relative './work_together/student.rb'
require_relative './work_together/parser.rb'
require_relative './work_together/table.rb'
require_relative './work_together/pair_maker.rb'
require_relative './work_together/learn_proxy.rb'
require 'pry'
require 'colorize'

class WorkTogether

  attr_accessor :batch_id, :client, :pair_maker, :keys, :students

  def initialize(batch_id)
    @batch_id = batch_id
    @pair_maker = PairMaker.new
  end


  def generate_togetherness(options, quiet=nil)
    make_batch
    make_groups(options, quiet=quiet)
  end

  def make_batch
    configure_client
    get_and_parse_csv
    @students = Student.all
  end

  def make_groups(options, quiet)
    flag = options[1][2..-1]
    if options.include?("pairs")
      pair_maker.public_send("make_pairs_#{flag}", self.students)
    elsif options.include?("tables")
      pair_maker.public_send("make_tables_#{flag}", self.students)
    elsif options.include?("--help")
      help
    else
      puts "Please enter a valid command. Type work-together --help for more."
    end
    display_tables if !quiet && Table.all.length > 0
  end

  private 

    def display_tables
      Table.all.each_with_index do |table, i|
          puts "Group #{i + 1}:".colorize(:blue)
          table.students.each do |student|
            puts student.name.colorize(:light_blue)
          end
          puts "-------------------".colorize(:blue)
        end
    end

    def help
      puts "Available commands:"
        puts "work-together pairs --random batch-number    generate pairs randomly"
        puts "work-together pairs --progress batch-number  generate pairs grouped by similar progress"
        puts "work-together pairs --mindful batch-number   generate pairs with one person who is more advanced, one person less advanced"
        puts "work-together tables --random batch-number   generate tables randomly"
        puts "work-together tables --progress batch-number   generate tables grouped by similar progress"
        puts "work-together tables --mindful batch-number   generate tables with some people more advanced, some less"
    end

    def configure_client
      configure_keys
      credentials = LearnProxy::Credentials.new(self.keys['GITHUB_USERNAME'],  self.keys['GITHUB_PASSWORD'])
      @client = LearnProxy::Client.new(credentials)
    end

    def configure_keys
      @keys = YAML.load_file(File.expand_path(File.dirname(__FILE__)) + '/work_together/client.yml')
      get_and_store_keys unless @keys
    end

    def get_and_store_keys
      puts "Please enter your github username:"
      username = STDIN.gets.chomp
      puts "Please enter your github password:"
      password = STDIN.gets.chomp
      @keys = {"GITHUB_USERNAME" => username, "GITHUB_PASSWORD" => password}
      File.open(File.expand_path(File.dirname(__FILE__)) + '/work_together/client.yml', 'w') {|f| f.write self.keys.to_yaml } 
    end

    def get_roster
      self.client.csv_for(self.batch_id)
    end

    def get_and_parse_csv
      roster = get_roster
      Parser.parse_and_make_students(roster)
    end
end

