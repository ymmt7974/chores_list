require 'rails_helper'

describe 'お手伝いリスト管理', type: :system do
  let(:user_a) { FactoryBot.create(:user, name:'ユーザーA', email: 'a@test.com') }
  let(:user_b) { FactoryBot.create(:user, name:'ユーザーB', email: 'b@test.com') }
  let!(:chore_a) { FactoryBot.create(:chore, name:'最初のお手伝い', user: user_a) }
  let!(:profile) { FactoryBot.create(:profile, name:'管理者', user: login_user) }

  before do
    # ログイン
    visit new_user_session_path
    fill_in 'user[email]', with: login_user.email
    fill_in 'user[password]', with: login_user.password
    click_button 'ログイン'
    click_on '管理者'
    visit chores_path
  end

  shared_examples_for 'ユーザーAが作成したお手伝い情報が表示される' do
    # 作成済みのお手伝い情報の名称が画面上に表示されていることを確認
    it { expect(page).to have_content '最初のお手伝い' }
  end

  describe '一覧表示機能' do

    context 'ユーザーAがログインしているとき' do
      let(:login_user) { user_a }

      it_behaves_like 'ユーザーAが作成したお手伝い情報が表示される'
    end

    context 'ユーザーBがログインしているとき' do
      let(:login_user) { user_b }

      it 'ユーザーAが作成したお手伝い情報が表示されない' do
        expect(page).to have_no_content '最初のお手伝い'
      end
    end
  end

  describe '詳細表示機能' do
    context 'ユーザーAがログインしているとき' do
      let(:login_user) { user_a }
      before do
        visit chore_path(chore_a)
      end
      
      it_behaves_like 'ユーザーAが作成したお手伝い情報が表示される'
    end
  end

  describe '新規作成機能' do
    let(:login_user) { user_a }

    before do
      visit new_chore_path
      fill_in 'chore[name]', with: chore_name
      fill_in 'chore[point]', with: 100
      select '毎日', from: "chore[date_type]"
      click_button '登録'
    end
    context '新規作成画面でお手伝い名を入力したとき' do
      let(:chore_name) { '新規お手伝い' }
      it '正常に登録される' do
        expect(page).to have_selector '.alert-success', text: chore_name
        # page.save_screenshot "tmp/capybara/screenshot#{Time.now.strftime("%Y%m%d%H%M%S")}.png"  
      end
    end
    context '新規作成画面でお手伝い名を入力しなかったとき' do
      let(:chore_name) { '' }
      it 'エラーとなる' do
        within '#error_explanation' do
          expect(page).to have_content 'お手伝い名を入力してください'
        end
      end
    end
  end

  describe '編集機能' do
    let(:login_user) { user_a }

    before do
      visit edit_chore_path(chore_a)
      fill_in 'chore[name]', with: chore_name
      click_button '更新'
    end
    context '編集画面でお手伝い名を変更したとき' do
      let(:chore_name) { '２つ目のお手伝い' }
      it '正常に更新される' do
        expect(page).to have_selector '.alert-success', text: chore_name
      end
    end
    context '新規作成画面でお手伝い名を空白に変更したとき' do
      let(:chore_name) { '' }
      it 'エラーとなる' do
        within '#error_explanation' do
          expect(page).to have_content 'お手伝い名を入力してください'
        end
      end
    end
  end

  describe '削除機能', js: true do
    let(:login_user) { user_a }

    describe '詳細画面' do
      before do
        visit chore_path(chore_a)
      end
      context '削除ボタンを押したとき' do
        it 'confirmダイアログが表示される' do
          click_on '削除'
          expect(page.driver.browser.switch_to.alert.text).to have_content chore_a.name
          page.driver.browser.switch_to.alert.dismiss
        end
        it 'OK:正常に削除される' do
          page.accept_confirm do
            click_on '削除'
          end
          expect(page).to have_selector '.alert-success', text: chore_a.name
          visit chores_path
          expect(page).to have_no_content chore_a.name
        end
        it 'キャンセル:削除されない' do
          page.dismiss_confirm do
            click_on '削除'
          end
          visit chores_path
          expect(page).to have_content chore_a.name
        end
      end
    end
    describe '一覧画面' do
      before do
        visit chores_path
      end
      context '削除ボタンを押したとき' do
        it 'confirmダイアログが表示される' do
          page.first(".fa-trash").click
          expect(page.driver.browser.switch_to.alert.text).to have_content chore_a.name
          page.driver.browser.switch_to.alert.dismiss
        end
        it 'OK:正常に削除される' do
          page.accept_confirm do
            page.first(".fa-trash").click
          end
          expect(page).to have_selector '.alert-success', text: chore_a.name
          visit chores_path
          expect(page).to have_no_content chore_a.name
        end
        it 'キャンセル:削除されない' do
          page.dismiss_confirm do
            page.first(".fa-trash").click
          end
          visit chores_path
          expect(page).to have_content chore_a.name
        end
      end
    end
  end
end