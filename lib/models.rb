require 'dm-core'
require 'dm-validations'
require 'yaml'

config = ConfigLoader.load('database')
DataMapper::setup(:default, "#{config[:adapter]}://#{config[:username]}:#{config[:password]}@#{config[:host]}/#{config[:database]}")

class Lead
    include DataMapper::Resource
    property :id, Serial
    property :name, String
    validates_present :name
    property :organization, String, :nullable => false
    property :email, String, :nullable => false
    property :phone, String, :nullable => false
    property :comment, Text
    property :created_at, DateTime
end

# automatically create the post table
Lead.auto_upgrade!
