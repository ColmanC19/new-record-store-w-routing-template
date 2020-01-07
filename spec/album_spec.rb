require 'rspec'
require 'album'
require 'song'
require 'spec_helper'

describe '#Album' do

  before(:each) do
    Album.clear()
  end

  describe('#==') do
    it("is the same album if it has the same attributes as another album") do
      album = Album.new({ :name => "Blue", :id => nil, :release_year => 1990, :genre => "hiphop", :artist => "Prince"})
      album2 = Album.new({ :name => "Blue", :id => nil, :release_year => 1990, :genre => "hiphop", :artist => "Prince"})
      expect(album).to(eq(album2))
    end
  end

  describe('#save') do
    it("saves an album") do
      album = Album.new({:name => "Giant Steps", :id => nil, :release_year => 1990, :genre => "hiphop", :artist => "Johnny"}) # nil, nil added as second argument
      album.save()
      album2 = Album.new({ :name => "Blue", :id => nil, :release_year => 1990, :genre => "hiphop", :artist => "Prince"}) # nil, nil added as second argument
      album2.save()
      expect(Album.all).to(eq([album, album2]))
    end
  end

  describe('#delete') do
    it("deletes an album by id") do
      album = Album.new({:name => "Giant Steps", :id => nil, :release_year => 1990, :genre => "hiphop", :artist => "Johnny"})
      album.save()
      album2 = Album.new({ :name => "Blue", :id => nil, :release_year => 1990, :genre => "hiphop", :artist => "Prince"})
      album2.save()
      album.delete()
      expect(Album.all).to(eq([album2]))
    end
  end

  describe('.all') do
    it("returns an empty array when there are no albums") do
      expect(Album.all).to(eq([]))
    end
  end

  describe('.clear') do
    it("clears all albums") do
      album = Album.new({:name => "Giant Steps", :id => nil, :release_year => 1990, :genre => "hiphop", :artist => "Johnny"})
      album.save()
      album2 = Album.new({ :name => "Blue", :id => nil, :release_year => 1990, :genre => "hiphop", :artist => "Prince"})
      album2.save()
      Album.clear()
      expect(Album.all).to(eq([]))
    end
  end

  describe('.find') do
    it("finds an album by id") do
      album = Album.new({:name => "Giant Steps", :id => nil, :release_year => 1990, :genre => "hiphop", :artist => "Johnny"})
      album.save()
      album2 = Album.new({ :name => "Blue", :id => nil, :release_year => 1990, :genre => "hiphop", :artist => "Prince"})
      album2.save()
      expect(Album.find(album.id)).to(eq(album))
    end
  end

  describe('#update') do
    it("updates an album by id") do
      album = Album.new({:name => "Giant Steps", :id => nil, :release_year => 1990, :genre => "hiphop", :artist => "Johnny"})
      album.save()
      album.update("Blue")
      expect(album.name).to(eq("Blue"))
    end
  end

  describe('#add_properties') do
    it("Add the release year to an album") do
      album = Album.new({:name => "Giant Steps", :id => nil, :release_year => 1973, :genre => "hiphop", :artist => "Johnny"})
      album.save()
      expect(album.release_year).to(eq(1973))
    end
  end

  describe('#add_properties') do
    it("Add a genre to an album") do
      album = Album.new({:name => "Giant Steps", :id => nil, :release_year => 1973, :genre => "hiphop", :artist => "Johnny"})
      album.save()
      expect(album.genre).to(eq("hiphop"))
    end
  end


  describe('#sort') do
    it("Sort list of albums by name") do
      album = Album.new({:name => "Giant Steps", :id => nil, :release_year => 1973, :genre => "hiphop", :artist => "Johnny"})
        album.save()
        album2 = Album.new({ :name => "Blue", :id => nil, :release_year => 1990, :genre => "hiphop", :artist => "Prince"})
        album2.save()
        album3 = Album.new({ :name => "Yellow", :id => nil, :release_year => 1987, :genre => "Trance", :artist => "COlors"})
        album3.save()
      expect(Album.sort).to(eq([album2, album, album3]))
    end
  end

  describe('.search') do
    it("search album on list of albums") do
      album = Album.new({:name => "Giant Steps", :id => nil, :release_year => 1990, :genre => "hiphop", :artist => "Johnny"})
      album.save()
      album2 = Album.new({ :name => "Blue", :id => nil, :release_year => 1990, :genre => "hiphop", :artist => "Prince"})
      album2.save()
      expect(Album.search("Blue")).to(eq([album2]))
    end
  end

  describe('#songs') do                 #returns songs from an album
    it("returns an album's songs") do
      @album = Album.new({:name => "Giant Steps", :id => nil, :release_year => 1990, :genre => "hiphop", :artist => "Johnny"})
      @album.save()
      song = Song.new({:name => "Naima", :album_id =>@album.id, :id => nil})
      song.save()
      song2 = Song.new({:name => "Giant Steps", :album_id =>@album.id, :id => nil})
      song2.save()
      expect(@album.songs).to(eq([song, song2]))
    end
  end


end
