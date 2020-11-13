require 'rails_helper'

RSpec.describe Point, type: :model do
  describe 'バリデーション' do

    it 'ポイント、イベント、プロフィールIDがある場合、有効' do
      profile = FactoryBot.create(:profile)
      point = Point.new(point: 100, event: 1, profile_id: profile.id)
      expect(point).to be_valid
    end

    it 'ポイントがない場合、無効' do
      point = FactoryBot.build(:point, point: nil)
      point.valid?
      expect(point.errors.full_messages).to include("ポイントを入力してください")
    end
    it 'イベントがない場合、無効' do
      point = FactoryBot.build(:point, event: nil)
      point.valid?
      expect(point.errors.full_messages).to include("イベントを入力してください")
    end
  end
end
