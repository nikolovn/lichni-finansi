$("#sub_category_link_<%= params[:id] %>").html("<%= escape_javascript(render('show_sub_category_link')) %>");

$("#<%= params[:id] %>").html("");