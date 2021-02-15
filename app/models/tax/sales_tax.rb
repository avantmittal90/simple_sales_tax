class Tax::SalesTax < Tax
  EXEMPT_CATEGORIES = %w(book food medical)

  def exempt?
    EXEMPT_CATEGORIES.include?(product.category)
  end

  private
  def percentage_number
    0.1
  end
end
