require('sinatra')
require('sinatra/reloader')
require('./lib/album')
require('pry')
also_reload('lib/**/*.rb')
require('./lib/song')
require("pg")

DB =PG.connect({:dbname => "record_store"})

get('/test') do
  @something = "this is a variable"
  erb(:whatever)
end

get('/') do
  @albums = Album.all
  erb(:albums)
end

get('/albums') do
  if params["clear"]
    @albums = Album.clear()
  elsif params["search_input"]
    @albums = Album.search(params["search_input"])
  elsif params["sort_list"]
    @albums = Album.sort()

  else
    @albums = Album.all
  end
  erb(:albums)
end

get('/albums/new') do
  erb(:new_album)
end

post('/albums') do
  name = params[:album_name]
  release_year = params[:release_year].to_i
  genre = params[:genre_name]
  artist = params[:artist_name]
  album = Album.new(:name => name, :id => nil, :release_year => release_year, :genre => genre, :artist => artist)
  album.save()
  @albums = Album.all()
  erb(:albums)
end

get('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  erb(:album)
end

get('/albums/:id/edit') do
@album = Album.find(params[:id].to_i())
erb(:edit_album)
end

patch('/albums/:id') do
@album  = Album.find(params[:id].to_i())
@album.update(params)
@albums = Album.all
erb(:albums)
end

delete('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  @album.delete()
  @albums = Album.all
  erb(:albums)
end

#SONG FUNCTIONALITY !!!!

# Get the detail for a specific song such as lyrics and songwriters.
get('/albums/:id/songs/:song_id') do
  @song = Song.find(params[:song_id].to_i())
  erb(:song)
end

# Post a new song. After the song is added, Sinatra will route to the view for the album the song belongs to.
post('/albums/:id/songs') do
  @album = Album.find(params[:id].to_i())
  params[:album_id] = params[:id]
  song = Song.new(params)
  song.save()
  erb(:album)
end

# Edit a song and then route back to the album view.
patch('/albums/:id/songs/:song_id') do
  @album = Album.find(params[:id].to_i())
  song = Song.find(params[:song_id].to_i())
  song.update(params[:name], @album.id)
  erb(:album)
end

# Delete a song and then route back to the album view.
delete('/albums/:id/songs/:song_id') do
  song = Song.find(params[:song_id].to_i())
  song.delete
  @album = Album.find(params[:id].to_i())
  erb(:album)
end


#Artists Routing¡! - -- - -- - - - - - - - >

get('/artists') do
  if params["clear"]
    @artists = Artist.clear()
  elsif params["search_input"]
    @artists = Artist.search(params["search_input"])
  elsif params["sort_list"]
    @artists = Artist.sort()
  else
    @artists = Artist.all
  end
  erb(:artists)
end

get('/artists/:id') do
  @artist = Artist.find(params[:id].to_i())
  erb(:artists)
end

post('/artists') do
  name = params[:album_name]
  artist = Artist.new(name, nil)
  artist.save()
  @artists = Artist.all()
  erb(:artists)
end

patch('/artists/:id') do
@artist  = Artist.find(params[:id].to_i())
@artist.update(params[:name])
@artists = Artist.all
erb(:artist)
end

delete('/artists/:id') do
  @artist = Artist.find(params[:id].to_i())
  @artist.delete()
  @artists = Artist.all
  erb(:artists)
end

# get('/custom_route') do
#   "We can even create custom routes, but we should only do this when needed."
# end
