require 'pony'

module Mailers

  @@smtp_config = ConfigLoader.load('smtp')


  def deliver_lead(lead)
    deliver(:to => 'jsboulanger@gmail.com', :subject => "New Lead",
      :body => erb(:lead_email, :layout => false))
  end

  def deliver(params)
    params = {
      :from => "sysadmin@codapay.com",
      :via => :smtp,
      :smtp => @@smtp_config
    }.merge(params)

    Pony.mail(params)
  end




end