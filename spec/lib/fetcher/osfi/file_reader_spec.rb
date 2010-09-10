require File.dirname(__FILE__) + '/../../../spec_helper'


describe "Osfi::FileReader" do

  before(:each) do
    @file = File.new(File.dirname(__FILE__) + '/../../../fixtures/osfi-entstld_e.txt')      
  end

  describe "parse_into_array class method (parse osfi example file)" do

    before(:each) do
      @records = Osfi::FileReader.parse_into_array(@file)
    end

    it "should parse all records into an array" do
      @records.size.should == 817
    end
    
    it "should parse the first record and clean it" do
      r = @records.first
      r[0].should == "2.00"
      r[1].should == "Abu Nidal Organization (ANO)"
      r[2].should == ""
      r[3].should == "CC (February 12, 2003)" # cleaned from quotes
    end
    
  end

  describe "parse" do
    before(:each) do
      @converter = mock('Converter')
      @converter.stub!(:convert_record)
    end

    it "should call convert_record for each record" do
      @converter.should_receive(:convert_record).exactly(817).times
      Osfi::FileReader.new(@converter).parse(@file)
    end
  end

end