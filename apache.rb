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
  output : @slowest_time, @url
  Find the slowest time and then find corresponding URL
=end
  def slowest_URL
    @slowest_time = 0
		
    $file.each_line do|line|
      @time = line.match /\d+$/
      #converting nilclass
      if @time == nil
	@time = ""
      end
      #converting matchdata to integer and find largest
      @time = @time[0].to_i
      if @time>@slowest_time
        @slowest_time = @time
      end
    end
		
    #find corresponding URL 
    @slowest_time = @slowest_time.to_s
    $file.each_line do|line|
      if line.include? @slowest_time
        @url = line.match /https?:\/\/[\S]+/.to_s
      end
    end	
  end

=begin
  input : nil
  output : @count, @url	
  Print the values
=end
  def statistics
    @count.each do|val1,val2|
      puts "#{val1} : #{val2}" 
    end
    puts "Slowest URL : #{ @url } "
  end

end

apache = LogParser.new("apache.log")
apache.date_time
apache.slowest_URL
apache.statistics
