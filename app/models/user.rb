class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,:validatable
  has_many :books
  has_many :favorites
  has_many :book_comments
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverse_of_relationships, source: :user
  attachment :profile_image, destroy: false

  #バリデーションは該当するモデルに設定する。エラーにする条件を設定できる。
  validates :name, length: {maximum: 20, minimum: 2}
  validates :introduction, length: {maximum: 50}

    def follow(other_user)
      unless self == other_user
        self.relationships.find_or_create_by(follow_id: other_user.id)
      end
    end

    def unfollow(other_user)
      relationship = self.relationships.find_by(follow_id: other_user.id)
      relationship.destroy if relationship
    end

    def following?(other_user)
      self.followings.include?(other_user)
    end

    def self.search(method,word)
        if method == "forward_match"
            @users = User.where("name LIKE?","#{word}%") #nameカラムから検索
        elsif method == "backward_match"
            @users = User.where("name LIKE?","%#{word}")
        elsif method == "perfect_match"
            @users = User.where("name LIKE?","#{word}")
        elsif method == "partial_match"
            @users = User.where("name LIKE?","%#{word}%")
        else
            @users = User.all
        end
    end
end