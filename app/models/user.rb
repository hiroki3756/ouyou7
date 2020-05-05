class User < ApplicationRecord
  include JpPrefecture
jp_prefecture :prefecture_code  #prefecture_codeはuserが持っているカラム

#postal_codeからprefecture_nameに変換するメソッドを用意します．
def prefecture_name
  JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
end
  
def prefecture_name=(prefecture_name)
  self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
end
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,:validatable
  has_many :books
  attachment :profile_image, destroy: false

  #バリデーションは該当するモデルに設定する。エラーにする条件を設定できる。
  validates :name, presence: true
  validates :name, length: {maximum: 20, minimum: 2}
  validates :introduction, length: { maximum: 50 }

  geocoded_by :city
  after_validation :geocode

end
