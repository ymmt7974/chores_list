
$(document).on('turbolinks:load', function() {

  // 日程が変更された時
  $('select[id="chore_date_type"]').change(function() {
    //選択したvalue値を変数に格納
    var val = $(this).val();
    date_type_all_hide();

    switch (val){
      case '1':
        $("#fg_chore_date").show();
        break;
      case '2':
        $("#fg_chore_start_date").show();
        $("#fg_chore_end_date").show();
        break;
      case '3':
        $("#fg_chore_wday").show();
        break;
      case '4':
        $("#fg_chore_mday").show();
        break;
      default:
    }
  });

  date_type_all_hide();
  $('select[id="chore_date_type"]').change();

});
function date_type_all_hide() {
  $("#fg_chore_date").hide();
  $("#fg_chore_start_date").hide();
  $("#fg_chore_end_date").hide();
  $("#fg_chore_wday").hide();
  $("#fg_chore_mday").hide();
}
function date_type_all_slideUp() {
  $("#fg_chore_date").slideUp("fast");
  $("#fg_chore_start_date").slideUp("fast");
  $("#fg_chore_end_date").slideUp("fast");
  $("#fg_chore_wday").slideUp("fast");
  $("#fg_chore_mday").slideUp("fast");
}

// 日付カレンダー
$(document).on('turbolinks:load', function() {
  // 指定日
  $('#dtp_date').datetimepicker({
      locale: 'ja',
      format: 'L'
  });
  // 開始日・終了日
  $('#dtp_start_date').datetimepicker({
    locale: 'ja',
    format: 'L'
  });
  $('#dtp_end_date').datetimepicker({
    locale: 'ja',
    format: 'L',
    useCurrent: false
  });
  $("#dtp_start_date").on("change.datetimepicker", function (e) {
      $('#dtp_end_date').datetimepicker('minDate', e.date);
  });
  $("#dtp_end_date").on("change.datetimepicker", function (e) {
      $('#dtp_start_date').datetimepicker('maxDate', e.date);
  });
});