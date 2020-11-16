require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe 'バリデーション' do
    it 'お手伝い名、user_idがある場合、有効' do
      user = FactoryBot.create(:user)
      profile = Profile.new(name: "プロフィールA", user_id: user.id)
      expect(profile).to be_valid
    end

    describe '名前' do
      it '空白の場合、無効' do
        profile = FactoryBot.build(:profile, name: "")
        profile.valid?
        expect(profile.errors.full_messages).to include("名前を入力してください")
      end
      it '29文字の場合、有効' do
        profile = FactoryBot.build(:profile, name: "プ" * 29)
        expect(profile).to be_valid
      end
      it '30文字の場合、有効' do
        profile = FactoryBot.build(:profile, name: "プ" * 30)
        expect(profile).to be_valid
      end
      it '31文字の場合、無効' do
        profile = FactoryBot.build(:profile, name: "プ" * 31)
        profile.valid?
        expect(profile.errors.full_messages).to include("名前は30文字以内で入力してください")
      end
    end
  end
end
