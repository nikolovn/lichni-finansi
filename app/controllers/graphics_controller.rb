class GraphicsController < ApplicationController
  def index
    @categories_amounts = FinanceLmay.amount_on_each_categories
    @categories = []
    @amount = []
    @categories_amounts.each do |category_amount| 
      @categories << category_amount['name']
      @amount << category_amount['sum'].to_f/FinanceLmay.sum_amounts.to_f*100
    end
  end
end
