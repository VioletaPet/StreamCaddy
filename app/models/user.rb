class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :watch_providers, through: :user_providers
  validates :first_name, :last_name, presence: true
  validates :email, :username, uniqueness: true
end
