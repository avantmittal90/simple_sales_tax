class TaxCalculator
  attr_reader :taxable_resource, :amount, :types

  def self.call(taxable_resource, types=[])
    new(taxable_resource).calculate
  end

  # Value inclusive of tax X tax rate ÷ (100+ tax rate)
  def self.find_tax_portion_in_product_price(tax, product)
    return 0 if tax.exempt? || tax.percentage.zero?
    return 0 unless product.includes_tax?

    total_percentage = product.taxes.map { |t| t.percentage }.sum
    total_tax = (product.price * total_percentage) / (1 + total_percentage)

    ((tax.percentage / total_percentage) * total_tax).round(2)
  end

  def initialize(taxable_resource)
    @taxable_resource = taxable_resource
  end

  def calculate
    calculator_klass = case taxable_resource.class.name.to_s
    when 'Product'
      TaxCalculator::Product
    when 'Invoice'
      TaxCalculator::Invoice
    when 'InvoiceLineItem'
      TaxCalculator::InvoiceLineItem
    end

    calculator_klass.new(self).calculate
  end
end
