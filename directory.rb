require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'sinatra'
require 'json'

get '/' do
  "<h1>Northwestern Directory API</h1>
   <p>Make a GET request to http://northwesterndirectory.heroku.com/&lt;NETID&gt;</p>"
end

get '/:netid' do
  content_type :json
  dir = DirectoryEntry.new
  dir.load(params[:netid])
  dir.json
end

class DirectoryEntry
  attr_accessor :name, :email, :address, :phone
  def initialize
    @baseurl = "http://cs.northwestern.edu/~cel294/netid.php?netid="
  end

  def load netid
    @html = Nokogiri::HTML(open(@baseurl + netid))
    @table = @html.css("table[width='600'] td[bgcolor='#CCCCCC']")
    get_name
    get_email
    get_phone
    get_address
  end

  def get_name
    @name = @html.css("table[width='600'] td[bgcolor='#CCCCCC']").first.css('b').text
  end

  def get_email
    @email = @html.css("table[width='600'] td[bgcolor='#CCCCCC']").first.css("a[href]").last.text
  end

  def get_phone
    @phone = @html.css("table[width='600'] td[bgcolor='#CCCCCC']")[1].text.chomp
  end

  def get_address
    @address = @html.css("table[width='600'] td[bgcolor='#CCCCCC']")[2].text.chomp
  end

  def json
    {:name=>@name,
     :email=>@email,
     :phone=>@phone,
     :address=>@address}.to_json
  end
end
