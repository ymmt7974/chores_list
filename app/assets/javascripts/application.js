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
//= require moment
//= require moment/ja.js
//= require tempusdominus-bootstrap-4.js
//= jquery.jpostal.js
//= require_tree .

$(document).on('turbolinks:load', function() {
  // flashメッセージスライドアップ
  setTimeout("$('.flash').slideUp('slow')", 2000);

  // マイナス値：赤
  $(".td-point:contains('-')").addClass('text-danger');
  $("#profile_point:contains('-')").addClass('text-danger');


  // 住所情報自動表示
	$('#user_postal_code').jpostal({
		postcode : [
			'#user_postal_code'
		],
    // 入力項目フォーマット
    //   %3  都道府県
    //   %4  市区町村
    //   %5  町域
    //   %6  大口事業所の番地
    //   %7  大口事業所の名称
		address : {
			'#user_address' : '%3%4%5'
		}
  });
  
  $("#user_postal_code").keyup();
  // 表示用
  $('#user_address_disp').html($('#user_address').val());
});

// 正規表現でセパレート
function separate(num){
  return String(num).replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,');
}
