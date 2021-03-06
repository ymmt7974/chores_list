// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery
//= require popper
//= require bootstrap-sprockets
//= jquery.jpostal.js
//= require_tree .

$(document).on('turbolinks:load', function() {
  // flashメッセージスライドアップ
  setTimeout("$('.flash').slideUp('slow')", 3000);

  // マイナス値：赤
  $(".td-point:contains('-')").addClass('text-danger');
  $("#profile_point:contains('-')").addClass('text-danger');

});

// 正規表現でセパレート
function separate(num){
  return String(num).replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,');
}
