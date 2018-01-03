class CheckoutController < ApplicationController
  skip_before_action :authenticate_user!
  
  # post /checkout  
  def create
    User.create_charge(params)
    redirect_to checkout_thankyou_path
    rescue Stripe::CardError => e
      flash[:notice] = e.message
      redirect_to @product
  end

  def thankyou
  end
end
