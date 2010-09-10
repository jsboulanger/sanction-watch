# The fetcher are responsible to fetch lists of terrorist from external sources and
# convert them into our Solr XML schema to index them.

require 'lib/fetcher/osfi/file_reader'
require 'lib/fetcher/osfi/base_converter'
require 'lib/fetcher/osfi/entities_converter'
require 'lib/fetcher/osfi/individuals_converter'
require 'lib/fetcher/osfi/iran_entities_converter'
require 'lib/fetcher/osfi/iran_individuals_converter'
require 'lib/fetcher/osfi/zimbabwe_entities_converter'
require 'lib/fetcher/osfi/zimbabwe_individuals_converter'
require 'lib/fetcher/osfi/burma_entities_converter'
require 'lib/fetcher/osfi/burma_individuals_converter'

require 'lib/fetcher/dfat/file_reader'
require 'lib/fetcher/dfat/base_converter'
require 'lib/fetcher/dfat/committee_converter'

require 'lib/fetcher/solr_xml_file_writer'