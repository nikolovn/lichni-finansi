class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :expense_transactions
  has_many :income_transactions
  has_many :expense_category
  has_many :income_category

  def admin?
    self.role == 'admin'
  end
end
