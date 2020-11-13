require 'rails_helper'

RSpec.describe ChoreRecord, type: :model do

  describe 'バリデーション' do

    it '実施日、外部キー（お手伝いID、プロフィールID）がある場合、有効' do
      chore = FactoryBot.create(:chore)
      profile = FactoryBot.create(:profile)
      chore_record = ChoreRecord.new(actual_date: "2020/01/01", chore_id: chore.id, profile_id: profile.id)
      expect(chore_record).to be_valid
    end

    it '実施日がない場合、無効' do
      chore_record = FactoryBot.build(:chore_record, actual_date: nil)
      chore_record.valid?
      expect(chore_record.errors.full_messages).to include("実施日を入力してください")
    end
    it '外部キー（お手伝いID）がない場合、無効' do
      chore_record = FactoryBot.build(:chore_record, chore: nil)
      chore_record.valid?
      expect(chore_record.errors.full_messages).to include("Choreを入力してください")
    end
    it '外部キー（プロフィールID）がない場合、無効' do
      chore_record = FactoryBot.build(:chore_record, profile: nil)
      chore_record.valid?
      expect(chore_record.errors.full_messages).to include("Profileを入力してください")
    end
  end
end
