require 'rails_helper'

describe Chore, type: :model do
  describe 'バリデーション' do

    it 'お手伝い名、ポイント、日程、user_idがある場合、有効' do
      user = FactoryBot.create(:user)
      chore = Chore.new(name: "お手伝いA", point: 100, date_type: 0, user_id: user.id)
      expect(chore).to be_valid
    end

    describe '名前' do
      it '空白の場合、無効' do
        chore = FactoryBot.build(:chore, name: "")
        chore.valid?
        expect(chore.errors.full_messages).to include("お手伝い名を入力してください")
      end
      it '29文字の場合、有効' do
        chore = FactoryBot.build(:chore, name: "手" * 29)
        expect(chore).to be_valid
      end
      it '30文字の場合、有効' do
        chore = FactoryBot.build(:chore, name: "手" * 30)
        expect(chore).to be_valid
      end
      it '31文字の場合、無効' do
        chore = FactoryBot.build(:chore, name: "手" * 31)
        chore.valid?
        expect(chore.errors.full_messages).to include("お手伝い名は30文字以内で入力してください")
      end
      it '重複した名前がある場合、有効' do
        user = FactoryBot.create(:user)
        chore = Chore.new(name: "お手伝いA", point: 100, date_type: 0, user: user)
        another_chore = Chore.new(name: "お手伝いA", point: 200, date_type: 0, user: user)
        expect(another_chore).to be_valid
      end
    end

    describe '説明' do
      it '空白の場合、有効' do
        chore = FactoryBot.build(:chore, description: "")
        expect(chore).to be_valid
      end
      it '254文字の場合、有効' do
        chore = FactoryBot.build(:chore, description: "説" * 254)
        expect(chore).to be_valid
      end
      it '255文字の場合、有効' do
        chore = FactoryBot.build(:chore, description: "説" * 255)
        expect(chore).to be_valid
      end
      it '256文字の場合、無効' do
        chore = FactoryBot.build(:chore, description: "説" * 256)
        chore.valid?
        expect(chore.errors.full_messages).to include("説明は255文字以内で入力してください")
      end
    end
    describe 'ポイント' do
      it '空白の場合、無効' do
        chore = FactoryBot.build(:chore, point: nil)
        chore.valid?
        expect(chore.errors.full_messages).to include("獲得ポイントを入力してください")
      end
      it '0の場合、有効' do
        chore = FactoryBot.build(:chore, point: 0)
        expect(chore).to be_valid
      end
      it 'マイナスの場合、無効' do
        chore = FactoryBot.build(:chore, point: -1)
        chore.valid?
        expect(chore.errors.full_messages).to include("獲得ポイントは0以上の値にしてください")
      end
    end


    describe '日程' do
      let(:chore) { FactoryBot.build(:chore, date_type: date_type) }

      it '未設定の場合、無効' do
        chore = FactoryBot.build(:chore, date_type: nil)
        chore.valid?
        expect(chore.errors.full_messages).to include("日程を入力してください")
      end

      context '[毎日]の場合、指定日,開始日,終了日,曜日,毎月がないとき' do
        let(:date_type) { 0 }
        before do
          chore.date = nil
          chore.start_date = nil
          chore.end_date = nil
          chore.wday = nil
          chore.mday = nil
        end
        it '有効' do
          expect(chore).to be_valid
        end
      end
      context '[日付指定]' do
        let(:date_type) { 1 }
        it '指定日がある場合、有効である' do
          expect(chore).to be_valid
        end
        it '指定日がない場合、無効である' do
          chore.date = nil
          chore.valid?
          expect(chore.errors.full_messages).to include("指定日を入力してください")
        end
      end
      context '[範囲指定]' do
        let(:date_type) { 2 }
        it '開始日、終了日がある場合、有効である' do
          expect(chore).to be_valid
        end
        it '開始日がない場合、無効である' do
          chore.start_date = nil
          chore.valid?
          expect(chore.errors.full_messages).to include("開始日を入力してください")
        end
        it '終了日がない場合、無効である' do
          chore.end_date = nil
          chore.valid?
          expect(chore.errors.full_messages).to include("終了日を入力してください")
        end
        it '開始日、終了日がない場合、無効である' do
          chore.start_date = nil
          chore.end_date = nil
          chore.valid?
          expect(chore.errors.full_messages).to include("開始日を入力してください")
          expect(chore.errors.full_messages).to include("終了日を入力してください")
        end
        it '開始日、終了日の大小が逆の場合、無効である' do
          chore.start_date = "2020/10/05"
          chore.end_date = "2020/10/04"
          chore.valid?
          expect(chore.errors.full_messages).to include("終了日の日付を正しく記入して下さい。")
        end
      end
      context '[毎週]' do
        let(:date_type) { 3 }
        it '曜日がある場合、有効である' do
          expect(chore).to be_valid
        end
        it '曜日がないの場合、無効である' do
          chore.wday = nil
          chore.valid?
          expect(chore.errors.full_messages).to include("曜日を入力してください")
        end
      end
      context '[毎月]' do
        let(:date_type) { 4 }
        it '月の日がある場合、有効である' do
          expect(chore).to be_valid
        end
        it '月の日がないの場合、無効である' do
          chore.mday = nil
          chore.valid?
          expect(chore.errors.full_messages).to include("月の日を入力してください")
        end
      end

    end

  end
end