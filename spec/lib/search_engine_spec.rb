require File.dirname(__FILE__) + '/../spec_helper'

describe "SearchEngine" do
  before(:each) do
    @search = stub('search', :hits => [], :total_hits => 0)
    @connection = stub('connection', :query => @search)
    SearchEngine.stub!(:connection).and_return @connection
  end

  describe "search" do    

    it "should call query on connection with keyword" do
      @connection.should_receive(:query).with(/the_test_keyword/, anything)
      SearchEngine.search('the_test_keyword')
    end

    it "should default to start to record 0" do
      @connection.should_receive(:query).with(anything, hash_including(:start => 0))
      SearchEngine.search('test')
    end

    it "should default to 10 results per page" do
      @connection.should_receive(:query).with(anything, hash_including(:rows => 10))
      SearchEngine.search('test')
    end

    it "should override default page through parameters" do
      @connection.should_receive(:query).with(anything, hash_including(:start => 20))
      SearchEngine.search('test', :page => 2, :per_page => 20)
    end

    it "should override default results per page through parameters" do
      @connection.should_receive(:query).with(anything, hash_including(:rows => 20))
      SearchEngine.search('test', :page => 2, :per_page => 20)
    end

    describe "query" do
      # TODO: Once we are done tuning the query.
    end

  end

  describe "get" do
    it "should call get with guid:ID query" do
      @connection.should_receive(:query).with("guid:OSFII123").and_return @search
      SearchEngine.get("OSFII123")
    end

    it "should return nil if no hits" do
      @search.stub!(:total_hits).and_return 0
      SearchEngine.get("OSFII123").should be_nil
    end
  end

  describe "suggest" do
    it "should call query on connection with keyword" do
      @connection.should_receive(:query).with(/the_test_keyword/, anything)
      SearchEngine.suggest('the_test_keyword')
    end

    it "should ask for 10 first records" do
      @connection.should_receive(:query).with(anything, hash_including(:start => 0, :rows => 10))
      SearchEngine.search('test')
    end

  end

end