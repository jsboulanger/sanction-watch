module Osfi  

  # Base converter for a OSFI file. This is an abstract class and should be extended.
  class BaseConverter   
    attr_reader :names

    def initialize
      @names = []
      @entities_store = {}
    end

    def convert_record(record)
      id = extract_id(record)

      unless @entities_store.has_key?(id)
        @entities_store[id] = make_entity(record)
      else
        @entities_store[id][:aka] ||= []
        @entities_store[id][:aka] << make_aka(record)
      end
      @names << make_name(record)
      self
    end

    def entities
      @entities_store.values
    end

    protected

    def extract_id(record)
      record.first.split('.').first # Here we assume ID is the first field record. If not we must override into subclass.
    end

    def extract_other_field(name, other)
      match_fieldname = Regexp.new("^\s*#{name}:", Regexp::IGNORECASE)
      elements = other.split(';')
      value = elements.select {|e| e =~ match_fieldname}.map{|e| e.gsub(match_fieldname, '').strip }.first # If there is more than one match it ignores the others
      other = elements.reject{|e| e =~ match_fieldname}.join(';') unless value.nil?
      [value, other]
    end

    def make_program(basis)
      basis.split(';').map {|p| p.strip}
    end


  end # BaseConverter
end # Osfi
