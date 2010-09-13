require 'rubygems'
require 'sinatra'
require 'erb'
require 'lib/util/config_loader'
require 'lib/core_ext/blank'


#
# Required gems
#  sinatra
#  solr-ruby
#  builder (for fetcher only)


# Load Application
require 'lib/search_engine'
require 'lib/helpers'


# Configure Application
RESULTS_PER_PAGE = 10 unless defined?(RESULTS_PER_PAGE)

configure :development do
  SearchEngine.configure do |config|
    config[:solr_url] = 'http://localhost:8983/solr'
    config[:results_per_page] = RESULTS_PER_PAGE
  end
end

configure :production do
  SearchEngine.configure do |config|
    config[:solr_url] = 'http://localhost:8080/solr-sw'
    config[:results_per_page] = RESULTS_PER_PAGE
  end
end


# Define Helpers
helpers do
  include Rack::Utils
  alias_method :h, :escape_html

  include Helpers # Application View Helpers
end


# Request Handlers
get '/' do
  
  unless params[:q].blank?
    @current_page = params[:page].to_i || 1
    @current_page = 1 if @current_page < 1
    
    start_time = Time.now
    @search = SearchEngine.search(params[:q], :page => @current_page)
    @results = @search.hits
    
    if @results.size < 1
      @suggestions = SearchEngine.suggest(params[:q]).hits
    end
    
    @query_time = Time.now - start_time
  end
  
  erb :"index.html"
end

get '/suggest' do
  unless params[:q].blank?
    SearchEngine.suggest(params[:q]).hits.map {|doc| doc["full_name"]}.join("\n")
  end
end

get '/details' do
  @doc = SearchEngine.get(params[:uid].to_s.strip)
  raise Sinatra::NotFound if @doc.nil?
  erb :"details.html"
end
