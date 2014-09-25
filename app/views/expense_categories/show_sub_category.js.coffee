$("#<%= 'sub_category_link' %>").html("<%= escape_javascript(render('hide_sub_category_link')) %>");
$("#<%= @expense_category.id %>").html("<%= escape_javascript(render('sub_category')) %>");