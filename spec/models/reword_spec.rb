require 'rails_helper'

RSpec.describe Reword, type: :model do
  describe 'バリデーション' do

    it '商品名、説明、必要ポイント、ユーザーIDがある場合、有効' do
      user = FactoryBot.create(:user)
      reword = Reword.new(name: "交換品A", description: "１" * 255, cost_point: 100, user_id: user.id)
      expect(reword).to be_valid
    end

    describe '名前' do
      it '空白の場合、無効' do
        reword = FactoryBot.build(:reword, name: "")
        reword.valid?
        expect(reword.errors.full_messages).to include("商品名を入力してください")
      end
      it '29文字の場合、有効' do
        reword = FactoryBot.build(:reword, name: "品" * 29)
        expect(reword).to be_valid
      end
      it '30文字の場合、有効' do
        reword = FactoryBot.build(:reword, name: "品" * 30)
        expect(reword).to be_valid
      end
      it '31文字の場合、無効' do
        reword = FactoryBot.build(:reword, name: "品" * 31)
        reword.valid?
        expect(reword.errors.full_messages).to include("商品名は30文字以内で入力してください")
      end
    end
    describe '説明' do
      it '空白の場合、有効' do
        reword = FactoryBot.build(:reword, description: "")
        expect(reword).to be_valid
      end
      it '254文字の場合、有効' do
        reword = FactoryBot.build(:reword, description: "説" * 254)
        expect(reword).to be_valid
      end
      it '255文字の場合、有効' do
        reword = FactoryBot.build(:reword, description: "説" * 255)
        expect(reword).to be_valid
      end
      it '256文字の場合、無効' do
        reword = FactoryBot.build(:reword, description: "説" * 256)
        reword.valid?
        expect(reword.errors.full_messages).to include("説明は255文字以内で入力してください")
      end
    end
    describe '必要ポイント' do
      it '空白の場合、無効' do
        reword = FactoryBot.build(:reword, cost_point: nil)
        reword.valid?
        expect(reword.errors.full_messages).to include("必要ポイントを入力してください")
      end
      it '0の場合、有効' do
        reword = FactoryBot.build(:reword, cost_point: 0)
        expect(reword).to be_valid
      end
      it 'マイナスの場合、無効' do
        reword = FactoryBot.build(:reword, cost_point: -1)
        reword.valid?
        expect(reword.errors.full_messages).to include("必要ポイントは0以上の値にしてください")
      end
    end
  end
end
