require 'minitest/autorun'
require 'minitest/pride'
require './lib/item'

class ItemTest < Minitest::Test

  def setup
    @item = Item.new({name: 'Peach', price: "$0.75"})
  end

  def test_it_exists
    assert_instance_of Item, @item
  end

  def test_it_calls_name
    assert_equal "Peach", @item.name
  end

  def test_it_calls_price
    assert_equal "$0.75", @item.price
  end

end
