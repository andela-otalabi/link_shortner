class Link < ActiveRecord::Base
  before_validation :generate_short_link, :on => :create
  validates :short_link, uniqueness: true
  validates :short_link, :original_link, presence: true
  default_scope {order('created_at desc')}
  # scope :recent, -> {order('created_at desc').limit(5)}

  belongs_to :user

  def increment_visits
    self.update_attribute(:visits, visits + 1 )
  end

  private
  def generate_short_link
    begin
      random_chars = SecureRandom.urlsafe_base64(3)
      self.short_link = random_chars
    end while self.class.exists?(short_link: short_link)
  end
end