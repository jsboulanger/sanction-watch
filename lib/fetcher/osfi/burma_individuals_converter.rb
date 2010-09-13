module Osfi
  class BurmaIndividualsConverter < IndividualsConverter

    class Index
      ID = 0
      LAST_NAME = 1
      FIRST_NAME = 2
      SECOND_NAME = 3
      THIRD_NAME = 4
      DOB = 5
      OTHER_INFORMATION = 6
      BASIS = 7
    end

  protected

    def make_entity(r)
      id = r[Index::ID].split('.').first
      address, other_information = extract_other_field("address", r[Index::OTHER_INFORMATION])
      title, other_information = extract_other_field("designation", other_information)

      {
            :type => "individual",
            :guid => make_guid(id),
            :oid => id,
            :full_name => make_fullname(r),
            :last_name => r[Index::LAST_NAME],
            :first_name => make_firstname(r),
            :date_of_birth => r[Index::DOB],
            :nationality => 'Burma',
            :address => address,
            :title => title,
            :other_information => other_information,
            :program => make_program(r[Index::BASIS]),
            :aka => []
      }
    end

    def make_fullname(r)
      [make_firstname(r), r[Index::LAST_NAME]].select {|n| n != ''}.join(' ')
    end

    def make_firstname(r)
      [r[Index::FIRST_NAME], r[Index::SECOND_NAME], r[Index::THIRD_NAME]].select {|n| n != ''}.join(' ')
    end

    def make_program(record)
      super(record).map {|p| "UN Burma #{p.strip}" }
    end

    def make_guid(str)
      "OSFIIBUR#{str}"
    end

  end # IranIndividualsConverter
end # Osfi
