class Link < ActiveRecord::Base
  before_validation :generate_short_link, :on => :create

  VALID_URL_REGEX = /((http|https)\:\/\/)?[a-zA-Z0-9\.\/\?\:@\-_=#]+\.([a-zA-Z0-9\.\/\?\:@\-_=#])*/
  validates :original_link, presence: true, 
            format: { with: VALID_URL_REGEX }
  validates :short_link, uniqueness: true, presence: true
  scope :popularity, -> { order('visits desc') }
  scope :most_recent, -> { order('created_at desc') } 
  scope :anonymous_links, -> { where(user_id: nil) }

  belongs_to :user
  has_many :clicks

  def increment_visits
    self.increment!(:visits)
  end

  private
  def generate_short_link
    begin
      random_chars = SecureRandom.urlsafe_base64(3)
      self.short_link = random_chars
    end while self.class.exists?(short_link: short_link)
  end
end