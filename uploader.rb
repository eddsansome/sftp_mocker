require 'net/sftp'

class Uploader
  def initialize
    @connection = Net::SFTP.start('0.0.0.0', 'bob', port: 2222, password: 'p')
  end

  def upload!(filepath)
    connection.upload!(filepath, filepath)
  end

  private

  attr_reader :connection
end

uploader = Uploader.new

Dir['annual_statements/*.txt'].each { |filename| uploader.upload!(filename) }
