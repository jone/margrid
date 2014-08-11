require 'delegate'

module Margrid
  module Relation
    def reorder(hash)

    end

    def page(current_page)

    end

    def to_a

    end
  end

  class ActiveRecordRelation < SimpleDelegator
    include Relation
  end

  class ObjectRelation
    include Relation

    def initialize(collection, per_page = 20)
      @collection = collection
      @per_page = per_page
    end

    def reorder(hash)
      column, order = *hash.first
      sorted = @collection.sort { |a, b| a.send(column) <=> b.send(column) }
      order == :desc ? sorted.reverse : sorted
    end

    def page(current_page)
      @collection.in_groups_of(@per_page, false)[current_page - 1]
    end

    def to_a
      @collection
    end
  end
end
