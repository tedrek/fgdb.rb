class SetReceiptPrinterDefaults < ActiveRecord::Migration
  def self.up
    Default["raw_receipt_printer_default"] = "zebra"
    Default["raw_receipt_printer_regexp"] = "^(zebra|zebtest|jzebra|fakezebra)$"
  end

  def self.down
  end
end
