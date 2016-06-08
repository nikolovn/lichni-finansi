class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :expense_transactions
  has_many :income_transactions
  has_many :expense_category
  has_many :income_category

  after_create do |user|
    create_expense_categories(user)
    create_income_categories(user)
  end

  def admin?
    self.role == 'admin'
  end

  def create_expense_categories(user)
    parent_category = ExpenseCategory.create!(user: user, name: 'Влогове, спестявания и инвестиции')
      ExpenseCategory.create!(user: user, name: 'вноски за доброволно пенсионно осигуряване', ancestry: parent_category.id)
      ExpenseCategory.create!(user: user, name: 'вноски за доброволно здравно осигуряване', ancestry: parent_category.id)
      ExpenseCategory.create!(user: user, name: 'депозит', ancestry: parent_category.id)
    parent_category = ExpenseCategory.create!(user: user, name: 'Данъци и такси')
      ExpenseCategory.create!(user: user, name: 'банкови такси', ancestry: parent_category.id)
      ExpenseCategory.create!(user: user, name: 'държавни такси', ancestry: parent_category.id)
    parent_category = ExpenseCategory.create!(user: user, name: 'Жилище и поддържане на дома')
      ExpenseCategory.create!(user: user, name: 'наем/ипотека', ancestry: parent_category.id)
      ExpenseCategory.create!(user: user, name: 'консумативи', ancestry: parent_category.id)
      ExpenseCategory.create!(user: user, name: 'ремонти', ancestry: parent_category.id)
    parent_category = ExpenseCategory.create!(user: user, name: 'Издръжка на децата')
      ExpenseCategory.create!(user: user, name: 'детска градина такса', ancestry: parent_category.id)
      ExpenseCategory.create!(user: user, name: 'играчки', ancestry: parent_category.id)
    parent_category = ExpenseCategory.create!(user: user, name: 'Лично потребление')
      ExpenseCategory.create!(user: user, name: 'джобни', ancestry: parent_category.id)
    parent_category = ExpenseCategory.create!(user: user, name: 'Облекло')
      ExpenseCategory.create!(user: user, name: 'дрехи и обувки', ancestry: parent_category.id)
    parent_category = ExpenseCategory.create!(user: user, name: 'Свободно време и образование')
      ExpenseCategory.create!(user: user, name: 'годишен отпуск', ancestry: parent_category.id)
      ExpenseCategory.create!(user: user, name: 'културни мероприятия', ancestry: parent_category.id)
      ExpenseCategory.create!(user: user, name: 'спорт', ancestry: parent_category.id)
    parent_category = ExpenseCategory.create!(user: user, name: 'Храна')
      ExpenseCategory.create!(user: user, name: 'храни и напитки', ancestry: parent_category.id)
      ExpenseCategory.create!(user: user, name: 'ресторанти', ancestry: parent_category.id)
   parent_category = ExpenseCategory.create!(user: user, name: 'Транспорт')
      ExpenseCategory.create!(user: user, name: 'поддръжка на автомобил', ancestry: parent_category.id)
      ExpenseCategory.create!(user: user, name: 'транспорт', ancestry: parent_category.id)

  end

  def create_income_categories(user)
    IncomeCategory.create!(user: user, name: 'Доходи от заплата')
    IncomeCategory.create!(user: user, name: 'Доходи от наем')
    IncomeCategory.create!(user: user, name: 'Доходи от инвестиции')
  end
end
