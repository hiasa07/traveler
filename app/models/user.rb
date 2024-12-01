class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy 
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following_user, through: :follower, source: :followed
  has_many :follower_user, through: :followed, source: :follower
  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id"
  has_many :received_messages, class_name: "Message", foreign_key: "receiver_id"
  # フォローしているユーザーを取得する関連付け
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id"
  has_many :following, through: :active_relationships, source: :followed
  # フォローされているユーザーを取得する関連付け
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id"
  has_many :followers, through: :passive_relationships, source: :follower
  
  attachment :profile_image

   # ユーザーをフォローする
   def follow(user_id)
    follower.create(followed_id: user_id)
  end

  # ユーザーのフォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  # フォローしていればtrueを返す
  def following?(user)
    following_user.include?(user)
  end  

  # 相互フォローかどうか確認するメソッド
  def mutual_follow?(other_user)
    self.following.include?(other_user) && self.followers.include?(other_user)
  end

  validates :name, presence: true
end
