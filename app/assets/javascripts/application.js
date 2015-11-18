// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require jquery.purr
//= require best_in_place
//= require_tree 
//= require bootstrap-datepicker

$(document).ready(function () {
  $(".collapsed.glyphicon.glyphicon-plus").one("click", show_minus);
});

 function show_minus() {
    var id = '#' + $(this).prop('id');
    $(id).removeClass('glyphicon glyphicon-plus').addClass('glyphicon glyphicon-minus');
    $(this).one("click", show_plus);
  };

function show_plus() {
    var id = '#' + $(this).prop('id');
    $(id).removeClass('glyphicon glyphicon-minus').addClass('glyphicon glyphicon-plus');
    $(this).one("click", show_minus);
  };