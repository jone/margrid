require_relative "../test_helper"

class BuilderTest < Margrid::TestCase
  def setup
    @builder = Margrid::Builder.new(Margrid.grid("built", Minitest::Mock.new))
  end

  def test_add_paginator_to_grid
    grid = @builder.paginated.grid
    assert_equal Margrid.paginator(1), grid.component(:paginator)
  end

  def test_add_default_sort_to_grid
    grid = @builder.sort_by("size", "desc").grid
    assert_equal Margrid.sorter("size", "desc"), grid.component(:sorter)
  end

  def test_load_components_from_params
    grid = @builder.load({"margrid" => {"built" => {"page" => 4}}})
    assert_equal Margrid.paginator(4), grid.component(:paginator)
  end

  def test_use_grid_methods_on_builder
    grid = @builder.prepend(custom: "CUSTOM COMPONENT").grid
    assert_equal "CUSTOM COMPONENT", grid.component(:custom)
  end
end
