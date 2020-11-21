require 'rails_helper'

RSpec.describe 'お手伝い記録', type: :system, js: true do
  let(:user_a) { FactoryBot.create(:user, name:'ユーザーA', email: 'a@test.com') }
  # let(:user_b) { FactoryBot.create(:user, name:'ユーザーB', email: 'b@test.com') }
  let!(:profile_admin) { FactoryBot.create(:profile, name:'管理者', user: user_a) }
  let!(:profile_kids) { FactoryBot.create(:profile, name:'キッズ', user: user_a) }
  let!(:chore_a) { FactoryBot.create(:chore, name:'未記録のお手伝い', user: user_a) }
  let!(:chore_b) { FactoryBot.create(:chore, name:'記録済のお手伝い', user: user_a) }
  let!(:chore_record_b) { FactoryBot.create(:chore_record, actual_date: Time.current, profile: profile_kids, chore: chore_b) }

  let(:login_user) { user_a }

  before do
    # ログイン
    visit new_user_session_path
    fill_in 'user[email]', with: login_user.email
    fill_in 'user[password]', with: login_user.password
    click_button 'ログイン'
    click_on 'キッズ'
  end

  describe '一覧表示機能' do

    describe 'HOME画面表示' do
      before do
        visit root_path
      end
      it '「未記録のお手伝い」が表示されている' do
        expect(all('tbody tr')[0]).to have_content '未記録のお手伝い'
      end
      it '「記録済のお手伝い」が表示されている' do
        expect(all('tbody tr')[1]).to have_content '記録済のお手伝い'
        expect(all('tbody tr')[1]).to have_content '完了'
        expect(all('tbody tr')[1]).to have_content 'キッズ'
      end

    end
    describe 'お手伝い情報画面表示' do
      before do
        visit root_path
      end
      context '[未記録のお手伝い]' do
        it 'お手伝い履歴0件' do
          expect(page).to have_link '未記録のお手伝い', href: chore_path(chore_a)
          all('tbody tr')[0].click_link '未記録のお手伝い'

          expect(current_path).to eq chore_path(chore_a)
          expect(all('table.chore_records tbody').count).to eq 0
        end
      end
      context '[記録済のお手伝い]' do
        it 'お手伝い履歴1件' do
          expect(page).to have_link '記録済のお手伝い', href: chore_path(chore_b)
          all('tbody tr')[1].click_link '記録済のお手伝い'

          expect(current_path).to eq chore_path(chore_b)
          expect(all('table.chore_records tbody').count).to eq 1
        end
      end
    end
  end

  describe 'お手伝い記録機能' do
    describe 'HOME画面表示' do
      before do
      end
      context 'モーダル[未記録のお手伝い]' do
        it '記録ボタン押下で完了' do
          expect(page).to have_no_selector "#choreModal-#{chore_a.id}"

          all('tbody tr')[0].click_link nil, href: '#'
          expect(page).to have_selector "#choreModal-#{chore_a.id}"
          expect(page).to have_selector 'h1', text: '未記録のお手伝い'
          expect(page).to have_field "choreModal_date-#{chore_a.id}", with: Time.current.strftime("%F")
          expect(page).to have_field "choreModal_comment-#{chore_a.id}", with: ""

          click_button '記録'

          expect(page).to have_no_selector "#choreModal-#{chore_a.id}"
          expect(all('tbody tr')[0]).to have_content '完了'
          expect(all('tbody tr')[0]).to have_content 'キッズ'

          # 管理者で記録
          visit profiles_path
          click_on '管理者'
          all('tbody tr')[0].click_link nil, href: '#'
          click_button '記録'

          expect(page).to have_no_selector "#choreModal-#{chore_a.id}"
          expect(all('tbody tr')[0]).to have_content '完了'
          expect(all('tbody tr')[0]).to have_content 'キッズ,管理者'
        end

        it '実施日未入力で失敗' do
          all('tbody tr')[0].click_link nil, href: '#'
          expect(page).to have_selector "#choreModal-#{chore_a.id}"

          fill_in "choreModal_date-#{chore_a.id}", with: nil
          click_button '記録'

          expect(page).to have_selector "#choreModal-#{chore_a.id}"
          expect(all('tbody tr')[0]).to have_no_content '完了'
          expect(all('tbody tr')[0]).to have_no_content 'キッズ'
          
        end

        # it '×ボタン押下でキャンセル' do
        #   all('tbody tr')[0].click_link nil, href: '#'
        #   expect(page).to have_selector "#choreModal-#{chore_a.id}"

        #   click_on '×'
          
        #   expect(all('tbody tr')[0]).to have_no_content '完了'
        #   expect(all('tbody tr')[0]).to have_no_content 'キッズ'
        #   expect(page).to have_no_selector "#choreModal-#{chore_a.id}"
        # end

        # it '閉じるボタン押下でキャンセル' do
        #   all('tbody tr')[0].click_link nil, href: '#'
        #   expect(page).to have_selector "#choreModal-#{chore_a.id}"

        #   click_button '閉じる'

        #   expect(all('tbody tr')[0]).to have_no_content '完了'
        #   expect(all('tbody tr')[0]).to have_no_content 'キッズ'
        #   expect(page).to have_no_selector "#choreModal-#{chore_a.id}"
        # end
      end
      context 'モーダル[記録済のお手伝い]' do
        it '記録ボタン押下で完了' do
          expect(page).to have_no_selector "#choreModal-#{chore_b.id}"

          all('tbody tr')[1].click_link nil, href: '#'
          expect(page).to have_selector "#choreModal-#{chore_b.id}"
          expect(page).to have_selector 'h1', text: '記録済のお手伝い'
          expect(page).to have_field "choreModal_date-#{chore_b.id}", with: Time.current.strftime("%F")
          expect(page).to have_field "choreModal_comment-#{chore_b.id}", with: ""

          click_button '記録'

          expect(page).to have_no_selector "#choreModal-#{chore_b.id}"
          expect(all('tbody tr')[1]).to have_content '完了'
          expect(all('tbody tr')[1]).to have_content 'キッズ,キッズ'
        end
      end
    end

  end

  describe 'お手伝い記録編集機能' do

  end
    
end