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

  it "should be able to return a list of all items of a given status" do
    bread = Food_Item.new(:type => "bread", :storage => "shelf", :exp_date => (Date.today - 5).to_s, :unit => "loaf", :qty => 1)
    milk = Food_Item.new(:type => "milk", :storage => "refrigerator", :exp_date => (Date.today + 1).to_s, :unit => "quart", :qty => 1)
    eggs = Food_Item.new(:type => "eggs", :storage => "refrigerator", :exp_date => (Date.today + 12).to_s, :unit => "single", :qty => 12)
    oranges = Food_Item.new(:type => "oranges", :storage => "refrigerator", :exp_date => (Date.today + 20).to_s, :unit => "single", :qty => 8)
    subject.add(oranges)
    subject.add(bread)
    subject.add(milk)
    subject.add(eggs)
    subject.update_list

    expect(subject.get_by_status('EXPIRED')[-1]).to eq(bread)
    expect(subject.get_by_status('WARNING')[-1]).to eq(milk)
    expect(subject.get_by_status('OK')[-1]).to eq(eggs)
    expect(subject.get_by_status('OK')[-2]).to eq(oranges)
  end

  it "should have a function to create items directly" do
    subject.create_item(:type => "cheese", :storage => "refrigerator", :exp_date => (Date.today + 30).to_s, :unit => "pound", :qty => 0.75)
    expect(subject.list[0].type).to eq("cheese")
  end

  it "should assign new items an ID as they're created" do
    subject.create_item(:type => "celery", :storage => "refrigerator", :exp_date => (Date.today + 30).to_s, :unit => "single", :qty => 1)
    subject.create_item(:type => "tomato", :storage => "refrigerator", :exp_date => (Date.today + 30).to_s, :unit => "single", :qty => 1)

    expect(subject.list[0].id).to eq(1)
    expect(subject.list[1].id).to eq(2)
  end

  it "should be able to retrieve an item by its ID" do
    subject.create_item(:type => "turnip", :storage => "refrigerator", :exp_date => (Date.today + 30).to_s, :unit => "single", :qty => 1)
    subject.create_item(:type => "potato", :storage => "refrigerator", :exp_date => (Date.today + 30).to_s, :unit => "single", :qty => 1)
    subject.create_item(:type => "jam", :storage => "refrigerator", :exp_date => (Date.today + 30).to_s, :unit => "single", :qty => 1)

    expect(subject.get_by_ID(1).type).to eq("potato")
  end

end
