module ChoresHelper

  # 日程を編集して返す
  def format_date_type(chore)
    case chore.date_type
    when Chore.date_types[:all_day]
      I18n.t("enum.date_types.#{Chore.date_types.key(chore.date_type)}")
    when Chore.date_types[:target]
      I18n.l(chore.date)
    when Chore.date_types[:range]
      "#{I18n.l(chore.start_date)} 〜 #{I18n.l(chore.end_date)}"
    when Chore.date_types[:day_of_week]
      day_name = Chore.day_names.key(chore.day_of_week)
      Chore.human_attribute_name(:day_of_week) + I18n.t("enum.day_names.#{day_name}")
    when Chore.date_types[:day_of_month]
      Chore.human_attribute_name(:day_of_month) + " #{chore.day_of_month}日"
    end
  end
end
