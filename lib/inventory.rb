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
  end

  attr_accessor :type, :storage, :exp_date, :unit, :qty, :status

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
    @list= []
  end

  attr_accessor :list

  def add(item)
    if item.class == Food_Item then
      @list << item
      return true
    else
      return false
    end
  end

  def update_list
    @list.each do |item|
      item.update
    end
  end
end



