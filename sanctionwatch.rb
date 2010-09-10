require 'rubygems'
require 'sinatra'
require 'erb'
require 'lib/util/config_loader'
require 'lib/core_ext/blank'


#
# Required gems
#  sinatra
#  pony
#  dm-core
#  dm-validations
#  solr-ruby
#  do_mysql
#  builder (for fetcher only)


# Load Application
require 'lib/search_engine'
require 'lib/helpers'
require 'lib/models'
require 'lib/mailers'


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

  include Mailers # Application Mailers
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
  
  erb :index
end

get '/suggest' do
  unless params[:q].blank?
    SearchEngine.suggest(params[:q]).hits.map {|doc| doc["full_name"]}.join("\n")
  end
end


get '/details' do
  @doc = SearchEngine.get(params[:uid].to_s.strip)
  raise Sinatra::NotFound if @doc.nil?
  erb :details
end


get '/solutions' do
  @lead = Lead.new
  erb :solutions
end

get '/contact' do
  @lead = Lead.new
  erb :contact
end

get '/thankyou' do
  erb :thankyou
end

post '/send' do
  @lead = Lead.new(params[:lead])
  @lead.created_at = Time.now
  if @lead.save
    deliver_lead(@lead)
    redirect '/thankyou'
  else
    @error_message = "You need to specify a valid <strong>name</strong>, <strong>organization</strong>, <strong>email</strong>, and <strong>phone</strong>."
    erb :contact
  end
end


