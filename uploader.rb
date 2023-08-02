# frozen_string_literal: true

require 'net/sftp'

class Uploader
  CHROOT_PATH = '/upload'

  def connection
    Net::SFTP.start('0.0.0.0', 'bob', port: 2222, password: 'p')
  end

  def ls(path = '/')
    puts "\nlisting files in the #{path} dir of the SFTP server\n\n"
    connection.dir.foreach(CHROOT_PATH + path) { |entry| puts entry.longname }
  end

  def mkdir(dir)
    puts "making dir #{dir}...\n\n"
    connection.mkdir("#{CHROOT_PATH}/annual_statements/#{dir}")
  end

  def upload!(*files)
    files.flatten
         .map { |filepath| connection.upload!(filepath, "#{CHROOT_PATH}/#{filepath}") }
         .each(&:wait)

    connection.session.close
  end

end

puts File.read('logo.txt')

uploader = Uploader.new
Dir['annual_statements/*.txt'].each { |filename| uploader.upload!(filename) }
uploader.mkdir('hello_world')
uploader.ls
uploader.ls('/annual_statements')
uploader.upload!(Dir['bulk/*.txt'])
uploader.ls('/bulk')
