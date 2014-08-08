module Margrid
  module FactoryMethods
    def grid(*args)
      Margrid::Grid.new(*args)
    end

    def sorter(*args)
      Margrid::Sorter.new(*args)
    end

    def paginator(*args)
      Margrid::Paginator.new(*args)
    end
  end
end
