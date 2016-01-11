require 'mechanize'

module LearnProxy
  class Client
    CSV_URL = -> (batch_id) {"https://learn.co/batches/#{batch_id}/students.csv"}

    def initialize(credentials)
      @credentials = credentials
    end

    def csv_for(batch_id)
      connection.get(CSV_URL[batch_id]).body
    end

    private
    attr_reader :credentials

    def connection
      @connection ||= Connection.new(credentials)
    end
  end

  class Connection
    extend Forwardable
    def_delegator :@session, :get

    def initialize(credentials)
      @credentials = credentials
      connect!
    end

    private
    attr_reader :credentials
    def connect!
      @session ||= begin
        Mechanize.new.tap do |client|
          client.get('https://learn.co/sign_in/github?sign_in=true')
          form = client.page.form_with!(action: "/session")
          GithubForm.submit(form, credentials)
          client.page.link_with!(href: /learn\.co/).click
        end
      end
    end
  end

  module GithubForm
    def self.submit(form, credentials)
      form['login'] = credentials.username
      form['password'] = credentials.password
      form.submit
    end
  end

  class Credentials
    attr_accessor :username, :password
    def initialize(username, password)
      @username = username
      @password = password
    end
  end
end






