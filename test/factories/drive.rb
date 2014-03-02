FactoryGirl.define do
  factory :drive do
    manufacturer "Western Digital"
    model "WD5000AAKS-00TMA0"
    serial { (0...20).map { (65 + rand(26)).chr }.join }
    size 500_107_862_016
  end
end
