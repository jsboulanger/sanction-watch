module Osfi
  # Converts an OSFI individuals list
  class IndividualsConverter < BaseConverter

    class Index
      ID = 0
      LAST_NAME = 1
      FIRST_NAME = 2
      SECOND_NAME = 3
      THIRD_NAME = 4
      FOURTH_NAME = 5
      POB = 6
      ALT_POB = 7
      DOB = 8
      ALT_DOB_0 = 9
      ALT_DOB_1 = 10
      ALT_DOB_2 = 11
      NATIONALITY_0 = 12
      NATIONALITY_1 = 13
      NATIONALITY_2 = 14
      OTHER_INFORMATION = 15
      BASIS = 16
    end

  protected

    def make_name(r)
      {
        :type => "name",
        :guid => "name-#{make_fullname(r)}",
        :full_name => make_fullname(r)
      }
    end

    def make_entity(r)
      id = r[Index::ID].split('.').first
      address, other_information = extract_other_field("address", r[Index::OTHER_INFORMATION])
      title, other_information = extract_other_field("title", other_information)

      {
            :type => "individual",
            :guid => make_guid(id),
            :oid => id,
            :full_name => make_fullname(r),
            :last_name => r[Index::LAST_NAME],
            :first_name => make_firstname(r),
            :place_of_birth => r[Index::POB],
            :place_of_birth_alt => r[Index::ALT_POB],
            :date_of_birth => r[Index::DOB],
            :date_of_birth_alt => [r[Index::ALT_DOB_0], r[Index::ALT_DOB_1], r[Index::ALT_DOB_1]].select {|d| d != '' },
            :nationality => [r[Index::NATIONALITY_0], r[Index::NATIONALITY_1], r[Index::NATIONALITY_2]].select {|d| d != ''},
            :address => address,
            :title => title,
            :other_information => other_information,
            :program => make_program(r[Index::BASIS]),
            :aka => []
      }
    end

    def make_aka(r)
      make_fullname(r)
    end

    def make_fullname(r)
      [make_firstname(r), r[Index::LAST_NAME]].select {|n| n != ''}.join(' ')
    end

    def make_firstname(r)
      [r[Index::FIRST_NAME], r[Index::SECOND_NAME], r[Index::THIRD_NAME], r[Index::FOURTH_NAME]].select {|n| n != ''}.join(' ')
    end

    def make_guid(str)
      "OSFII#{str}"
    end

  end # IndividualsConverter
end # Osfi
