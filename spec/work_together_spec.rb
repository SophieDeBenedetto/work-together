require 'spec_helper'

describe WorkTogether do
  it 'has a version number' do
    expect(WorkTogether::VERSION).not_to be nil
  end

  before(:each) do 
    Student.class_variable_set(:@@all, [])
    Table.class_variable_set(:@@all, [])
  end

  context "without stored credentials" do

    before(:each) do 
      File.open(File.expand_path("../work_together") + '/lib/work_together/client.yml', 'w') {|f| f.write '' } 
    end 

    describe "#get_roster" do 

      it 'writes user credentials to lib/work_together/client.yml file' do 
        VCR.use_cassette('cassettes/student_roster') do
          STDIN.stub(:gets).and_return("SophieDeBenedetto", "fakepassword")
          wt = WorkTogether.new(168)
          wt.make_batch
          keys = YAML.load_file(File.expand_path("../work_together") + '/lib/work_together/client.yml')
          expect(keys).to eq({"GITHUB_USERNAME" => "SophieDeBenedetto", "GITHUB_PASSWORD" => "fakepassword"})
        end
      end

      it 'retrieves comma separated list of students, given a batch id, and makes students from list' do 
        VCR.use_cassette('cassettes/student_roster') do
          STDIN.stub(:gets).and_return("SophieDeBenedetto", "fakepassword")
          wt = WorkTogether.new(168)
          wt.make_batch
          expect(Student.all.length).to eq(33)
          expect(Student.all.first.name).to eq("Asia Lindsay")
        end
      end
    end
  end

  context "with stored credentials" do 
    describe "#get_roster" do 
      it 'retrieves comma separated list of students, given a batch id, and makes students from list' do 
        VCR.use_cassette('cassettes/student_roster') do
          wt = WorkTogether.new(168)
          wt.make_batch
          expect(Student.all.length).to eq(33)
          expect(Student.all.first.name).to eq("Asia Lindsay")
        end
      end
    end

    describe "#generate_togetherness" do
      context "with quiet option" do  
        it "generates the correct number of groups of 4 when given an argument of 'tables', does not puts anyting out" do 
          VCR.use_cassette('cassettes/student_roster') do
            wt = WorkTogether.new(168)
            wt.generate_togetherness(["tables", "--random"], "quiet")
            expect(Table.all.length).to eq(9)
            expect(Table.all.first.students.length).to eq(4)
            expect(Table.all.first.students.first.class).to eq(Student)
          end
        end

        it "generates the correct number of groups of 2 when given an argument of 'pairs', does not puts anyting out" do 
          VCR.use_cassette('cassettes/student_roster') do
            wt = WorkTogether.new(168)
            wt.generate_togetherness(["pairs", "--random"], "quiet")
            expect(Table.all.length).to eq(17)
            expect(Table.all.first.students.length).to eq(2)
            expect(Table.all.first.students.first.class).to eq(Student)
          end
        end
      end

      context "without quiet option" do 
        it "generates the correct number of groups of 4 when given an argument of 'tables'" do 
          VCR.use_cassette('cassettes/student_roster') do
            wt = WorkTogether.new(168)
            expect{wt.generate_togetherness(["tables", "--random"])}.to output.to_stdout
            expect(Table.all.length).to eq(9)
            expect(Table.all.first.students.length).to eq(4)
            expect(Table.all.first.students.first.class).to eq(Student)
          end
        end

        it "generates the correct number of groups of 2 when given an argument of 'pairs'" do 
          VCR.use_cassette('cassettes/student_roster') do
            wt = WorkTogether.new(168)
            expect{wt.generate_togetherness(["pairs", "--random"])}.to output.to_stdout
            expect(Table.all.length).to eq(17)
            expect(Table.all.first.students.length).to eq(2)
            expect(Table.all.first.students.first.class).to eq(Student)
          end
        end
      end
    end
  end
end