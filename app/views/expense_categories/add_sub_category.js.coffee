



$("#sub_category_link_<%= @category.id %>").html("<%= escape_javascript(render('hide_sub_category_link')) %>");
$("#<%= @category.id %>").html("<%= escape_javascript(render partial: 'form')) %>");