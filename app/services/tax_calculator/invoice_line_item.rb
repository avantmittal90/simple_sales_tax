class TaxCalculator::InvoiceLineItem
  attr_reader :calculator_service, :invoice_line_item

  def initialize(calculator_service)
    @calculator_service = calculator_service
    @invoice_line_item = calculator_service.taxable_resource
  end

  def calculate
    tax_sum = (invoice_line_item.product.taxes&.map do |tax|
      amount = if calculator_service.types.blank? || calculator_service.types.include?(tax.type)
        tax.amount
      end

      amount.to_f
    end.sum.to_f) || 0

    tax_sum * invoice_line_item.quantity
  end
end
