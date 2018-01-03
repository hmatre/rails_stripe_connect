module ProductsHelper
  def get_cart_count
    if session[:cart].present?
      session[:cart].count == 0 ? 0 : session[:cart].count
    else
      0
    end
  end

  def get_total_price
    @products.map(&:price).sum.to_i
  end
end
