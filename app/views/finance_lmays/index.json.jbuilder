json.array!(@finance_lmays) do |finance_lmay|
  json.extract! finance_lmay, :incomeexpense, :category, :description, :amount
  json.url finance_lmay_url(finance_lmay, format: :json)
end
