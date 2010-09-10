module Osfi

  # Converts an OSFI entities list.
  class EntitiesConverter < BaseConverter

    class Index
      ID = 0
      NAME = 1
      OTHER_INFORMATION = 2
      BASIS = 3
    end

    protected

    def make_entity(r)
      id = r[Index::ID].split('.').first
      {
        :type => "entity",
        :guid => make_guid(id),
        :oid => id,
        :full_name => r[Index::NAME],
        :address => nil,
        :other_information => r[Index::OTHER_INFORMATION],
        :program => make_program(r[Index::BASIS]),
        :aka => []
      }
    end

    def make_name(r)
      {
        :type => "name",
        :guid => "NAME-#{r[Index::NAME]}",
        :full_name => r[Index::NAME]
      }
    end

    def make_aka(r)
      r[Index::NAME]
    end

    def make_guid(str)
      "OSFIE#{str}"
    end

    

  end # EntitiesConverter
end # Osfi