class Tax::ImportTax < Tax
  def exempt?
    !product.imported?
  end

  private
  def percentage_number
    0.05
  end
end
