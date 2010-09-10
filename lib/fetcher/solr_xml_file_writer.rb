require 'builder'

# Write the result of a converter to Solr XML format into a file.
class SolrXmlFileWriter
  
  def initialize(converter)
    @converter = converter
  end


  def write(file)
    xml = Builder::XmlMarkup.new(:indent => 2)
    xml.add do |add| # <add>
      (@converter.entities + @converter.names).each do |element|

        add.doc do |doc| # <doc>
          element.each do |key, value|
            case value
            when Array
              value.each do |v|
                doc.field(v, :name => key) # <field name="{key}">v</field>
              end
            else
              doc.field(value, :name => key) # <field name="{key}">value</field>
            end
          end
        end # </doc>
      end
    end # </add>
    file.write(xml.target!)

  end
end


