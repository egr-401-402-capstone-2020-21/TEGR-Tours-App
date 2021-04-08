class User < ApplicationRecord
  validates :email, :presence => true
  validates :password, :presence => true
  validates :password_confirmation, :presence => true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

  def admin?
  	return admin
  end
end
