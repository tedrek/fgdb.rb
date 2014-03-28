class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true

  validates :attachable, presence: true
  validate :attachable_responds_to_attachments
  validates :name, presence: true
  validates :content_type, presence: true

  before_destroy :destroy_file
  after_save :save_file

  def file
    File.open(filename, 'rb').read
  end

  def file=(uploaded)
    self.name = uploaded.original_filename
    self.content_type = uploaded.content_type
    @file = uploaded
  end

  def filename
    File.join(::Rails.root.to_s, 'public', 'attachments', sprintf('%06d', id))
  end

  private
  # Limit the classes which can have an attachment
  def attachable_responds_to_attachments
    if !attachable.respond_to? :attachments
      errors.add(:attachable, "Is not a valid type")
    end
  end

  def destroy_file
    File.unlink filename or raise "Unable to remove associated file"
  end

  def save_file
    if @file.nil? && !File.exists?(filename)
      raise "Unable to save attachment without a file"
    end

    unless @file.nil?
      File.open(filename, 'wb') do |f|
        f.write(@file.read)
      end
    end
  end
end
