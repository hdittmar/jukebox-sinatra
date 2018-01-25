require "sinatra"
require "sinatra/reloader" if development?
require "sqlite3"

DB = SQLite3::Database.new(File.join(File.dirname(__FILE__), 'db/jukebox.sqlite'))

get "/" do
  # TODO: Gather all artists to be displayed on home page
  query = <<-SQL
    SELECT artists.name, artists.id
    FROM artists
  SQL

  @results = DB.execute(query)
  erb :home # Will render views/home.erb file (embedded in layout.erb)
end

get "/artists/:something" do
 # p params[:something]
  query = "
    SELECT artists.name, genres.name, albums.title, albums.id
    FROM albums
    JOIN tracks ON tracks.album_id = albums.id
    JOIN artists ON albums.artist_id = artists.id
    JOIN genres ON tracks.genre_id = genres.id
    WHERE artists.id = #{params[:something]}
    GROUP BY albums.title
  "
 p query
  @results = DB.execute(query)
  p @results

  erb :artist
end

get "/albums/:something" do
 # p params[:something]
  query = "
    SELECT albums.title, tracks.name, tracks.id
    FROM albums
    JOIN tracks ON tracks.album_id = albums.id
    WHERE albums.id = #{params[:something]}
  "
 # p query
  @results = DB.execute(query)
  p @results
  erb :album
end

get "/tracks/:something" do
 # p params[:something]
  query = "
    SELECT tracks.name
    FROM tracks
    WHERE tracks.id = #{params[:something]}
  "
 # p query
  @results = DB.execute(query)
  p @results
  erb :track
end


# `id`  INTEGER NOT NULL,
#   `album_id`  INTEGER,
#   `media_type_id` INTEGER NOT NULL,
#   `genre_id`  INTEGER,
#   `name`  NVARCHAR(200) NOT NULL,
#   `composer`  NVARCHAR(220),
#   `milliseconds`  INTEGER NOT NULL,
#   `bytes` INTEGER,
#   `unit_price`  NUMERIC(10,2) NOT NULL,
# Then:
# 1. Create an artist page with all the albums. Display genres as well
# 2. Create an album pages with all the tracks
# 3. Create a track page with all the track info
