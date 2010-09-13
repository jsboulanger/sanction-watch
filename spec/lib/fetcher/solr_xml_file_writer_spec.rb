require File.dirname(__FILE__) + '/../../spec_helper'

describe "SolrXmlFileWriter", "#write" do
  before do
    @file = DummyFile.new
    @converter = mock('Converter', :entities => [{ :last_name => "Ganoush", :first_name => "Baba", :type => "individual", :pob => ["Paris", "Dakar"] }],
                        :names => [{ :full_name => "Baba Ganoush" }])
    @writer = SolrXmlFileWriter.new(@converter)
    @writer.write(@file)
  end

  it "should create an <add> for each entity" do
    @file.content.should have_tag('add', 1)
  end

  it "should create a <doc> for each entity" do
    @file.content.should have_tag('add/doc', 2)
  end

  it "should create a <field> for each key of an entity" do
    @file.content.should have_tag('add/doc/field', 6)
  end

  it "should set field name attribute to key value" do
    REXML::Document.new(@file.content).elements.
      to_a('add/doc/field').map {|e| e.attributes['name']}.sort.
      should == ['first_name', 'full_name', 'last_name', 'pob', 'pob', 'type']
  end
  
  class DummyFile
    attr_reader :content
    def write(str)
      @content = str
    end
  end
end
