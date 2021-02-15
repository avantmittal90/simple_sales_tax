class Invoice
  # has_many :invoice_line_items, dependent: :destroy
  attr_accessor :invoice_line_items

  def initialize
    @invoice_line_items = []
  end

  def total
    invoice_line_items&.map { |li| li.total }.sum.round(2) || 0
  end

  def sales_tax
    invoice_line_items&.map { |li| li.sales_tax }.sum.round(2) || 0
  end
end
