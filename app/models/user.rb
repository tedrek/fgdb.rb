class User < ActiveRecord::Base
  acts_as_userstamp
  has_and_belongs_to_many "roles"

  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  before_save :encrypt_password

  belongs_to :contact

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation

  belongs_to :creator, :foreign_key => "created_by", :class_name => "User"
  belongs_to :updator, :foreign_key => "created_by", :class_name => "User"
  validates_existence_of :creator, {:allow_nil => true}
  validates_existence_of :updator, {:allow_nil => true}

  def merge_in(other)
    for i in [:actions, :donations, :sales, :spec_sheets, :systems, :types, :users, :volunteer_tasks, :contacts]
      User.connection.execute("UPDATE #{i.to_s} SET created_by = #{self.id} WHERE created_by = #{other.id}")
      User.connection.execute("UPDATE #{i.to_s} SET updated_by = #{self.id} WHERE updated_by = #{other.id}")
      self.roles = (self.roles + other.roles).uniq
      self.save!
    end
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  def has_role?(*roles)
    not (self.roles.map {|x| x.name } & (roles.map {|x| x.to_s} + ['ADMIN'])).empty?
  end

  protected
    # before filter
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end

    def password_required?
      crypted_password.blank? || !password.blank?
    end

end
