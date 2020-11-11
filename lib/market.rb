class Market
  attr_reader :name,
              :vendors

  def initialize(name)
    @name = name
    @vendors = []
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map do |vendor|
      vendor.name
    end
  end

  def vendors_that_sell(item)
    @vendors.find_all do |vendor|
      vendor.inventory.include?(item)
    end
  end

  def all_items
    @vendors.flat_map do |vendor|
      vendor.inventory.keys
    end.uniq
  end

  def total_inventory
    inventory = Hash.new({})
    all_items.each do |item|
      @vendors.each do |vendor|
        (inventory[item][:quantity] += vendor.check_stock(item) if inventory[item][:quantity]) ||
          (inventory[item][:quantity] = vendor.check_stock(item))
        (inventory[item][:vendors] << vendor if inventory[item][:vendors]) ||
          (inventory[item][:vendors] = [vendor])
      end
    end
    complete_inventory = Hash.new()
    vendors.each do |vendor|
      vendor.inventory.keys.each do |item|
        complete_inventory[item] = inventory[item]
      end
    end
    complete_inventory
  end

  def overstocked_items
    overstock = total_inventory.find_all do |item, info|
      (total_inventory[item][:quantity] > 50) && (total_inventory[item][:vendors].count > 1)
    end
    items = overstock.map do |item|
      item[0]
    end
    items
  end

  def sorted_items_list
    all_items.map do |item|
      item.name
    end.sort
  end

end
