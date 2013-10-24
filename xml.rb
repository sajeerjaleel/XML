class Xml
	def initialize(url, url_ext)
		@data = String.new
		Net::HTTP.start(url, 80) do |http|
		@data = (http.get(url_ext).body)
		end
	end
	def configure_database
		begin
			@client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "qburst", :database => "ruby")
		rescue Exception=>e
			puts e.message
		end
	end
	def fetch_remote_data
		pos=0
		@contents=Array.new
		while @data.include? "<loc>"
			open = @data.index("<loc>")
			close = @data.index("</loc>",open)
			value = @data[open+5..close-1]
			@contents[pos] = value
			@data[open..close] = ''if close
			pos += 1
			@length = pos
		end
	end
	def parse_data
		if @client != nil
			begin
				pos = 0
				for pos in (0..@length)
					@insert = @client.query("INSERT INTO Xml (xml) VALUES ('#{ @contents[pos] }')")
				end
			rescue Exception=>e
				puts e.message
			ensure
				@client.close
			end
		end
	end
end
