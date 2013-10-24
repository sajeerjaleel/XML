require 'net/http'
require 'mysql2'
require_relative 'xml'
pass_url = "www.qburst.com"
pass_ext =  "/sitemap.xml" 
xml = Xml.new(pass_url,pass_ext)
xml.configure_database
xml.fetch_remote_data
xml.parse_data