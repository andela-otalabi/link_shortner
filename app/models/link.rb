class Link < ActiveRecord::Base
  before_validation :generate_short_link, :on => :create
  validates :short_link, uniqueness: true
  validates :short_link, :original_link, presence: true
  scope :popularity, -> { order('visits desc') }
  # default_scope {order('created_at desc')}
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