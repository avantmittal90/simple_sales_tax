class TaxCalculator::Invoice
  attr_reader :calculator_service, :invoice

  def initialize(calculator_service)
    @calculator_service = calculator_service
    @invoice = calculator_service.taxable_resource
  end

  def calculate
    invoice.invoice_line_tems&.map do |li|
      TaxCalculator.call(li, calculator_service.types)
    end.sum || 0
  end
end
