require "movie_collection"

describe Movie do
  before do
    @movie = MovieCollection.new("movies.txt").all.first
  end

  describe ".has_genre?" do
    context "movie has/hasn't it" do
      it { expect(@movie.has_genre?("Action")).to be(true).or be(false) }
    end
    context "incorrect genre" do
      it { expect{@movie.has_genre?("Actn")}.to raise_error(RuntimeError,"Incorrect genre!") }
    end
  end
end

describe MovieCollection do
  before do
    @collection = MovieCollection.new("movies.txt")
  end

  describe ".sort_by" do
    context "Wrong parameter" do
      it { expect{@collection.sort_by(:soundtrack)}.to raise_error(RuntimeError,"Wrong param!") }
    end
    context "Date sorting" do
      it {  expect(@collection.sort_by(:date).map(&:to_s).first(3)).to eq(["The Kid (1921-02-06; Comedy,Drama,Family) - 68 min",
                                                                           "The Gold Rush (1925; Adventure,Comedy,Drama) - 95 min",
                                                                           "The General (1927-02-24; Action,Adventure,Comedy) - 67 min"])}
    end
    context "Duration sorting" do
      it {  expect(@collection.sort_by(:duration).map(&:to_s).first(3)).to eq(["The General (1927-02-24; Action,Adventure,Comedy) - 67 min",
                                                                               "The Kid (1921-02-06; Comedy,Drama,Family) - 68 min",
                                                                               "Before Sunset (2004-07-30; Drama,Romance) - 80 min"])}
    end
  end

  describe ".stats" do
    context "Wrong parameter" do
      it { expect{@collection.stats(:soundtrack)}.to raise_error(RuntimeError,"Wrong param!") }
    end
    context "Director stats" do
      it { expect(@collection.stats(:director).to_a[0,5].to_h).to eq({"Stanley Kubrick"=>8, "Alfred Hitchcock"=>8, "Martin Scorsese"=>7, "Christopher Nolan"=>7, "Hayao Miyazaki"=>6}) }
    end
    context "Month stats" do
      it { expect(@collection.stats(:month).to_a[0,3].to_h).to eq({"December"=>30, "June"=>24, "February"=>24}) }
    end
    context "Year stats" do
      it { expect(@collection.stats(:year).to_a[0,5].to_h).to eq({1995=>10, 2014=>8, 2010=>7, 2003=>7, 1957=>7}) }
    end
    context "Country stats" do
      it { expect(@collection.stats(:country).to_a[0,5].to_h).to eq({"USA"=>166, "UK"=>19, "Japan"=>15, "Italy"=>11, "France"=>10}) }
    end
    context "Genre stats" do
      it { expect(@collection.stats(:genre).to_a[0,5].to_h).to eq({"Drama"=>166, "Crime"=>53, "Adventure"=>51, "Thriller"=>44, "Comedy"=>39}) }
    end
    context "Cast stats" do
      it { expect(@collection.stats(:cast).to_a[0,3].to_h).to eq({"Robert De Niro"=>8, "Harrison Ford"=>6, "Clint Eastwood"=>6}) }
    end
  end

  describe ".filter" do
    context "Wrong parameter" do
      it { expect{@collection.filter(gnre: "Drama")}.to raise_error(RuntimeError,"Wrong param!") }
    end
    context "Year filtering" do
      it { expect(@collection.filter(year: 2001..2009).map(&:to_s).first(3)).to eq(["The Dark Knight (2008-07-18; Action,Crime,Drama) - 152 min",
                                                                                    "The Lord of the Rings: The Return of the King (2003-12-17; Adventure,Fantasy) - 201 min",
                                                                                    "The Lord of the Rings: The Fellowship of the Ring (2001-12-19; Adventure,Fantasy) - 178 min"]) }
    end
    context "Genre filtering" do
      it { expect(@collection.filter(genre: "Comedy").map(&:to_s).first(3)).to eq(["Life Is Beautiful (1999-02-12; Comedy,Drama,Romance) - 116 min",
                                                                                   "City Lights (1931-03-07; Comedy,Drama,Romance) - 87 min",
                                                                                   "The Intouchables (2012-04-26; Biography,Comedy,Drama) - 112 min"]) }
    end
    context "Cast filtering" do
      it { expect(@collection.filter(cast: /Schwarz(.*)/).map(&:to_s)).to eq(["Terminator 2: Judgment Day (1991-07-03; Action,Sci-Fi) - 137 min",
                                                                              "The Terminator (1984-10-26; Action,Sci-Fi) - 107 min"]) }
    end
    context "Combined filtering" do
      it { expect(@collection.filter(genre: "Animation", year: 2000..2005).map(&:to_s)).to eq(["Spirited Away (2003-03-28; Animation,Adventure,Family) - 125 min",
                                                                                               "Howl's Moving Castle (2005-06-17; Animation,Adventure,Family) - 119 min",
                                                                                               "Finding Nemo (2003-05-30; Animation,Adventure,Comedy) - 100 min",
                                                                                               "Monsters, Inc. (2001-11-02; Animation,Adventure,Comedy) - 92 min"]) }
    end
  end
end