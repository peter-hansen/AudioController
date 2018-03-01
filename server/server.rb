#!/usr/bin/env ruby

require "webrick"
require "digest"

class Servlet < WEBrick::HTTPServlet::AbstractServlet
    @@prng = Random.new

    @@volts = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

    @@hist = Hash.new

    def do_GET (request, response)
        puts request.query_string
        response.status = 200
        response['Content-Type'] = 'text/plain'
        response.body = ""
        i = 0
        @@volts.each_with_index { |prev, i|
            if prev <= 10 then
                @@volts[i] += @@prng.rand(-(prev)..10)
            elsif prev >= 90 then
                @@volts[i] += @@prng.rand(-10..(100-prev))
            else 
                @@volts[i] += @@prng.rand(-10..10)
            end
            response.body += "&#{i}=#{@@volts[i]}"
        }
        sha256 = Digest::SHA256.base64digest response.body
        @@hist[sha256] = @@volts
        response.body = response.body + "&" + sha256
        # request.query_string.split("&").each { |couplet| 
        # 	vararray = couplet.split("=");
        # 	if vararray[0] == "data" then
        # 		print "Slider changed to "
        # 		puts vararray[1]
        # 	end
        # }
    end
end

prng = Random.new

volts = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

hist = Hash.new

server = WEBrick::HTTPServer.new(:Port => 4000)

server.mount "/", Servlet

trap("INT") {
    server.shutdown
}

server.start