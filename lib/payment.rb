module Payment
  extend ActiveSupport::Concern
  class << self
    def create_customer(params)
      customer = Stripe::Customer.create(
        :email => params[:stripeEmail],
        :source  => params[:stripeToken]
      )
    end

    # Creating Direct Charges
    def create_direct_charges(product)
      charge = Stripe::Charge.create({
        :amount => (product.price * 100).to_i,
        :description => product.title,
        :currency => "usd",
        :source => "tok_visa",
        :application_fee => (product.price * 100 * 0.2).to_i,
      }, :stripe_account => product.user.stripe_user_id)
    end

    # Creating Destination Charges on Your Platform
    def create_destination_charge(product)
      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => (product.price * 100).to_i,
        :description => product.title,
        :currency    => 'usd',
        # Strip connect magic, send 80% of the funds (keep 20% cut)
        :destination => {
          :amount => (product.price * 100 * 0.8).to_i,
          :account => product.user.stripe_user_id,
        }
      )
    end

    # separate charges and transfer
    def separate_charges_and_transfer(products)
      charge = Stripe::Charge.create({
        :amount => (products.map(&:price).sum.to_i * 100).to_i,
        :currency => "usd",
        :source => "tok_visa",
        :transfer_group => "product3",
      })
      # available_balance = Stripe::Balance.retrieve().available[0].amount
      if charge.status.eql?('succeeded')
        products.each do |product|
          to_pay = (product.price * 100 * 0.8).to_i

          transfer = Stripe::Transfer.create({
            :amount => to_pay,
            :currency => "usd",
            :source_transaction => charge.id,
            :destination => product.user.stripe_user_id,
          })
        end
      end

      # if charge.status.eql?('succeeded') && available_balance >= to_pay 
      #   transfer = Stripe::Transfer.create({
      #     :amount => to_pay,
      #     :currency => "usd",
      #     :destination => product.user.stripe_user_id,
      #     :transfer_group => "product3",
      #   })
      # end
    end
  end
end