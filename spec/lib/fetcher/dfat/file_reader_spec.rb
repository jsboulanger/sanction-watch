require File.dirname(__FILE__) + '/../../../spec_helper'

describe "Dfat::FileReader", "for a typical dfat file" do
  before do
    @file = File.new(File.dirname(__FILE__) + '/../../../fixtures/regulation8_consolidated.xls')
  end

  describe "#parse_into_array" do
    before do
      @records = Dfat::FileReader.parse_into_array(@file)
    end

    it "should parse all records into an array" do
      @records.size.should == 3446
    end
    
    it "should parse the first record and clean it" do
      r = @records[0]
      r[0].should == 1.0
      r[1].should == "Mohammad Rabbani"
      r[2].should == "Individual"
    end    
  end

  describe "#parse" do
    before do
      @converter = mock('Converter')
      @converter.stub!(:convert_record)
    end

    it "should call convert_record for each record" do
      @converter.should_receive(:convert_record).exactly(3446).times
      Dfat::FileReader.new(@converter).parse(@file)
    end
  end
end
