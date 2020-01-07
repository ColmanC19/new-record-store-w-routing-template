class Artist
  attr_reader :id
  attr_accessor :name

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def save
    result = DB.exec("INSERT INTO artists (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def update(name)
    @name = name
    DB.exec("UPDATE artists SET name = '#{@name}' WHERE id = #{@id};")
  end

  def ==(artist_to_compare)
    self.name() == artist_to_compare.name()
  end

  def self.all
    self.get_artists("SELECT * FROM artists;")
  end

  def self.clear
    DB.exec("DELETE FROM artists *;")
  end
  
  def self.sort
    self.get_artists("SELECT * FROM artists ORDER BY lower(name);")
    # @albums.values.sort {|a, b| a.name.downcase <=> b.name.downcase}
  end

  def update(attributes)
    if (attributes.has_key?(:name)) && (attributes.fetch(:name) != nil)
      @name = attributes.fetch(:name)
      DB.exec("UPDATE artists SET name = '#{@name}' WHERE id = #{@id};")
    end
    album_name = attributes.fetch(:album_name)
    if album_name != nil
      album = DB.exec("SELECT * FROM albums WHERE lower(name)='#{album_name.downcase}';").first
      if album != nil
        DB.exec("INSERT INTO albums_artists (album_id, artist_id) VALUES (#{album['id'].to_i}, #{@id});")
      end
    end
  end

  def self.find(id)
    artist = DB.exec("SELECT * FROM artists WHERE id = #{id};").first
    name = artist.fetch("name")
    id = artist.fetch("id").to_i
    Artist.new({:name => name, :id => id})
  end

  def delete
    DB.exec("DELETE FROM artists WHERE id = #{@id};")
  end

  def albums
  albums = []
  results = DB.exec("SELECT album_id FROM albums_artists WHERE artist_id = #{@id};")
  id_string = results.map { |n| n.fetch("album_id").to_i()}.join(', ')
  (id_string != '') ? Album.get_albums("SELECT * FROM albums where ID in (#{id_string});") : []
  # results.each() do |result|
  #   album_id = result.fetch("album_id").to_i()
  #   album = DB.exec("SELECT * FROM albums WHERE id = #{album_id};").first()
  #   name = album.fetch("name")
  #   release_year = album.fetch("release_year")
  #   genre = album.fetch("genre")
  #   artist = album.fetch("artist")
  #   albums.push(Album.new({:name => name, :id => album_id, :release_year => release_year, :genre => genre, :artist => artist}))
  # end
  # albums
end

def self.get_artists(query)
  returned_artists = DB.exec(query)
  artists = []
  returned_artists.each() do |artist|
    name = artist.fetch("name")
    id = artist.fetch("id").to_i
    artists.push(Artist.new({:name => name, :id => id}))
  end
  artists
end

end
