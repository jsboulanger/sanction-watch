require 'spreadsheet'

module Dfat
  # Reads an DFAT file into an array
  class FileReader

    def initialize(converter)
      @converter = converter
    end

    def parse(file)
      records = self.class.parse_into_array(file)

      records.each do |record|
        @converter.convert_record(record)
      end
      @converter
    end

    class << self

      def parse_into_array(file)
        records = []
        Spreadsheet.client_encoding = 'UTF-8'
        book = Spreadsheet.open file
        sheet = book.worksheet(0)
        sheet.each_with_index do |row, i|
          records << row.to_a unless i == 0          
        end
        records
      end

      def clean(str)
        str.to_s.gsub('"', '').strip
      end
    end # self << class
  end # FileReader
end # Osfi
