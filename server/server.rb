#!/usr/bin/env ruby

require "webrick"
require "digest"

class Servlet < WEBrick::HTTPServlet::AbstractServlet
    @@prng = Random.new
    @@volts = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    @@hist = Hash.new
    @@change = Hash.new
    @@on = false

    def do_GET (request, response)
        if !@@on then
            start_detection()
            @@on = true
        end

        response.status = 200
        response['Content-Type'] = 'text/plain'
        response.body = ""
        i = 0
        @@change.each do |key, val|
            response.body += "&#{key}=#{val}"
        end
        @@change = Hash.new
        sha256 = Digest::SHA256.base64digest response.body
        @@hist[sha256] = @@volts
        response.body = response.body + "&" + sha256
        puts response.body
        # request.query_string.split("&").each { |couplet| 
        # 	vararray = couplet.split("=");
        # 	if vararray[0] == "data" then
        # 		print "Slider changed to "
        # 		puts vararray[1]
        # 	end
        # }
    end

    def start_detection()
        Thread.new do 
            while true do   
                i = 0
                @@volts.each_with_index { |prev, i|
                    if prev <= 4 then
                        @@volts[i] += @@prng.rand(-(prev)..4)
                        @@change[i] = @@volts[i]
                    elsif prev >= 96 then
                        @@volts[i] += @@prng.rand(-4..(100-prev))
                        @@change[i] = @@volts[i]
                    else 
                        d = @@prng.rand(-4..4)
                        @@volts[i] += d
                        if d != 0 then
                            @@change[i] = @@volts[i]
                        end 
                    end
                }
                sleep 0.75
            end
        end
        return
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

