module Osfi


  class IranEntitiesConverter < EntitiesConverter

    protected

    def make_program(record)
      super(record).map {|p| "UN Iran #{p.strip}" }
    end

    def make_guid(str)
      "OSFIEI#{str}"
    end

  end # IranEntitiesConverter
end # Osfi