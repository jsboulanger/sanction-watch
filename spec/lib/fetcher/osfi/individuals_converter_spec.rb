require File.dirname(__FILE__) + '/../../../spec_helper'

describe "Osfi::EntitiesConverter" do
  before do
    @converter = Osfi::IndividualsConverter.new
    @record = [
               "29.03", "Abd Al-Baqi", "Nashwan	Abd Al-Razzaq",
               "", "", "",
               "Mosul, Iraq", "", "1961",
               "", "", "",
               "Iraqi", "", "",
               "Al-Qaida senior official. In custody of the United States of America, as of July 2007.",
               "UNSC (October 6, 2001); UNSC (May 14, 2007); UNSC (July 27, 2007)"
    ]
  end

  describe "entities for a typical record" do
    before do
      @entity = @converter.convert_record(@record).entities.first
    end

    it "should return an entity as a Hash" do
      @entity.should be_instance_of(Hash)
    end

    it "should set last name" do
      @entity[:last_name].should == @record[1]
    end

    it "should leave blank fields blank" do
      @entity[:place_of_birth_alt].should be_blank
    end
  end

  it "should return an entity as a Hash for an empty record" do
    @converter.convert_record([''] * 17).entities.first.should be_instance_of(Hash)
  end

  it "should return a name as a hash for a typical record" do
    name = @converter.convert_record(@record).names.first
    name.should be_instance_of(Hash)
  end
end
