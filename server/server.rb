require 'socket'
server = TCPServer.new 4000

while session = server.accept
	while line = session.gets
		puts line
		session.print "HTTP/1.1 200\r\n" # 1
	  	session.print "Content-Type: text/html\r\n" # 2
	  	session.print "\r\n" # 3
	  	session.print "Hello world! The time is #{Time.now}"
	end
  	session.close
end