require "movie_collection"
require "rspec/its"

describe Movie do
  subject { MovieCollection.new("movies.txt").all.first }

  describe "it has been instantiated" do
    its(:link) { is_expected.to match(/imdb.com\/title(.*)/) }
    its(:title, :country, :rating, :director, :month) { are_expected.to be_a(String) }
    its(:year, :duration) { are_expected.to be_a(Integer) }
    its(:genre, :cast) { are_expected.to be_a(Array) }
  end

  describe ".has_genre?" do
    context "movie has this genre" do
      it { expect(subject.has_genre?("Drama")).to be(true) }
    end
    context "movie hasn't this genre" do
      it { expect(subject.has_genre?("Action")).to be(false) }
    end
    context "incorrect genre" do
      it { expect{subject.has_genre?("Actn")}.to raise_error(RuntimeError,"Incorrect genre!") }
    end
  end
end