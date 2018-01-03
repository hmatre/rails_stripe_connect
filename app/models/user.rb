class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include Payment

  has_many :products
  class << self
    def create_charge(params)
      products = Product.find(params[:products])
      # product = Product.find(params[:product_id])
      Payment.create_customer(params)
      # Payment.create_direct_charges(products.last) # if you want to create charge using direct charge
      # Payment.create_destination_charge(products.last) # if you want to create charge using destination charge
      Payment.separate_charges_and_transfer(products) # if you want to create charge using separate charge and transfer
    end
  end

end
