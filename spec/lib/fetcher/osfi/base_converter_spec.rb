require File.dirname(__FILE__) + '/../../../spec_helper'

describe "Osfi::BaseConverter" do
  before do
    @converter = Osfi::BaseConverter.new
  end

  describe "#convert_record" do
    before do
      @converter.stub!(:make_entity => {}, :make_aka => {}, :make_name => {})
      @record = ["234"]
    end

    it "should make_entity if no record exist for this ID" do
      @converter.should_receive(:make_entity).with(@record).once
      @converter.should_not_receive(:make_aka)
      @converter.convert_record(@record)
    end

    it "should make_aka if a record exist for this ID" do
      @converter.convert_record(["234", "asdf"])
      @converter.should_receive(:make_aka).with(@record).once
      @converter.convert_record(@record)
    end

    it "should make_name for all records"
  end

  describe "#extract_other_field" do
    before do
      @info = "Passport no.: Yemeni passport number 54193; identification no.: Yemeni identity card number 216040; Address: Jamal street, Al-Dahima alley, Al-Hudaydah, Yemen; Other information: Yemen Responsible for the finances... "
    end

    it "should extract address in string" do
      address, info = @converter.send(:extract_other_field, "address", @info)
      address.should == "Jamal street, Al-Dahima alley, Al-Hudaydah, Yemen"
    end

    it "should remove the extracted field from original string" do
      address, info = @converter.send(:extract_other_field, "address", @info)
      info.should == @info.gsub("Address: Jamal street, Al-Dahima alley, Al-Hudaydah, Yemen; ", "")
    end

    it "should leave string unchanged if no field matches" do
      value, info = @converter.send(:extract_other_field, "no match", @info)
      info.should == @info
    end

    it "should return nil value if field does not exists" do
      value, info = @converter.send(:extract_other_field, "no match", "")
      value.should be_nil
    end
  end
end
