module Margrid
  class Sorter < Struct.new(:column, :direction)
    def initialize(column, direction)
      super column.to_s, direction.to_s
    end

    def apply(relation)
      relation.reorder(sorting)
    end

    def inverted
      self.class.new(column, asc? ? :desc : :asc)
    end

    def desc?
      direction == "desc"
    end

    def asc?
      !desc?
    end

    def self.load(data)
      new data["sort"], data["direction"] if data.key? "sort"
    end

    def dump
      {"sort" => column, "direction" => direction}
    end

    private
    def sorting
      # FIXME: (Rails 4.2) Replace with
      #   relation.reorder(column => direction)
      # when order accepts the direction as strings.
      {column => asc? ? :asc : :desc}
    end
  end

  class Paginator < Struct.new(:current_page)
    def apply(relation)
      relation.page current_page
    end

    def self.load(data)
      new data["page"] if data.key? "page"
    end

    def dump
      {"page" => current_page}
    end
  end
end
