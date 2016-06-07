module Statistics
  module Graphics
    require 'color-generator'

    def graphics_income_transactions(income_categories_hash, title)
      generator = ColorGenerator.new saturation: 1, lightness: 0.75
      colors = income_categories_hash.map {|expense_category| generator.create_hex}
      
      Gchart.pie_3d({
          :title => title, 
          :size => '500x300',
          :data => income_categories_hash.map {|income_category| income_category[:amount] },
          :legend => income_categories_hash.map {|income_category| income_category[:income_category] },
          :bg => {:color => 'ffffff', :type => 'stripes'}, 
          :bar_colors => colors,
      })
    end

    def graphics_expense_category(expense_categories_hash, title)
      generator = ColorGenerator.new saturation: 1, lightness: 0.75
      colors = expense_categories_hash.map {|expense_category| generator.create_hex}

      Gchart.pie_3d({
            :title => title, 
            :size => '500x300',
            :data => expense_categories_hash.map {|expense_category| expense_category[:amount] }, 
            :legend => expense_categories_hash.map {|expense_category| expense_category[:name] },
            :bg => {:color => 'ffffff', :type => 'stripes'}, 
            :bar_colors => colors
      })
    end

    def graphics_balance(graphics_balance_category_hash, title, income_legend, expense_legend)
      generator = ColorGenerator.new saturation: 1, lightness: 0.75
      colors = graphics_balance_category_hash.map {|expense_category| generator.create_hex}

      Gchart.pie_3d({
            :title => title, 
            :size => '400x200',
            :data => graphics_balance_category_hash.values.shift(2).map {|balance| balance.amount}, 
            :legend => [income_legend, expense_legend],
            :bg => {:color => 'ffffff', :type => 'stripes'}, 
            :bar_colors => colors
      })
    end
   
    def graphics_expense_type(graphics_expense_type_hash, title, legend)
      generator = ColorGenerator.new saturation: 1, lightness: 0.75
      colors = graphics_expense_type_hash.map {|expense_category| generator.create_hex}

      Gchart.pie_3d({
            :title => title, 
            :size => '400x200',
            :data => graphics_expense_type_hash.values.map {|expense_type| expense_type.amount}, 
            :legend => legend,
            :bg => {:color => 'ffffff', :type => 'stripes'}, 
            :bar_colors => colors
      })
    end

    def graphics_expense_by_date(expense_by_date_hash, title)
      generator = ColorGenerator.new saturation: 1, lightness: 0.75
      colors = expense_by_date_hash.map {|expense_category| generator.create_hex}

      Gchart.line({
            :title => title, 
            :size => '800x200',
            :data => expense_by_date_hash.map {|hash| hash[:amount].amount}, 
            :labels => expense_by_date_hash.map {|hash| hash[:date]},
            :bg => {:color => 'ffffff', :type => 'stripes'}, 
            :bar_colors => colors
      })
    end

    def graphics_expense_by_month(expense_by_month_hash, title, legend)
      generator = ColorGenerator.new saturation: 1, lightness: 0.75
      colors = expense_by_month_hash.map {|expense_category| generator.create_hex}

      Gchart.line({
            :title => title, 
            :size => '800x200',
            :data => [expense_by_month_hash[:income_amount], expense_by_month_hash[:expense_amount]], 
            :legend => legend,
            :labels => expense_by_month_hash[:income_date],
            :bar_colors => colors
      })
    end

    def graphics_expense_by_category_by_month(expense_by_category_by_month_hash, title)
      generator = ColorGenerator.new saturation: 1, lightness: 0.75
      colors = expense_by_category_by_month_hash.map {|expense_category| generator.create_hex}
      
      Gchart.line({
            :title => title, 
            :size => '800x300',
            :data => expense_by_category_by_month_hash.map {|income| income[:expense].map {|expense| expense[:expense_category_amount]}}, 
            :legend => expense_by_category_by_month_hash.map {|income| income[:parent_category_id]},
            :labels => expense_by_category_by_month_hash.map {|income| income[:expense].map {|expense| expense[:income_transaction_date]}}.flatten.uniq,
            :bar_colors => colors
      })
    end


    module_function :graphics_income_transactions
    module_function :graphics_expense_category
    module_function :graphics_balance
    module_function :graphics_expense_type
    module_function :graphics_expense_by_date
    module_function :graphics_expense_by_month
    module_function :graphics_expense_by_category_by_month
  end
end