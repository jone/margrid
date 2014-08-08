require_relative "../test_helper"

class PaginatorTest < Margrid::TestCase
  def test_applying_a_paginator_delegates_to_page
    relation = Minitest::Mock.new
    paginator = Margrid.paginator(11)

    relation.expect :page, "PAGINATED", [11]
    assert_equal "PAGINATED", paginator.apply(relation)
  end

  def test_load_from_hash_with_existing_param
    paginator = Margrid::Paginator.load({page: 23})
    assert_equal Margrid.paginator(23), paginator
  end

  def test_load_from_hash_without_existing_param
    paginator = Margrid::Paginator.load({})
    assert_equal nil, paginator
  end

  def test_dumping_to_a_hash
    paginator = Margrid.paginator(7)
    assert_equal({page: 7}, paginator.dump)
  end
end
