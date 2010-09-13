require File.dirname(__FILE__) + '/../spec_helper'

describe "Helpers" do
  before do
    @search = mock('Search', :total_hits => 25)
    @@request = mock('Request', :query_string => 'q=keyword&page=1')

    class MockApp
      include Helpers

      def request
        @@request
      end
    end
    @app = MockApp.new
  end

  describe "#pagination_links" do
    describe "current page is first page" do
      # Those tests could be a lot more maintainable, but for now
      # it'll do the trick.
      
      it "should have page 1 with class 'current_page'" do
        @app.pagination_links(@search, 1).should =~ /<span class="page current_page">1<\/span>/
      end

      it "should have links for page 2 and 3" do
        content = @app.pagination_links(@search, 1)
        content.should =~ /<a class="page" href="\?q=keyword&page=2">2<\/a>/
        content.should =~ /<a class="page" href="\?q=keyword&page=3">3<\/a>/
      end
    end
  end

  describe "#results_range" do
    it "should return result range for page 1" do
      @app.results_range(@search, 1).should == "1-10"
    end

    it "should return result range for last page" do
      @app.results_range(@search, 3).should == "21-25"
    end
  end
end
