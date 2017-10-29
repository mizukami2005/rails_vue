class Micropost < ActiveRecord::Base
  CONTENT_MAX = 140

  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  before_create :add_reply_to_user_id
  mount_uploader :picture, PictureUploader
  # validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: CONTENT_MAX }
  validate  :picture_size

  # マイクロポストのreply_toカラムに返信先ユーザーidを入れる
  def add_reply_to_user_id
    if /@[\w]+/ =~ content
      if (reply_to_user = User.find_by(screen_name: $&.delete("@")))
        self.reply_to_user_id = reply_to_user.id
      end
    end
  end

  private

  # アップロード画像のサイズを検証する
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

end

