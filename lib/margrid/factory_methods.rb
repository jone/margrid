module Margrid
  module FactoryMethods
    def grid(id, original_relation)
      Margrid::Grid.new(id, relation(original_relation))
    end

    def sorter(*args)
      Margrid::Sorter.new(*args)
    end

    def paginator(*args)
      Margrid::Paginator.new(*args)
    end

    def relation(original_relation)
      case original_relation
      when Margrid::Relation
        original_relation
      when ActiveRecord::Relation
        Margrid::ActiveRecordRelation.new(original_relation)
      else
        Margrid::ObjectRelation.new(original_relation)
      end
    end
  end
end
