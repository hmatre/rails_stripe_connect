class Product < ApplicationRecord
  belongs_to :user
  class << self
    def get_cart_items(cart_items)
      product = []
      cart_items.each do |item|
        product << get_product(item)
      end
      product
    end

    def get_product(item)
      item =  item.to_json
      JSON.parse(item, object_class: Product)
    end
  end
end
