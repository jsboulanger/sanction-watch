require File.dirname(__FILE__) + '/spec_helper'

describe "Sanction Watch" do
  include Rack::Test::Methods

  def app
    @app ||= Sinatra::Application
  end

  before(:each) do
    @q = "keyword"
    @search_mock = search_mock
    SearchEngine.stub!(:search).and_return @search_mock
    SearchEngine.stub!(:suggest).and_return @search_mock
    SearchEngine.stub!(:get).and_return({})
  end

  describe 'get /' do
    

    it "should respond to /" do
      get '/'
      last_response.should be_ok
    end
    
    it "should not search if query is blank" do
      SearchEngine.should_not_receive(:search)
      get '/'
    end
    
    it "should default to 1 if page is not specicified" do
      SearchEngine.should_receive(:search).with(anything, :page => 1).and_return search_mock
      get "/", :q => @q
    end
    
    it "should default to 1 if page is not an integer" do
      SearchEngine.should_receive(:search).with(anything, :page => 1).and_return search_mock
      get "/", :q => @q, :page => "asdfasdf"
    end
    
    it "should time query" do
      # TODO
    end
    
    it "should search for query" do
      SearchEngine.should_receive(:search).with(@q, anything).and_return search_mock
      get "/", :q => @q
    end
    
    it "should limit search to current page" do
      SearchEngine.should_receive(:search).with(anything, :page => 2).and_return search_mock
      get "/", :q => @q, :page => 2
    end
    
    it "should find suggestions if there is not results" do
      SearchEngine.should_receive(:suggest)
      get "/", :q => @q
    end        
    
  end # get /

  describe 'get /suggest' do

    it "should respond to /" do
      get '/suggest'
      last_response.should be_ok
    end

    it "should not search if query is blank" do
      SearchEngine.should_not_receive(:suggest)
      get "/suggest"
    end

    it "should suggest with query" do
      SearchEngine.should_receive(:suggest).with(@q)
      get "/suggest", :q => @q
    end

    it "should return a \n separated list of full_name" do
      @search_mock.stub!(:hits).and_return [
        {'full_name' => "JS Boulanger"},
        {'full_name' => "Peter Jackson"}
      ]
      get "/suggest", :q => @q
      last_response.body.should == "JS Boulanger\nPeter Jackson"
    end

  end # get /suggest

  describe "get /details" do

    it "should respond to /" do
      get '/details', :uid => "id"
      last_response.should be_ok
    end

    it "should get with uid" do
      SearchEngine.should_receive(:get).with("ID").and_return({})
      get "/details", :uid => "ID"
    end

    it "should raise NotFound if record is not found" do
      SearchEngine.stub!(:get).and_return nil
      get "/details"
      last_response.should be_not_found
    end

  end # /suggest
end # Sanction Watch
