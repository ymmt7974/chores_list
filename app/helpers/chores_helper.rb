module ChoresHelper

  # 日程を編集して返す
  def format_date_type(chore)
    case chore.date_type
    when Chore.date_types[:all_day]
      Chore.date_types_i18n[Chore.date_types.key(chore.date_type)]
    when Chore.date_types[:target]
      I18n.l(chore.date)
    when Chore.date_types[:range]
      "#{I18n.l(chore.start_date)} 〜 #{I18n.l(chore.end_date)}"
    when Chore.date_types[:day_of_week]
      return "" unless chore.wday
      day_name = Chore.day_names.key(chore.wday)
      Chore.human_attribute_name(:wday) + Chore.day_names_i18n[day_name]
    when Chore.date_types[:day_of_month]
      return "" unless chore.mday
      Chore.human_attribute_name(:mday) + " #{chore.mday}日"
    end
  end
end
