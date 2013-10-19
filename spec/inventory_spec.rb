require 'spec_helper'
require_relative '../lib/inventory.rb'

#Food_Item
#Inventory_List

describe Food_Item do
  subject {Food_Item.new}

  it "should initialize" do
    expect(subject).to_not be nil
  end

  it "should have a food type, expiration date, storage condition, unit of measurement, quantity, and status" do
    expect(subject.type).not_to be nil
    expect(subject.storage).not_to be nil
    expect(subject.exp_date).not_to be nil
    expect(subject.unit).not_to be nil
    expect(subject.qty).not_to be nil
    expect(subject.status).not_to be nil
  end

  it "should give every item the 'NEW' status when it's created, unless explicitly stated otherwise" do
    expect(subject.status).to eq('NEW')
    expired_item = Food_Item.new(:status => 'EXPIRED')
    expect(expired_item.status).to eq('EXPIRED')
  end

  it "should never have a negative quantity" do
    expect(subject.qty).not_to be < 0
  end

  it "should update status to 'EXPIRED' if exp_date is before today" do
    subject.exp_date = (Date.today - 10).to_s
    expect(subject.update).to eq('EXPIRED')
  end

  it "should update status to 'WARNING' if exp_date is 7 days away or fewer" do
    subject.exp_date = (Date.today + 3).to_s
    expect(subject.update).to eq('WARNING')
  end

  it "should update status to 'OK' if exp_date is over 7 days away" do
    subject.exp_date = (Date.today + 10).to_s
    expect(subject.update).to eq('OK')
  end
end

describe Inventory_List do
  subject {Inventory_List.new}

  it "should initialize" do
    expect(subject).to_not be nil
  end

  it "should have a list of items" do
    expect(subject.list).to_not be nil
  end

  it "should be able to add Food_Items" do
    expect(subject.add(Food_Item.new)).to eq(true)
  end

  it "should return false if you try to add something that's not a Food_Item" do
    expect(subject.add("some string")).to eq(false)
  end

  it "shouldn't change any attributes of added items" do
    milk = Food_Item.new(:type => "milk", :storage => "refrigerator", :exp_date => "2013-10-29", :unit => "quart", :qty => 1)
    subject.add(milk)
    expect(subject.list[-1]).to eq(milk)
  end

  it "should be able to update the statuses of all items on the list" do
    bread = Food_Item.new(:type => "bread", :storage => "shelf", :exp_date => "2013-11-02", :unit => "loaf", :qty => 1)
    milk = Food_Item.new(:type => "milk", :storage => "refrigerator", :exp_date => "2013-10-29", :unit => "quart", :qty => 1)
    subject.add(bread)
    subject.add(milk)

    subject.update_list

    # expect(bread.status).to_not eq('NEW')
    # expect(milk.status).to_not eq('NEW')
    subject.list.each do |list_item|
      expect(list_item.status).to_not eq('NEW')
    end
  end
end
