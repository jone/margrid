module Margrid
  class Grid
    # Every grid created with the same +id+ will result in the same
    # serialization output. This means that they share the same state.
    # +relation+ is an instance following the +Margrid::Relation+ protocol.
    def initialize(id, relation)
      @id = id
      @relation = relation
      @components = {}
    end

    # Check wether a component is registered or not.
    def component?(comp_sym)
      @components.key? comp_sym
    end

    # Get the component for a given +comp_sym+.
    def component(comp_sym)
      @components[comp_sym]
    end

    # Attach components to the grid. This method can be called multiple times.
    # Prepending a component will overwrite existing components.
    #
    # +comp_hash+ uses a +comp_sym+ as key and a component instance as value.
    def prepend(comp_hash)
      @components.update comp_hash
      self
    end

    # Load components from a Hash.
    def load(params)
      grid_params = params.fetch("margrid", {}).fetch(@id, {})
      if sorter = Sorter.load(grid_params)
        prepend sorter: sorter
      end
      if paginator = Paginator.load(grid_params)
        prepend paginator: paginator
      end
      self
    end

    # Dump components to a nested Hash.
    def dump(comps = nil)
      comps ||= @components.values
      grid_params = comps.inject({}) do |params, comp|
        params.merge(comp.dump)
      end
      {"margrid" => {@id => grid_params}}
    end

    # Dump components to a Hash. The key of the Hash is the rack param name.
    def to_query(comps = nil)
      comps ||= @components.values
      prefix = "margrid[#{@id}]"
      comps.inject({}) do |params, comp|
        comp.dump.each do |k, v|
          params[prefix + "[#{k}]"] = v
        end
        params
      end
    end

    # Rows to display in the grid. This will apply every registered component
    # to the +ActiveRecord::Relation+ passed upon grid initialization.
    # This method returns a new +ActiveRecord::Relation+ representing the grid rows.
    def rows
      @rows ||= @components.values.inject(@relation) do |relation, comp|
        comp.apply(relation)
      end.to_a
    end
  end
end
