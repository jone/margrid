require_relative "../test_helper"

class GridTest < Margrid::TestCase
  class CustomComponent < Struct.new(:prefix)
    def apply(relation)
      relation.do_stuff
    end

    def dump
      {prefix => "state"}
    end
  end

  def setup
    @relation = Minitest::Mock.new
    @grid = Margrid::Grid.new("test", @relation)
  end

  def test_prepending_components_overwrites_existing_ones
    @grid.prepend custom: (first = CustomComponent.new)
    @grid.prepend custom: (second = CustomComponent.new)

    assert_equal second, @grid.component(:custom)
  end

  def test_rows_applies_every_component_to_the_relation
    @grid.prepend custom: CustomComponent.new

    @relation.expect :do_stuff, ["APPLIED RELATION"], []
    assert_equal ["APPLIED RELATION"], @grid.rows
  end

  def test_knows_registered_components
    @grid.prepend first: CustomComponent.new
    @grid.prepend second: CustomComponent.new

    assert @grid.component?(:first)
    assert @grid.component?(:second)
    refute @grid.component?(:third)
  end

  def test_access_registerd_components
    @grid.prepend first: (first_comp = CustomComponent.new)

    assert_equal first_comp, @grid.component(:first)
  end

  def test_access_non_registerd_components
    assert_equal nil, @grid.component(:does_not_exist)
  end

  def test_dumping_a_grid_dumps_every_component
    @grid.prepend first: CustomComponent.new("some")
    @grid.prepend second: CustomComponent.new("more")

    assert_equal({"margrid"=>{"test"=>{"some"=>"state", "more"=>"state"}}}, @grid.dump)
  end

  def test_dumping_a_specific_component
    assert_equal({"margrid"=>{"test"=>{"not_much"=>"state"}}},
                 @grid.dump([CustomComponent.new("not_much")]))
  end

  def test_represent_the_grid_as_a_query
    @grid.prepend first: CustomComponent.new("first")
    @grid.prepend second: CustomComponent.new("second")

    assert_equal({"margrid[test][first]"=>"state", "margrid[test][second]"=>"state"},
                 @grid.to_query)
  end

  def test_representing_a_component_as_query
    assert_equal({"margrid[test][stuff]"=>"state"},
                 @grid.to_query([CustomComponent.new("stuff")]))
  end

  def test_load_components_form_a_hash
    @grid.load({"margrid" => {"test" => {sort: "name", direction: "asc", page: 3}}})
    assert_equal Margrid.sorter("name", "asc"), @grid.component(:sorter)
    assert_equal Margrid.paginator(3), @grid.component(:paginator)
  end

  def test_load_and_prepend_overwrite_eachother
    @grid.prepend(paginator: CustomComponent.new("fluffy"))
    @grid.load({"margrid" => {"test" => {sort: "name", direction: "asc", page: 8}}})
    @grid.prepend(sorter: CustomComponent.new("cat"))
    assert_equal CustomComponent.new("cat"), @grid.component(:sorter)
    assert_equal Margrid.paginator(8), @grid.component(:paginator)
  end
end

class GridRelationTest < Margrid::TestCase
  User = Struct.new(:name, :age)
  def test_with_ruby_object_relation
    collection = [User.new("Jack", 12), User.new("Megan", 34), User.new("Sandra", 82)]
    grid = Margrid::Grid.new("test", Margrid::ObjectRelation.new(collection))
    assert_equal collection, grid.rows
  end
end
