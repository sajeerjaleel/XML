require 'nokogiri'
require 'open-uri'
require 'mysql2'
require_relative 'nokogiri'
#url to be passed
pass_url = "http://www.qburst.com/sitemap.xml"
xml = Xml.new(pass_url)
xml.configure_database
xml.fetch_remote_data
xml.parse_data