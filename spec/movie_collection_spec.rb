require "movie_collection"

describe MovieCollection do
  
  before do
      @collection = MovieCollection.new('movies.txt')
  end
  
  describe ".sort_by" do
    
    context "wrong param" do
      it "returns error" do
        expect(@collection.sort_by(:soundtrack)).to raise_error("Wrong param!")
      end
    end
    
  end
  
  
end