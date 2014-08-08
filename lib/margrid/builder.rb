module Margrid
  # Utility class to ease the creation of Margrid::Grid instances.
  # It can be subclassed to provide more specialized behavior for your applications.
  #
  #   class MyBuilder < Margrid::Builder
  #     def self.articles(id: "articles", relation: Articles.all)
  #       builder = new Margrid::Grid.new(id, relation)
  #       builder.sort_by "published_at", "desc"
  #       builder
  #     end
  #   end
  class Builder
    attr_reader :grid

    def initialize(grid)
      @grid = grid
    end

    # Configure the grid to use pagination.
    def paginated(current_page: 1)
      prepend paginator: Margrid::Paginator.new(current_page)
    end

    # Sort the grid by +column+ in +direction+.
    # Direction can be +:asc+ or +:desc+
    def sort_by(column, direction)
      prepend sorter: Margrid::Sorter.new(column, direction)
    end

    # Deserialize Margrid components from a hash. This is usually the case
    # when the state using the query string.
    #
    # NOTE: this method should be the last call when chaining Builder methods.
    # It will return the Margrid::Grid instance and not the builder itself.
    def load(params)
      @grid.load(params)
    end

    def method_missing(sym, *args)
      if @grid.respond_to?(sym)
        @grid = @grid.send(sym, *args)
        self
      end
    end
  end
end
