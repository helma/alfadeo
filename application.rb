require "rubygems"
require "sinatra"
gem "soundcloud-ruby-api-wrapper"
require "soundcloud"
require "sass"
require "haml"
require "oauth"

# macht es etwas kuerzer
before do 
  begin # catch soundcloud 503 errors
    sc_client = Soundcloud.register({:consumer_key => "nhqSzBoKjSYaEBeQapZM6A"})                   
    @user = sc_client.User.find("alfadeo")
  rescue
    haml :sc_error
  end
end

get "/?" do
  begin # catch soundcloud 503 errors
    @playlists = @user.playlists.find(:first) # params[:id] is nil
    haml :playlists
  rescue
    haml :sc_error
  end
end

get "/news/?" do
  begin
    @playlists = @user.playlists.find(:first) 
    haml :playlists
  rescue
    haml :sc_error
  end
end

get "/releases/?" do
  begin
    @playlists = @user.playlists.reject{|p| p if p.title.match(/Remixes/i) or p.title.match(/Dicrom/i)}
    haml :playlists
  rescue
    haml :sc_error
  end
end

get "/dicrom/?" do
  begin
    @playlists = @user.playlists.collect{|p| p if p.title.match(/Dicrom - The Remixes/i)}.compact
    haml :dicrom
  rescue
    haml :sc_error
  end
end

get "/remixes/?" do
  begin
    @tracks = @user.tracks.collect{|p| p if p.title.match(/alfadeo remix/i)}.compact  
    haml :remixes
  rescue
    haml :sc_error
  end
end

get "/about/?" do
  haml :about
end

get "/style.css" do
	headers "Content-Type" => "text/css; charset=utf-8"
	sass :style
end

