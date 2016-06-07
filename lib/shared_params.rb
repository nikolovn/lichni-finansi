module SharedParams
  def self.expense_params(params)
    {
      income_category_id_eq: params[:income_category_id],
      income_transaction_id_eq: params[:income_transaction_id],
      expense_category_id_in: select_expense_subcategory(params),
      description_cont: params[:description],
      expense_type_cont: params[:expense_type]
    }.merge(date_params(params))
  end

  def self.income_params(params)
    {
      id_eq: params[:income_transaction_id],
      income_category_id_eq: params[:income_category_id],
      description_cont: params[:description]
    }.merge(date_params(params))
  end

  def self.select_expense_subcategory(params)
    if params[:expense_category_id].present?
      ExpenseCategory.find(params[:expense_category_id]).subtree_ids
    end
  end

  def self.date_params(params)
    {
      date_gteq: (params[:from_date] || Date.today.strftime("%m/%d/%Y")),
      date_lteq: (params[:to_date] || (Date.today - 1.year).strftime("%m/%d/%Y"))
    }
  end
end