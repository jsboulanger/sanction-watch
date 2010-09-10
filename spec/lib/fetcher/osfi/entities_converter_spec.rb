require File.dirname(__FILE__) + '/../../../spec_helper'


describe "Osfi::EntitiesConverter" do

  before(:each) do
    @converter = Osfi::EntitiesConverter.new()
    @record = ["123", "Groupe Abou Sayyaf", "Headquarters - G.T. Road (probably Grand Trunk Road)", "CC (February 12, 2003)"]
  end

  describe "make_entity" do

    before(:each) do
      @e = @converter.convert_record(@record).entities.first
    end

    it "should return an entity as a hash" do
      @e.should be_instance_of(Hash)
    end

    it "should set type" do
      @e[:type].should == 'entity'
    end

    it "should set guid" do
      @e[:guid].should == "OSFIE#{@record[0]}"
    end

    it "should set fullname" do
      @e[:full_name].should == @record[1]
    end

    it "should set other information" do
      @e[:other_information].should == @record[2]
    end

  end # make_entity

  describe "make_name" do
    before(:each) do
      @n = @converter.convert_record(@record).names.first
    end

    it "should set type" do
      @n[:type].should == "name"
    end

    it "should set guid" do
      @n[:guid].should == "NAME-#{@record[1]}"
    end

    it "should set full_name" do
      @n[:full_name].should == @record[1]
    end
    
  end # make_name

end # EntitiesConverter
