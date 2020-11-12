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

  def all_items_info
    item_and_info = {}
    all_items.each do |item|
      item_and_info[item] = {:quantity => 0, :vendors => []}
    end
    item_and_info
  end

  def total_inventory
    inventory = all_items_info
    @vendors.each do |vendor|
      vendor.inventory.each do |item, amount|
        inventory[item][:quantity] += amount
        (inventory[item][:vendors] << vendor) if (amount > 0)
      end
    end
    inventory
  end

  def overstocked_items
    overstock = total_inventory.find_all do |item, info|
      (total_inventory[item][:quantity] > 50) && (total_inventory[item][:vendors][1])
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

  def sell(item, amount)
    if total_inventory[item][:quantity] >= amount
      until amount <= 0
        vendors_that_sell(item).each do |vendor|
          if vendor.inventory[item] >= amount
          vendor.inventory[item] -= amount
          amount -= vendor.inventory[item]
          else
          amount -= vendor.inventory[item]
          vendor.inventory[item] = 0
          end
        end
      end
      true
    else
      false
    end
  end

end
