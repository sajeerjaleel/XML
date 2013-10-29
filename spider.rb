require 'nokogiri' 
require 'open-uri'
require 'mysql2'
$client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "qburst", :database => "ruby")

=begin
	input : nil
	output : url
	fetches category name and passes category url
=end
def categories
	$count = nil
	page = Nokogiri::HTML(open("http://www.1mobile.com/downloads/"))  
	
	page.css('div.c a').each do |a|
		#The top 6 Download list are removed		
		if a.text.strip == "Action"
			$count = 1
		end
		#The loop begins only after the category 'Action'
		if $count
			category = a.text.strip
			url = a["href"]
			$client.query("INSERT INTO categories (name) VALUES ('#{ category }')")
			name(url,category)
		end
	
	end
end

=begin
	input : url, category
	outout : url_app,app_name
	fetches application name and passes application url
=end
def name(url,category)

	#Category page
	pages = Nokogiri::HTML(open("http://www.1mobile.com"+url)) 
		
	pages.css('div.searchapps li p a').each do |a|
		app_name = a.text.strip.gsub("'","")
		url_app = a["href"]
		url_app = url_app.gsub("[free]-","")
		contents(url_app,app_name,category)
	end

	sleep 2
end

=begin
	input : url_app,app_name,category
	output : image_url, description
	fetches app description and screen shots and insert into database
=end
def contents(url_app,app_name,category)

	#Application page
	page = Nokogiri::HTML(open("http://www.1mobile.com"+url_app))

	#fetching Description
	description = page.css('div.simpleinfo').text.strip.gsub("'","")
	$client.query("INSERT INTO applications (Description,categories,Name) VALUES ('#{ description }','#{ category }','#{ app_name }')")

	#fetching screen shots
	page.css('div.detailslidercnt a img').each do|a|
		image_url = a["src"]
		$client.query("INSERT INTO screen_shots (application,Image_URL) VALUES ('#{ app_name }','#{ image_url }')")
	end

end

categories
$client.close

