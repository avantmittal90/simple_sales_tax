class InvoiceLineItem
  # belongs_to :invoice
  # belongs_to :product

  attr_accessor :quantity, :product
  attr_reader :tax_total, :total

  def initialize(product, quantity)
    @product = product
    @quantity = quantity.to_i
  end

  def tax_total
    (TaxCalculator.call(self).to_f).round(2)
  end

  def sales_tax
    amount = TaxCalculator.call(self, [Tax::SalesTax]).to_f
    # p "#{product.name} Sales Tax = #{amount}"
    amount.round(2)
  end

  def import_tax
    amount = TaxCalculator.call(self, [Tax::ImportTax]).to_f
    # p "#{product.name} Import Tax = #{amount}"
    amount.round(2)
  end

  def total
    if product.includes_tax?
      (product.price * quantity).round(2)
    else
      (product.price * quantity + tax_total).round(2)
    end
  end
end
