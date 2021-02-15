class Tax
  # belongs_to :product

  attr_accessor :product
  attr_accessor :type

  def initialize(product)
    @product = product
    @type = self.class.name
  end

  def percentage
    return 0 if exempt?

    percentage_number
  end

  def amount
    if product.includes_tax?
      TaxCalculator.find_tax_portion_in_product_price(self, product)
    else
      product.amount * percentage
    end
  end

  def exempt?
    false
  end

  private
  def percentage_number
    raise 'Not Implemented'
  end
end
