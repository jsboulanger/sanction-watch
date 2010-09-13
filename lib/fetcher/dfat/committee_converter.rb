module Dfat
  class CommitteeConverter < BaseConverter
    
    def initialize(committee)
      @names = []
      @entities_store = {}
      @committee = committee
    end

    def convert_record(record)
      id = extract_id(record)

      if extract_committee(record) == @committee
        unless @entities_store.has_key?(id)
          @entities_store[id] = make_entity(record)
        else
          @entities_store[id][:aka] ||= []
          @entities_store[id][:aka] << make_aka(record)
        end
        @names << make_name(record)
      end
      self
    end
  end
end
