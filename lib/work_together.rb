require_relative './work_together/version'
require_relative './work_together/parser.rb'
require_relative './work_together/table.rb'
require_relative './work_together/pair_maker.rb'
require_relative './work_together/learn_proxy.rb'
require 'colorize'

module WorkTogether

  class Generator

    attr_accessor :batch_id, :client, :pair_maker, :keys

    def initialize(batch_id=nil)
      @batch_id = batch_id
      @pair_maker = PairMaker.new
    end


    def generate_togetherness(options, quiet=nil)
      make_batch
      make_groups(options, quiet=quiet)
    end

    def make_batch
      configure_client
      student_data = get_and_parse_csv
      Student.generate_from_data(student_data)
    end

    def make_batch_data
      configure_client
      get_and_parse_csv
    end

    def make_groups(options, quiet, students=nil)
      students ||= Student.all
      flag = options[1][2..-1]
      if options.include?("pairs")
        pair_maker.public_send("make_pairs_#{flag}", students)
      elsif options.include?("tables")
        pair_maker.public_send("make_tables_#{flag}", students)
      elsif options.include?("groups")
        pair_maker.public_send("make_groups", flag, students)
      elsif options.include?("--help")
        help
      else
        puts "Please enter a valid command. Type work-together --help for more."
      end
      Group.display_groups if !quiet && Group.all.length > 0
    end

    private 

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
        Parser.parse_students(roster)
      end
  end

  class Group
     
    def self.all
      Table.all
    end

    def self.all_students
      self.all.map do |group|
        group.students.map do |student|
          student
        end
      end.flatten
    end

    def self.display_groups
      Table.all.each_with_index do |table, i|
        puts "Group #{i + 1}:".colorize(:blue)
        table.students.each do |student|
          puts student.name.colorize(:light_blue)
        end
        puts "-------------------".colorize(:blue)
      end
    end
  end

  class Student
    @@all = []

    attr_accessor :first_name, :last_name, :completion, :github_username, :email, :active_track

    def initialize
      @@all << self
    end

    def self.all
      @@all 
    end

    def self.build_attributes(headers)
      headers.each do |header| 
        attr_accessor header.to_sym
      end
    end

    def name
      "#{first_name} #{last_name}"
    end

    def progress
      self.completion
    end

    def self.attributes_from_data(data)
      attributes = data.first.to_hash.keys
      self.build_attributes(attributes)
    end

    def self.generate_from_data(data)
      attributes_from_data(data)
      data.each do |student_hash|
        student_hash.delete_if {|attribute, value| !Student.instance_methods.include?(attribute.to_sym)}
        self.new.tap do |student|
          student_hash.each do |attribute, value|
            student.public_send("#{attribute}=", value)
          end
        end
      end
    end
    
  end
end

