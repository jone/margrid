require_relative "../test_helper"

class ObjectRelationTest < Margrid::TestCase
  User = Struct.new(:name, :age)

  def setup
    @collection = [User.new("Sandra", 82),
                   User.new("Jack", 12),
                   User.new("Megan", 34)]
    @relation = Margrid::ObjectRelation.new(@collection, 2)
  end

  def test_reorder_objects
    assert_equal ["Jack", "Megan", "Sandra"], @relation.reorder(name: :asc).to_a.map(&:name)
    assert_equal ["Sandra", "Megan", "Jack"], @relation.reorder(name: :desc).to_a.map(&:name)

    assert_equal [12, 34, 82], @relation.reorder(age: :asc).to_a.map(&:age)
    assert_equal [82, 34, 12], @relation.reorder(age: :desc).to_a.map(&:age)
  end

  def test_page_objects
    assert_equal ["Sandra", "Jack"], @relation.page(1).to_a.map(&:name)
    assert_equal ["Megan"], @relation.page(2).to_a.map(&:name)
  end
end
