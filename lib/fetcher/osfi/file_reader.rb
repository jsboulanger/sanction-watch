module Osfi

  # Reads an OSFI file into an array
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
        file.each_line do |line|
          if line =~ /^\d+\.\d/
            records << line.split("\t").map {|v| clean(v)}
          end
        end
        records
      end

      def clean(str)
        str.to_s.gsub('"', '').strip
      end

    end # self << class

  end # FileReader
end # Osfi
