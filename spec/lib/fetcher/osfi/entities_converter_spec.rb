require File.dirname(__FILE__) + '/../../../spec_helper'

describe "Osfi::EntitiesConverter" do
  before do
    @converter = Osfi::EntitiesConverter.new
    @record = ["123", "Groupe Abou Sayyaf", "Headquarters - G.T. Road (probably Grand Trunk Road)", "CC (February 12, 2003)"]
  end

  describe "an entity for a typical record" do
    before do
      @entity = @converter.convert_record(@record).entities.first
    end

    it "should be a hash" do
      @entity.should be_instance_of(Hash)
    end

    it "should have 'entity' type" do
      @entity[:type].should == 'entity'
    end

    it "should have a guid as OSFIE{record id}" do
      @entity[:guid].should == "OSFIE#{@record[0]}"
    end

    it "should have the record's fullname" do
      @entity[:full_name].should == @record[1]
    end

    it "should have other information from record" do
      @entity[:other_information].should == @record[2]
    end
  end

  describe "a name for a typical record" do
    before do
      @name = @converter.convert_record(@record).names.first
    end

    it "should have 'name' type" do
      @name[:type].should == "name"
    end

    it "should have a guid as NAME-{record name}" do
      @name[:guid].should == "NAME-#{@record[1]}"
    end

    it "should set full_name" do
      @name[:full_name].should == @record[1]
    end
  end
end
