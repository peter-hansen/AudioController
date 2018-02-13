#!/usr/bin/env ruby

require "webrick"

class Servlet < WEBrick::HTTPServlet::AbstractServlet
    def do_GET (request, response)
        puts request.query_string
        request.query_string.split("&").each { |couplet| 
        	vararray = couplet.split("=");
        	if vararray[0] == "data" then
        		print "Slider changed to "
        		puts vararray[1]
        	end
        }
    end
end

server = WEBrick::HTTPServer.new(:Port => 4000)

server.mount "/", Servlet

trap("INT") {
    server.shutdown
}

server.start