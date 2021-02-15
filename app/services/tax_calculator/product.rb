class TaxCalculator::Product
  attr_reader :calculator_service, :product, :includes_tax, :price

  def initialize(calculator_service)
    @calculator_service = calculator_service
    @product = calculator_service.taxable_resource
    @includes_tax = @product.includes_tax
    @price = @product.price
  end

  def sales_tax
    product.taxes.select { |tax| tax.type == 'Tax::SalesTax' }.first
  end

  # Value inclusive of tax X tax rate ÷ (100+ tax rate)
  def tax_portion(tax)
    TaxCalculator.find_tax_portion_in_product_price(tax, product)
  end

  def import_tax
    product.taxes.select { |tax| tax.type == 'Tax::ImportTax' }.first
  end

  # NOTE: This method aims to calculate the tax portion in the price of the product
  def calculate
    product.taxes&.map { |tax| tax_portion(tax) }.sum.to_f || 0
  end
end
