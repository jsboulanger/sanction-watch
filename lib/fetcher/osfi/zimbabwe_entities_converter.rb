module Osfi


  class ZimbabweEntitiesConverter < EntitiesConverter

     class Index
      ID = 0
      NAME = 1
      ADDRESS = 2
      OTHER_INFORMATION = 3
      BASIS = 4
    end

    def make_entity(r)
      id = r[Index::ID].split('.').first
      {
        :type => "entity",
        :guid => make_guid(id),
        :oid => id,
        :full_name => r[Index::NAME],
        :address => r[Index::ADDRESS],
        :other_information => r[Index::OTHER_INFORMATION],
        :program => make_program(r[Index::BASIS]),
        :aka => []
      }
    end

    protected

    def make_program(record)
      super(record).map {|p| "UN Zimbabwe #{p.strip}" }
    end

    def make_guid(str)
      "OSFIEZIM#{str}"
    end

  end # IranEntitiesConverter
end # Osfi