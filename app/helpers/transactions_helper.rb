module TransactionsHelper

  def add_transaction_link(name)
     link_to_function name, nil do |page|
      p "test"
      #page.insert_html :bottom, :transactions, :partial => 'transactions/form', :object => Transaction.new
     end
  end
end