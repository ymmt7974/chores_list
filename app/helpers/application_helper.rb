module ApplicationHelper

  # ページごとの完全なタイトルを返す
  def full_title(page_title = '')
    base_title = "ChoresList"
    if page_title.empty? 
      base_title
    else 
      base_title + " | " +  page_title
    end
  end


  # デバイスのエラーメッセージ出力メソッド
  def bootstrap_devise_error_messages!
    return "" if resource.errors.empty?
    html = ""
    html += <<-EOF
    <div id="error_explanation">
      <div class="alert alert-danger alert-dismissible" role="alert">
        <button type="button" class="close" data-dismiss="alert">
          <span aria-hidden="true">&times;</span>
          <span class="sr-only">close</span>
        </button>
        入力値を確認してください（#{pluralize(resource.errors.count, "error")}）
        <ul>
    EOF
    # エラーメッセージ用のHTMLを生成
    messages = resource.errors.full_messages.each do |msg|
      html += <<-EOF
        <li>#{msg}</li>
      EOF
    end
    html += "</ul></div></div>"
    html.html_safe
  end

end
