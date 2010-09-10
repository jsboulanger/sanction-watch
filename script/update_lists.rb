require 'rubygems'
require 'open-uri'
require 'lib/fetcher'

$KCODE = 'UTF8'

JAVA_PATH = 'java'
POST_JAR_PATH = '/opt/solr/sw/bin'
SOLR_URL = 'http://localhost:8080/solr-sw/update'


# Update OSFI

def update_osfi_list(converter, url, file_name)
  reader = Osfi::FileReader.new(converter)
  reader.parse(open(url))

  File.open(file_name, 'w') do |file|
    SolrXmlFileWriter.new(converter).write(file)
  end
  post(file_name)
end

def update_dfat_committee(committee)
  converter = Dfat::CommitteeConverter.new(committee)
  reader = Dfat::FileReader.new(converter)
  file_name = "#{File.dirname(__FILE__)}/../data/dfat-#{committee}.xml"
  reader.parse(open("http://www.dfat.gov.au/icat/regulation8_consolidated.xls"))
  File.open(file_name, 'w') do |file|
    SolrXmlFileWriter.new(converter).write(file)
  end
  post(file_name)
end

def post(file_name)
  `#{JAVA_PATH} -Durl=#{SOLR_URL} -jar #{POST_JAR_PATH}/post.jar #{file_name}`
end

path = "#{File.dirname(__FILE__)}/../data"

update_osfi_list(Osfi::EntitiesConverter.new, "http://www.osfi-bsif.gc.ca/app/DocRepository/1/eng/issues/terrorism/entstld_e.txt", "#{path}/osfi-ent.xml")
update_osfi_list(Osfi::IndividualsConverter.new, "http://www.osfi-bsif.gc.ca/app/DocRepository/1/eng/issues/terrorism/indstld_e.txt", "#{path}/osfi-ind.xml")

update_osfi_list(Osfi::IranEntitiesConverter.new, "http://www.osfi-bsif.gc.ca/app/DocRepository/1/eng/issues/sanctions/un_entstld_e.txt", "#{path}/osfi-iran-ent.xml")
update_osfi_list(Osfi::IranIndividualsConverter.new, "http://www.osfi-bsif.gc.ca/app/DocRepository/1/eng/issues/sanctions/un_indstld_e.txt", "#{path}/osfi-iran-ind.xml")

update_osfi_list(Osfi::ZimbabweEntitiesConverter.new, "http://www.international.gc.ca/sanctions/assets/office_docs/zimbabwe_entities-eng.txt", "#{path}/osfi-zimbabwe-ent.xml")
update_osfi_list(Osfi::ZimbabweIndividualsConverter.new, "http://www.international.gc.ca/sanctions/assets/office_docs/Zimbabwe_indiv-eng.txt", "#{path}/osfi-zimbabwe-ind.xml")

update_osfi_list(Osfi::BurmaEntitiesConverter.new, "http://www.international.gc.ca/sanctions/assets/office_docs/entities_dwnld_en.txt", "#{path}/osfi-burma-ent.xml")
update_osfi_list(Osfi::BurmaIndividualsConverter.new, "http://www.international.gc.ca/sanctions/assets/office_docs/indiv_dwnld_en.txt", "#{path}/osfi-burma-ind.xml")



#update_list(Dfat::CommitteeConverter.new(1718), "http://www.dfat.gov.au/icat/regulation8_consolidated.xls", "#{path}/dfat-1718.xml")

update_dfat_committee(1591) # Sudan
update_dfat_committee(1533) # DRC
update_dfat_committee(1572) # Cote d'ivoire
update_dfat_committee(1521) # Liberia
update_dfat_committee(1518) # Iraq