require 'sinatra'
require "net/http"
require "json"
require "pp"
require 'date'
require 'twitter'
require 'pony'
require_relative 'secrets.rb'

client = Twitter::REST::Client.new do |config| 
  config.consumer_key	        = SECRETS[:Twitter_Consumer_Key]
  config.consumer_secret      = SECRETS[:Twitter_Consumer_Secret]
  config.access_token	        = SECRETS[:Twitter_Access_Token]
  config.access_token_secret  = SECRETS[:Twitter_Access_Token_Secret]
end


get('/') do
	erb :news
end

get('/:lat/:long') do
	@lat = params[:lat]
	@long = params[:long]


	@tweets = client.search("geocode:#{@lat},#{@long},5km", result_type: "recent").take(3)
	uri = URI("https://api.darksky.net/forecast/#{SECRETS[:DarkSkyAPI]}/#{@lat},#{@long}")
	response = Net::HTTP.get(uri)
	@weather=JSON.load(response)
	
	@current_weather = @weather["currently"]["summary"]
	time_now_epoch = @weather["currently"]["time"]
	@time_now = Time.at(time_now_epoch)

	@forecast_summary = @weather["daily"]["summary"]

	random_quote_uri = URI("https://api.adviceslip.com/advice")
	quote_response = Net::HTTP.get(random_quote_uri)
	@quote = JSON.load(quote_response)["slip"]["advice"]

	erb :location


end

Pony.options = { :via => 'smtp', 
                 :via_options => {
                   :address => 'smtp.mailgun.org', 
                   :port => '587',
                   :enable_starttls_auto => true, 
                   :authentication => :plain,
                   :user_name => SECRETS[:Mailgun_User], 
                   :password => SECRETS[:Mailgun_Password]
                 }
               }

post('/signup') do
@name = params[:name]
@email = params[:email]
puts @name
puts @email

message = {

  :from => SECRETS[:Mailgun_Email],

  :to => "#{@name} <#{@email}>",
  :subject => 'Welcome!',

  :body => 'Thanks for signing up to our awesome newsletter!'

}

Pony.mail(message)
 erb :email
	# need to redirect back to lat long page but tricky
end

