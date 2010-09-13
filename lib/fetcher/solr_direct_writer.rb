# Stub for a writer that will write directly to solr instead of going
# through an XML file.
class SolrDirectWriter
  def initialize(converter)
    @converter = converter
  end

  def write(connection)
    # To implement
  end
end
