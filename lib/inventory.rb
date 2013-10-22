require 'pry'
require 'Date'

class Food_Item
  def initialize(options = {})
    @type = options[:type] || ''
    @storage = options[:storage] || ''
    @exp_date = options[:exp_date] || ''
    @unit = options[:unit] || ''
    @qty = options[:qty] || 0
    @status = options[:status] || 'NEW'
    @id = options[:id] || "ERROR:NO ID"
  end

  attr_accessor :type, :storage, :exp_date, :unit, :qty, :status, :id

  def update
    if @exp_date == ''
      return false
    elsif Date.parse(@exp_date) - Date.today < 0
      @status = 'EXPIRED'
    elsif Date.parse(@exp_date) - Date.today < 7
      @status = 'WARNING'
    else
      @status = 'OK'
    end
    return @status
  end
end

class Inventory_List
  def initialize
    @list = []
    @last_ID_added = 0
  end

  attr_accessor :list

  def add(item)
    if item.class == Food_Item then
      @list << item
      return true
    end
    return false
  end

  def create_item(options = {})
    #Round this out - add error checking.
    input_hash = options.merge({:id => get_available_ID})
    self.add(Food_Item.new(input_hash))
  end

  def get_available_ID
    @last_ID_added += 1
    return @last_ID_added
  end

  def update_list
    @list.each do |item|
      item.update
    end
  end

  def get_by_status(status)
    selected_items = []
    @list.each do |item|
      if item.status == status then
        selected_items << item
      end
    end
    return selected_items
  end

  def get_by_ID(desired_ID)
    @list.each do |item|
      if item.id == desired_ID
        return item
      end
    end
    return "NO ITEM FOUND"
  end

end



