require File.dirname(__FILE__) + '/../../../spec_helper'

describe "Osfi::EntitiesConverter" do

  before(:each) do
    @converter = Osfi::IndividualsConverter.new()
    @record = [
      "29.03",
      "Abd Al-Baqi",
      "Nashwan	Abd Al-Razzaq", "", "", "",
			"Mosul, Iraq", "",
      "1961", "", "",
      "Iraqi", "", "",
			"Al-Qaida senior official. In custody of the United States of America, as of July 2007.",
      "UNSC (October 6, 2001); UNSC (May 14, 2007); UNSC (July 27, 2007)"
    ]
  end

  describe "make_entity" do

    before(:each) do
      @entities = @converter.convert_record(@record).entities
    end

    it "should return an array of entities (hashes)" do
      @entities[0].should be_instance_of(Hash)
    end

    it "should set last_name" do
      @entities[0][:last_name].should == @record[1]
    end


  end

  describe "make_name" do
    before(:each) do
      @names = @converter.convert_record(@record).names
    end

    it "should return an array of names (hashes)" do
      @names[0].should be_instance_of(Hash)
    end

  end
end
