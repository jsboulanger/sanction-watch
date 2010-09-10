require 'solr'

class SearchEngine
  
  @@config = {
    :solr_url => "",
    :results_per_page => 10
  }

  def self.configure
    yield(@@config)
  end

  def self.connection
    @connection ||= Solr::Connection.new(@@config[:solr_url])
  end
  
  def self.search(query, options = {})
    options[:page] ||= 1
    options[:per_page] ||= @@config[:results_per_page]

    query_txt = build_search_query(sanitize(query))
    
    connection.query(query_txt, 
      :start => (options[:page] - 1) * options[:per_page],
      :rows => options[:per_page])
  end
  
  def self.get(id)
    search = connection.query("guid:#{sanitize(id)}")
    if search.total_hits > 0
      search.hits.first
    else
      nil
    end    
  end
  
  def self.suggest(query)    
    connection.query(build_suggest_query(sanitize(query)), :start => 0, :rows => 10)
  end

  private

  def self.sanitize(query)
    # TODO: Find out if solr can be vulnerable to someking of injection
    query
  end


  def self.build_search_query(query)
    tokens = query.split(/\s/).map{|s| s.strip }

    "(type:individual OR type:entity)" +
    " AND ((full_name:(#{tokens.map {|s| "+#{s}"}.join(' ')}))" +
    " OR (full_name:(#{tokens.map {|s| "+#{s}~0.7"}.join(' ')}))" +
    " OR (aka:(#{tokens.map {|s| "+#{s}"}.join(' ')}))" +
    " OR (aka:(#{tokens.map {|s| "+#{s}~0.7"}.join(' ')})))"
  end

  def self.build_suggest_query(query)
    tokens = query.split(/\s/).map{|s| s.strip }

    "type:name" +
    " AND ((full_name:(#{tokens.map {|s| "+#{s}*"}.join(' ')}))" +
    " OR (full_name:(#{tokens.map {|s| "+#{s}~0.7"}.join(' ')}))" +
    " OR (full_name_soundex:(#{tokens.map {|s| "+#{s}"}.join(' ')}))" +
    " OR (aka:(#{tokens.map {|s| "+#{s}*"}.join(' ')}))" +
    " OR (aka:(#{tokens.map {|s| "+#{s}~0.7"}.join(' ')}))" +
    " OR (aka_soundex:(#{tokens.map {|s| "+#{s}"}.join(' ')})))"
  end
  
end