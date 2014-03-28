FactoryGirl.define do
  factory :run do
    drive
    device_name '/dev/sda'
    start_time Time.now
    result 'In progress'
  end
end
