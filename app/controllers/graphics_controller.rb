class GraphicsController < ApplicationController
  def index
   categories = Category.all
    categories_name = []
    categories.each do |category|
      categories_name << category.name
    end
    @categories_name = categories_name
  end
end
