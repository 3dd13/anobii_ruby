require 'rubygems'
require 'open-uri'
require 'cgi'
require 'digest/md5'
require 'xmlsimple'
    
module Anobii
  SIMPLE_SHELF_URL = "http://api.anobii.com/shelf/getSimpleShelf"
  ITEM_INFO_URL = "http://api.anobii.com/item/getInfo"
  
  # get your API key at http://www.anobii.com/api_home
  # put your API KEY and SECRET CODE here
  API_KEY = ""
  API_SECRET_CODE = ""
  
  class BookShelf
    attr_accessor :user_id, :items
    def initialize(user_id)
      @user_id = user_id
    end
    
    def update_item_info
      items.each do |item|
        params = Anobii.item_info(item.id)
        item.title    = params[:title]
        item.subtitle = params[:subtitle]
        item.format   = params[:format]
        item.language = params[:language]
        item.cover    = params[:cover]
      end
    end
  end
  
  class Item
    def initialize(id, progress, start_date, end_date)
      @id, @progress, @start_date, @end_date = id, progress, start_date, end_date
    end
    
    attr_accessor :id, :progress, :start_date, :end_date, :title, :subtitle, :format, :language, :cover
  end

  def self.item_info(item_id)
    url = "#{ITEM_INFO_URL}?#{api_parameters}&item_id=#{item_id}"
    data = XmlSimple.xml_in(URI.parse(url).read)

    item = data['item'][0]

    uri = URI.parse(item['cover'])
    uri_params = CGI.parse(uri.query)

    {:language => item['language'], :subtitle => item['subtitle'], :title => item['title'],
      :format => item['format'], :cover => "http://image.anobii.com/anobi/image_book.php?type=4&item_id=#{uri_params["item_id"]}"}
  end
  
  def self.simple_shelf(user_id)
    url = "#{SIMPLE_SHELF_URL}?#{api_parameters}&user_id=#{user_id}"
    data = XmlSimple.xml_in(URI.parse(url).read)
    
    book_shelf = BookShelf.new(:user_id => data["user_id"])
    book_shelf.items = []
    data['items'].each do |items|
      items["item"].each do |item|
        book_shelf.items << Item.new(item["id"], item["progress"], item["start_date"], item["end_date"])
      end
    end
    
    book_shelf
  end
  
  private
  
  def self.api_parameters
    api_sig = Digest::MD5.hexdigest("#{API_KEY}#{API_SECRET_CODE}")
    "api_key=#{API_KEY}&api_sig=#{api_sig}"
  end
end
