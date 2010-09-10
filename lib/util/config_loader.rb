module ConfigLoader

  def self.load(name)
    config = YAML::load_file("#{File.dirname(__FILE__)}/../../config/#{name}.yml")[ENV['RACK_ENV'] || "development"]
    config.inject({}) do |options, (key, value)|
      options[(key.to_sym rescue key) || key] = value
      options
    end
  end


end