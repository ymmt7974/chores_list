require 'rails_helper'

describe User, type: :model do
  describe 'バリデーション' do

    it '名前、メール、パスワードがある場合、有効である' do
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end

    it '名前がない場合、無効である' do
      user = FactoryBot.build(:user, name: "")
      user.valid?
      expect(user.errors.full_messages).to include("アカウント名を入力してください")
    end
    it '重複した名前の場合、有効である' do
      user = FactoryBot.create(:user)
      another_user = FactoryBot.build(:user, email: "anothoer@email.com")
      expect(another_user).to be_valid
    end

    it 'メールアドレスがない場合、無効である' do
      user = FactoryBot.build(:user, email: "")
      user.valid?
      expect(user.errors.full_messages).to include("メールアドレスを入力してください")
    end
    it '重複したメールアドレスの場合、無効である' do
      user = FactoryBot.create(:user)
      another_user = FactoryBot.build(:user)
      another_user.valid?
      expect(another_user.errors.full_messages).to include("メールアドレスはすでに存在します")
    end

    it 'パスワードがない場合、無効である' do
      user = FactoryBot.build(:user, password: "")
      user.valid?
      expect(user.errors.full_messages).to include("パスワードを入力してください")
    end
    it 'パスワードが6文字未満の場合、無効である' do
      user = FactoryBot.build(:user, password: "12345")
      user.valid?
      expect(user.errors.full_messages).to include("パスワードは6文字以上で入力してください")
    end
  end

end