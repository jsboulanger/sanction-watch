module Osfi
  class IranIndividualsConverter < IndividualsConverter

  protected

    def make_program(record)
      super(record).map {|p| "UN Iran #{p.strip}" }
    end

    def make_guid(str)
      "OSFIII#{str}"
    end

  end # IranIndividualsConverter
end # Osfi
