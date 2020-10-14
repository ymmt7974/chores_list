$(document).on('turbolinks:load', function() {
  //郵便番号にハイフンを自動挿入するメソッド
  function insertStr(input){
    return input.slice(0, 3) + '-' + input.slice(3,input.length);
  }

  //入力時に郵便番号に自動でハイフンを付けるイベント
  $("#user_postal_code").on('keyup',function(e){
    var input = $(this).val();

    //削除キーではハイフン追加処理が働かないように制御（8がBackspace、46がDelete)
    var key = event.keyCode || event.charCode;
    if( key == 8 || key == 46 ){
      return false;
    }

    //３桁目に値が入ったら発動
    if(input.length === 3){
      $(this).val(insertStr(input));
    }
  });

  //フォーカスが外れた際、本当に4桁目に'-'がついているかチェック。なければ挿入するイベント
  //これでコピペした場合にも対応可能？
  $("#user_postal_code").on('blur',function(e){
    var input = $(this).val();

    //４桁目が'-(ハイフン)’かどうかをチェックし、違ったら挿入
    if(input.length >= 3 && input.substr(3,1) !== '-'){
      $(this).val(insertStr(input));
    }
  });


  // 住所情報自動表示
	$('#user_postal_code').jpostal({
		postcode : [
			'#user_postal_code'
		],
		address : {
			'#user_address' : '%3%4%5'
		}
  });
  
  // 初期表示：発火
  $("#user_postal_code").keyup();
  $("#user_postal_code").blur();
});
