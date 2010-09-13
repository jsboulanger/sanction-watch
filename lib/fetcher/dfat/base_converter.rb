module Dfat
  # Base converter for a DFAT file. This is an abstract class and should be extended.
  class BaseConverter
    attr_reader :names

    class Index
      ID = 0
      NAME = 1
      TYPE = 2
      NAME_TYPE = 3
      DOB = 4
      POB = 5
      NATIONALITY = 6
      ADDRESS = 7
      OTHER_INFORMATION = 8
      BASIS = 9
      COMMITTEE = 11
    end

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

    def extract_committee(record)
      comm = record[Index::COMMITTEE].to_s.gsub(/[^\d]/, '').to_i
      comm == 0 ? nil : comm
    end

    def extract_id(record)
      id = record.first.is_a?(String) ? record.first : record.first.to_i.to_s
      id.gsub(/[^\d]/, '')
    end

    def make_aka(record)
      make_fullname(record)
    end
    
    def make_fullname(record)
      record[Index::NAME]
    end

    def make_name(record)
      {
        :type => "name",
        :guid => "name-#{make_fullname(record)}",
        :full_name => make_fullname(record)
      }
    end

    def make_entity(record)
      id = extract_id(record)
      title, other_information = extract_other_field('title', record[Index::OTHER_INFORMATION])
      {
            :type => record[Index::TYPE].downcase,
            :guid => make_guid(id),
            :oid => id,
            :full_name => record[Index::NAME],
            :place_of_birth => record[Index::POB],
            :date_of_birth => record[Index::DOB].is_a?(Float) ? record[Index::DOB].to_i.to_s : record[Index::DOB],
            :nationality => record[Index::NATIONALITY],
            :address => record[Index::ADDRESS],
            :title => title,
            :other_information => other_information,
            :program => make_program(record[Index::BASIS]),
            #:committee => record[Index::COMMITTEE].to_s.gsub(/[^\d]/, ''),
            :aka => []
      }
    end

    def make_guid(id)
      "DFAT#{id}"
    end

    def make_program(basis)
      basis.gsub('Listing by', '').strip
    end


    def extract_other_field(name, other)
      match_fieldname = Regexp.new("^\s*#{name}:", Regexp::IGNORECASE)
      elements = other.split(';')
      value = elements.select {|e| e =~ match_fieldname}.map{|e| e.gsub(match_fieldname, '').strip }.first # If there is more than one match it ignores the others
      other = elements.reject{|e| e =~ match_fieldname}.join(';') unless value.nil?
      [value, other]
    end

  end
end
