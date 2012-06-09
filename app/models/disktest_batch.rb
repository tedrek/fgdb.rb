class DisktestBatch < ActiveRecord::Base
  belongs_to :contact
  has_many :disktest_batch_drives, :class_name => "DisktestBatchDrive"
  belongs_to :user_finalized_by, :class_name => "User"

  validates_presence_of :name
  validates_presence_of :date
  validates_presence_of :contact_id
  validates_existence_of :contact

  def count_number(sym)
    self.disktest_batch_drives.select{|x| x.send(sym)}.length
  end

  def validate
    # TODO: validation if finalizing and any match this, count_number(:untested?) must be 0
  end

  def finalized?
    !! self.finalized_on
  end

  def mark_finalized
    self.user_finalized_by = Thread.current['cashier']
    self.finalized_on = Date.today
    self.disktest_batch_drives.each do |d|
      d.finalize_run
    end
  end
end
