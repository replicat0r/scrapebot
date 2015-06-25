require 'rubygems'
require 'mechanize'
require 'nokogiri'

mech = Mechanize.new
mech.get("https://www.places4students.com/Places/PropertyListings.aspx?SchoolID=8SnFMiLCDsA%3d")
puts mech.page.parser.css("title").text.strip 
form = mech.page.form_with(:action=>/Disclaimer.aspx/) 
form.submit(form.button_with(:value=>'I Agree'))
puts mech.page.parser.css("title").text.strip
File.open('file.html', 'w'){|f| f.puts mech.page.parser.to_html} 

properties = []
listings = Nokogiri::HTML(open('file.html')) 
listings.css(".listing-title a").each do |link|
	
	mech = Mechanize.new
	mech.get("https://www.places4students.com/Places/#{link['href']}")
	File.open('file.html', 'w'){|f| f.puts mech.page.parser.to_html}
	post = Nokogiri::HTML(open("file.html"))
	listing = []
	post.css(".loaction-container>table>tr>td:nth-child(2)").each do |row|
		listing.push(row.text.strip) if !(row.text.strip.include? "View Google Map")
	end
	properties.push(listing);
end

File.open('data.txt', 'w'){|f|
	properties.each do |p|
		f.puts p.join(",") + "\n"
	end
}


