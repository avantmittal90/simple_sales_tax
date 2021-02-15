class InvoiceCmdApplication
  STOP_WORDS = ['done', '']

  attr_reader :lines, :input, :output, :invoice

  def self.call
    new.launch
  end

  def initialize
    @lines = []
    @input = nil
    @output = []

    @invoice = Invoice.new
  end

  def launch
    puts "Welcome to PrintSpeak Simple Sales Tax application.\nPlease input line items in format (quantity, product name, price).\nEnter 'done' or leave blank to submit your invoice"

    # Step 1: Take Inputs
    take_inputs

    # Step 2: Build Invoice
    build_invoice

    # Step 3: Display Invoice Details
    display_invoice
  end

  def take_input
    @input = gets.chomp.strip
    puts "Your Input => '#{input}'"

    input
  end

  private
  def take_inputs
    while !STOP_WORDS.include?(take_input)
      lines << input

      puts "Your Next Line Item ..."
    end
  end

  def build_invoice
    return if lines.size < 1

    lines.each do |line|
      break if STOP_WORDS.include?(line)

      quantity, product_name, price = line.split(',').map(&:strip)
      product = build_product(product_name, price)
      invoice_line_item = build_invoice_line_item(product, quantity)

      @invoice.invoice_line_items << invoice_line_item
    end
  end

  def build_invoice_line_item(product, quantity)
    InvoiceLineItem.new(product, quantity)
  end

  def build_product(product_name, price)
    imported = imported?(product_name)
    category = find_category(product_name)
    includes_tax = true

    Product.new(product_name, price, category: category, imported: imported)
  end

  def find_category(product_name)
    # NOTE: The logic is very basic here and can be improved further
    # Category model can also be created to store the common categories
    if product_name.include?('chocolate')
      'food'
    elsif product_name.include?('pills')
      'medical'
    elsif product_name.include?('book')
      'book'
    else
      'other'
    end
  end

  def imported?(product_name)
    product_name.include?('import')
  end

  def display_invoice
    puts '*'*50
    puts 'Here is your invoice details:'
    puts '*'*50

    # Display Line Items
    invoice.invoice_line_items.each do |li|
      puts "#{li.quantity}, #{li.product.title}, #{li.product.price}"
    end

    # Display Sales Tax
    puts "Sales Tax: #{invoice.sales_tax}"

    # Display Total
    puts "Total: #{invoice.total}"

    puts '*'*50
  end
end
