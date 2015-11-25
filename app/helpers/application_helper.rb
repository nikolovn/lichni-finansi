module ApplicationHelper
  def active_class?(*paths)
    active = false
    paths.each { |path| active ||= current_page?(path) }
    active ? 'active' : nil
  end

  def options_for_expense_category(expense_categories)
    expense_categories.each { |c| c.ancestry = c.ancestry.to_s + (c.ancestry != nil ? "/" : '') + c.id.to_s 
      }.sort {|x,y| x.ancestry <=> y.ancestry 
      }.map{ |c| ["-" * (c.depth - 1) + c.name,c.id] 
      }.unshift(["-- none --", nil])
  end
end
