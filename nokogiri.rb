=begin
  Class for parsing XML contents to database
  'Nokogiri' gem is used to get data from xml 
  Data is passed to the database using 'mysql2'
=end 

class Xml

=begin
	input : url
	output : @xml_doc
	pass url and get xml contents inside the url
=end
  def initialize(url)
    @xml_doc  = Nokogiri::XML(open(url))
  end

=begin
	input : nil 
	output : @client
	Create connection with database
=end
  def configure_database
	begin
	  @client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "qburst", :database => "ruby")
	rescue Exception=>e
	  puts e.message
	end
  end
  
=begin
	input : @xml_doc
	output : @text
	Fetch all datas inside the <loc> node
=end
  def fetch_remote_data
    @doc = @xml_doc. remove_namespaces!() 
		@text = @doc.search('url/loc').xpath('text()')
  end

=begin
	input : @client
	output : @insert
	Insert the data into the database
=end
  def parse_data
		if @client != nil
	  	begin
	    	@text.each do |content|
				@insert = @client.query("INSERT INTO Xml (xml) VALUES ('#{ content }')")
	  	end
	  	
	  	rescue Exception=>e
				puts e.message
	  	ensure
				@client.close
	  	end
		end
  end
end
