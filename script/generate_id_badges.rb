require 'barby'
require 'barby/outputter/rmagick_outputter'
require 'stringio'
require "prawn"
require 'prawn/labels'

Prawn::Labels.types = {
  "Avery5390" => {
    "paper_size" => "LETTER",
    "top_margin" => 76.5,
    "bottom_margin" => 76.5,
    "left_margin" => 54,
    "right_margin" => 54,
    "columns" => 2,
    "rows" => 4,
    "column_gutter" => 0,
    "row_gutter" => 0,
    "vertical_text" => true
  }}

contacts = ["Ryan", "Richard", "Intern", "Test", "Ryan", "Richard", "Intern", "Test"]

Prawn::Labels.generate("hello_labels.pdf", contacts, :type => "Avery5390") do |pdf, contact|
  top_h = 5 * pdf.bounds.height / 7.0
  low_h = 2 * pdf.bounds.height / 7.0
  name = contact # FIXME
  pdf.bounding_box [0, top_h + low_h], :height => top_h, :width => pdf.bounds.width do
    mode = "vol"
    if mode == "staff"
      one_w = 2 * pdf.bounds.width / 9.0
      two_w = 7 * pdf.bounds.width / 9.0
      pdf.bounding_box [0, pdf.bounds.height], :width => one_w, :height => pdf.bounds.height do
        pdf.y -= 2
        pdf.text "STAFF", :size => 32, :align => :center
      end
      pdf.bounding_box [one_w, pdf.bounds.height], :width => two_w, :height => pdf.bounds.height do
        pdf.image "60011.png", :position => :center, :fit => [two_w - 10, pdf.bounds.height - 26]
        pdf.y -= 2
        pdf.bounding_box [0, 26], :width => two_w - 10, :height => 26 do
          pdf.text "Date issued: " + Date.today.strftime("%m/%d/%y"), :size => 8, :align => :right
        end
      end
    else
      pdf.text "Foo Bar Intern", :size => 32, :height => pdf.bounds.height - 26, :valign => :center, :align => :center
      pdf.y -= (32 * 2)
      pdf.text "Date issued: " + Date.today.strftime("%m/%d/%y"), :size => 8, :align => :center
    end
  end
  pdf.bounding_box [0, low_h], :height => low_h, :width => pdf.bounds.width do
    one_w = 3 * pdf.bounds.width / 9.0
    two_w = 6 * pdf.bounds.width / 9.0
    pdf.bounding_box [0, pdf.bounds.height], :width => one_w, :height => pdf.bounds.height do
      pdf.image "/var/www/fgdb.rb/public/images/freegeeklogo.png", :fit => [pdf.bounds.width - 10, low_h], :vposition => :center, :position => :center
    end
    pdf.bounding_box [one_w, pdf.bounds.height], :width => two_w, :height => pdf.bounds.height do
      pdf.text "Ryan\nNiebur", :align => :center
      pdf.image StringIO.new((Barby::Code39.new("055010")).to_png(:margin => 0)), :height => 20, :width => two_w - 40, :position => :center
      pdf.y -= 5
      pdf.text "#055010", :align => :center
    end
  end
#  pdf.stroke_color "000000"
#  pdf.stroke_bounds # TODO: removeme
end
