require 'rails_helper'

describe Chore, type: :model do
  describe 'バリデーション' do

    it 'お手伝い名、ポイント、日程、userがある場合、有効である' do
      user = FactoryBot.create(:user)
      chore = Chore.new(name: "お手伝いA", point: 100, date_type: 0, user: user)
      expect(chore).to be_valid
    end

    it '名前がない場合、無効である' do
      chore = FactoryBot.build(:chore, name: "")
      chore.valid?
      expect(chore.errors.full_messages).to include("お手伝い名を入力してください")
    end
    it '重複した名前の場合、有効である' do
      user = FactoryBot.create(:user)
      chore = Chore.new(name: "お手伝いA", point: 100, date_type: 0, user: user)
      another_chore = Chore.new(name: "お手伝いA", point: 200, date_type: 2, user: user)
      expect(another_chore).to be_valid
    end

    it 'ポイントがない場合、無効である' do
      chore = FactoryBot.build(:chore, point: nil)
      chore.valid?
      expect(chore.errors.full_messages).to include("獲得ポイントを入力してください")
    end

    it '日程がない場合、無効である' do
      chore = FactoryBot.build(:chore, date_type: nil)
      chore.valid?
      expect(chore.errors.full_messages).to include("日程を入力してください")
    end

  end
end