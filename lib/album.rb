class Album
  attr_accessor :name, :id, :release_year, :genre, :artist

  # Class variables have been removed.

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
    @release_year = attributes.fetch(:release_year)
    @genre = attributes.fetch(:genre)
    @artist = attributes.fetch(:artist)
  end

  def save
    result = DB.exec("INSERT INTO albums (name, release_year, genre, artist) VALUES ('#{@name}', #{@release_year}, '#{@genre}', '#{@artist}') RETURNING id;")
    # binding.pry
    @id = result.first().fetch("id").to_i
  end

  def update(name)
    @name = name
    DB.exec("UPDATE albums SET name = '#{@name}' WHERE id = #{@id};")
  end


  def ==(album_to_compare)
    self.name() == album_to_compare.name()
  end

  def self.all
    self.get_albums("SELECT * FROM albums;")
  end

  def self.clear
    DB.exec("DELETE FROM albums *;")
  end

  def self.find(id)
    album = DB.exec("SELECT * FROM albums WHERE id = #{id};").first
    # binding.pry
    name = album.fetch("name")
    id = album.fetch("id").to_i
    release_year = album.fetch("release_year")
    genre = album.fetch("genre")
    artist = album.fetch("artist")
    Album.new({:name => name, :id => id, :release_year => release_year, :genre => genre, :artist => artist})
  end

  def delete
    DB.exec("DELETE FROM albums WHERE id = #{@id};")
    DB.exec("DELETE FROM songs WHERE album_id = #{@id};")
  end

  def self.get_albums(query)
    returned_albums = DB.exec(query)
    albums = []
    returned_albums.each() do |album|
      name = album.fetch("name")
      id = album.fetch("id").to_i
      release_year = album.fetch("release_year")
      genre = album.fetch("genre")
      artist = album.fetch("artist")
      albums.push(Album.new({:name => name, :id => id, :release_year => release_year, :genre => genre, :artist => artist}))
    end
    albums
  end

  def self.sort
    self.get_albums("SELECT * FROM albums ORDER BY lower(name);")
    # @albums.values.sort {|a, b| a.name.downcase <=> b.name.downcase}
  end

  def self.search(x)
    self.get_albums("SELECT * FROM albums WHERE name = '#{x}'")
    # @albums.values.select { |e| /#{x}/i.match? e.name}
  end

  def songs                         #find songs by album
    Song.find_by_album(self.id)
  end

end

# reg ex = {paramter passed in}/(not case sensitive)
