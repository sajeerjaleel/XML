class LogParser

=begin
  input : nil
  output : $file
  Read contents of a file to a string
=end
  def initialize path
    $file = File.read(path)
    @count = Hash.new(0)
  end

=begin
  input: $file
  output : @count
  Count total request grouped by date and hour
=end
  def date_time 
    $file.each_line do|line|
      time = /\d{1,2}\/[A-Z][a-z][a-z]\/\d{4}\:\d{1,2}/.match line
      if time
        @count[time[0]] += 1
      end
    end 
  end

=begin
  input : $file
  output : slowest, @url, val1, val2
  Find the slowest time groupd by date and then find corresponding URL.
  Also find slowest URL inside the log.
=end
  def date_time_url
    @slowest_time= 0
    print "\nTotal requests grouped by the Date/hour\n\n"
		
    #taking each date&hour
    @count.each do|val1,val2|
      slowest = 0
      
      #searching on each line to find slowest
      $file.each_line do|line|
	if line.include? val1
	  time = line.match /\d+$/
	  if time
	    #finding slowest time
	    time = time[0].to_i
	    if time > slowest
	      slowest = time
	    end
	  end
	end
	slowest = slowest.to_s
	#finding slowest url in corresponding date
	if line.include? slowest
	  @url = line.match /https?:\/\/[\S]+/.to_s
	end
	slowest = slowest.to_i
      end
      
      request = "request"
      #checking plural form of request.
      if val1.to_i > 1
	request += "s"
      end 
      print "#{ val1 } : #{ val2 } #{ request } \tSlowest-Time : #{ slowest } \tSlowest-URL : #{ @url }\n\n"
      #finding slowest URL in the log.
      if slowest > @slowest_time
        @slowest_time = slowest
        @slowest_url = @url
      end
    end 
    print "Slowest URL : #{ @slowest_url }\n"
  end


end

apache = LogParser.new("apache.log")
apache.date_time
apache.date_time_url


