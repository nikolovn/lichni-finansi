class GraphicsController < ApplicationController
  def index
    categories_amounts = FinanceLmay.amount_on_each_categories
    @categories_amounts =  categories_amounts.sort_by { |category_amount| -category_amount['sum'].to_i }
    @categories = []
    @amount = []
    @categories_amounts.each do |category_amount| 
      @categories << category_amount['name']
      @amount << category_amount['sum'].to_f/FinanceLmay.sum_amounts.to_f*100
    end
  end
end
