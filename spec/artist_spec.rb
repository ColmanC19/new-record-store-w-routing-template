require 'rspec'
require 'album'
require 'song'
require 'spec_helper'
require 'artist'

describe '#Artist' do

  before(:each) do
    Artist.clear()
  end

  describe('#==') do
    it("is the same artist if it has the same attributes as another artist") do
      artist = Artist.new({:name => "John Coltrane", :id => nil})
      artist2 = Artist.new({:name => "John Coltrane", :id => nil})
      expect(artist).to(eq(artist2))
    end
  end

  describe('#save') do
    it("saves an artist") do
      artist = Artist.new({:name => "John Coltrane", :id => nil})
      artist.save()
      artist2 = Artist.new({:name => "Billie Holiday", :id => nil})
      artist2.save()
      expect(Artist.all).to(eq([artist, artist2]))
    end
  end

  describe('#delete') do
    it("deletes an artist by id") do
      artist = Artist.new({:name => "John Coltrane", :id => nil})
      artist.save()
      artist2 = Artist.new({:name => "Billie Holiday", :id => nil})
      artist2.save()
      artist.delete()
      expect(Artist.all).to(eq([artist2]))
    end
  end

  describe('.all') do
    it("returns an empty array when there are no artists") do
      expect(Artist.all).to(eq([]))
    end
  end

  describe('.clear') do
    it("clears all artists") do
      artist = Artist.new({:name => "John Coltrane", :id => nil})
      artist.save()
      artist2 = Artist.new({:name => "Billie Holiday", :id => nil})
      artist2.save()
      Artist.clear()
      expect(Artist.all).to(eq([]))
    end
  end

  describe('.find') do
    it("finds an artist by id") do
      artist = Artist.new({:name => "John Coltrane", :id => nil})
      artist.save()
      artist2 = Artist.new({:name => "Billie Holiday", :id => nil})
      artist2.save()
      expect(Artist.find(artist.id)).to(eq(artist))
    end
  end

  describe('#sort') do
    it("Sort list of artists by name") do
      artist = Artist.new({:name => "John Coltrane", :id => nil})
      artist.save()
      artist2 = Artist.new({:name => "Billie Holiday", :id => nil})
      artist2.save()
      artist3 = Artist.new({:name => "Zoe Appleseed", :id => nil})
      artist3.save()
      expect(Artist.sort).to(eq([artist2, artist, artist3]))
    end
  end


describe('#update') do
  it("adds an album to an artist") do
    artist = Artist.new({:name => "John Coltrane", :id => nil})
    artist.save()
    album = Album.new({:name => "A Love Supreme", :id => nil, :release_year => 1990, :genre => "hiphop", :artist => "Prince"})
    album.save()
    artist.update({:album_name => "A Love Supreme"})
    expect(artist.albums).to(eq([album]))
  end
end













end
