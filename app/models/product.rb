class Product
  # belongs_to :category, optional: true
  # has_many :taxes

  attr_accessor :taxes
  attr_accessor :title, :category, :price, :imported, :includes_tax

  def initialize(title, price, includes_tax: true, category: nil, imported: false)
    @title = title
    @price = price.to_f
    @includes_tax = includes_tax
    @category = category
    @imported = imported

    @taxes = [
      Tax::SalesTax.new(self)      
    ]

    (@taxes << Tax::ImportTax.new(self)) if imported?
  end

  def price_without_tax
    price - tax_amount_in_price
  end

  def tax_amount_in_price
    return 0 unless includes_tax?

    TaxCalculator.call(self)
  end

  def includes_tax?
    !!includes_tax
  end

  def imported?
    !!imported
  end
end
