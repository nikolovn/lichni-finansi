module StatisticsHelper
  def number_to_currency_bgn(amount)
    number_to_currency(amount, unit: 'лв.', separator: ",", delimiter: "", format: "%n %u")
  end
end
