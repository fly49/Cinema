require "movie_collection"
require "rspec/its"

describe MovieCollection do
  subject { MovieCollection.new("movies.txt") }

  describe "it has been instantiated" do
    its(:all) { is_expected.to all be_a Movie }
    its(:genres) { is_expected.to be_an Array }
    it { expect(subject.all.count).to eq 250 }
  end

  describe ".sort_by" do
    context "Wrong parameter" do
      it { expect{subject.sort_by(:soundtrack)}.to raise_error(RuntimeError,"Wrong param!") }
    end
    context "Date sorting" do
      it {  expect(subject.sort_by(:date).first(3).map(&:to_s)).to eq(["The Kid (1921-02-06; Comedy,Drama,Family) - 68 min",
                                                                       "The Gold Rush (1925; Adventure,Comedy,Drama) - 95 min",
                                                                       "The General (1927-02-24; Action,Adventure,Comedy) - 67 min"])}
    end
    context "Duration sorting" do
      it {  expect(subject.sort_by(:duration).first(3).map(&:to_s)).to eq(["The General (1927-02-24; Action,Adventure,Comedy) - 67 min",
                                                                           "The Kid (1921-02-06; Comedy,Drama,Family) - 68 min",
                                                                           "Before Sunset (2004-07-30; Drama,Romance) - 80 min"])}
    end
  end

  describe ".stats" do
    context "Wrong parameter" do
      it { expect{subject.stats(:soundtrack)}.to raise_error(RuntimeError,"Wrong param!") }
    end
    context "Director stats" do
      it { expect(subject.stats(:director)).to include({ "Stanley Kubrick"=>8, "Alfred Hitchcock"=>8, "Martin Scorsese"=>7, "Christopher Nolan"=>7, "Hayao Miyazaki"=>6 }) }
    end
    context "Month stats" do
      it { expect(subject.stats(:month)).to include({ "December"=>30, "June"=>24, "February"=>24 }) }
    end
    context "Year stats" do
      it { expect(subject.stats(:year)).to include({ 1995=>10, 2014=>8, 2010=>7, 2003=>7, 1957=>7 }) }
    end
    context "Country stats" do
      it { expect(subject.stats(:country)).to include({ "USA"=>166, "UK"=>19, "Japan"=>15, "Italy"=>11, "France"=>10 }) }
    end
    context "Genre stats" do
      it { expect(subject.stats(:genre)).to include({ "Drama"=>166, "Crime"=>53, "Adventure"=>51, "Thriller"=>44, "Comedy"=>39 }) }
    end
    context "Cast stats" do
      it { expect(subject.stats(:cast)).to include({ "Robert De Niro"=>8, "Harrison Ford"=>6, "Clint Eastwood"=>6 }) }
    end
  end

  describe ".filter" do
    context "Wrong parameter" do
      it { expect{subject.filter(gnre: "Drama")}.to raise_error(RuntimeError,"Wrong param!") }
    end
    context "Year filtering" do
      it { expect(subject.filter(year: 2001..2009)).to all(have_attributes(:year => 2001..2009)) }
    end
    context "Genre filtering" do
      it { expect(subject.filter(genre: "Comedy")).to all(have_attributes(:genre => include("Comedy"))) }
    end
    context "Cast filtering" do
      it { expect(subject.filter(cast: /Schwarz(.*)/)).to all(have_attributes(:cast => include("Arnold Schwarzenegger"))) }
    end
    context "Combined filtering" do
      it { expect(subject.filter(genre: "Animation", year: 2000..2005)).to all(have_attributes(:genre => include("Animation"), :year => 2001..2005)) }
    end
  end
end