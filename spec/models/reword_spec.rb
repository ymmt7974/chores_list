require 'rails_helper'

RSpec.describe Reword, type: :model do
  describe 'バリデーション' do

    it '商品名、説明、必要ポイント、ユーザーIDがある場合、有効' do
      user = FactoryBot.create(:user)
      reword = Reword.new(name: "交換品A", description: "１" * 255, cost_point: 100, user_id: user.id)
      expect(reword).to be_valid
    end

    it '名前がない場合、無効' do
      reword = FactoryBot.build(:reword, name: "")
      reword.valid?
      expect(reword.errors.full_messages).to include("商品名を入力してください")
    end
    it '名前が30文字を超えた場合、無効' do
      reword = FactoryBot.build(:reword, name: "品" * 31 )
      reword.valid?
      expect(reword.errors.full_messages).to include("商品名は30文字以内で入力してください")
    end
    it '説明が255文字を超えた場合、無効' do
      reword = FactoryBot.build(:reword, description: "説" * 256 )
      reword.valid?
      expect(reword.errors.full_messages).to include("説明は255文字以内で入力してください")
    end
    it '必要ポイントがない場合、無効' do
      reword = FactoryBot.build(:reword, cost_point: nil)
      reword.valid?
      expect(reword.errors.full_messages).to include("必要ポイントを入力してください")
    end
  end
end
