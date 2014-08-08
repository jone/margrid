require_relative "../test_helper"

class SorterTest < Margrid::TestCase
  def test_applying_a_sorter_delegates_to_reorder
    relation = Minitest::Mock.new
    sorter = Margrid.sorter("age", "desc")

    relation.expect :reorder, "SORTED", ["age" => :desc]
    assert_equal "SORTED", sorter.apply(relation)
  end

  def test_load_from_hash_with_existing_param
    sorter = Margrid::Sorter.load({sort: "name", direction: "asc"})
    assert_equal Margrid.sorter("name", "asc"), sorter
  end

  def test_load_from_hash_without_existing_param
    sorter = Margrid::Sorter.load({})
    assert_equal nil, sorter
  end

  def test_dumping_to_a_hash
    sorter = Margrid.sorter("author", "desc")
    assert_equal({sort: "author", direction: "desc"}, sorter.dump)
  end

  def test_works_with_symbols_and_strings
    assert_equal Margrid.sorter(:name, :desc), Margrid.sorter("name", "desc")
  end

  def test_inverting_flips_direction
    assert Margrid.sorter("name", "asc").inverted.desc?
    assert Margrid.sorter("name", "desc").inverted.asc?
  end
end
