require File.dirname(__FILE__) + '/../spec_helper'

describe "Mailers" do

  before(:each) do
    Pony.stub!(:mail)
    @app = mock('Dummy App', :erb => "body").extend(Mailers)
  end

  describe "deliver" do

    it "should call pony mail with parameters" do
      Pony.should_receive(:mail).with(hash_including(:to => 'js@codapay.com'))
      @app.deliver(:to => 'js@codapay.com')
    end

    it "should set default parameters" do
      Pony.should_receive(:mail).with(hash_including(:via => :smtp))
      @app.deliver({})
    end

    it "should override default parameters" do
      Pony.should_receive(:mail).with(hash_including(:via => :garbage))
      @app.deliver(:via => :garbage)
    end

  end

  describe "deliver_lead" do

    it "should deliver_lead" do
      @app.should_receive(:deliver).with(hash_including(:to => anything, 
          :subject => anything, :body => anything))
      @app.deliver_lead(Lead.new)
    end

  end


end