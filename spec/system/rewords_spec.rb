require 'rails_helper'

RSpec.describe 'お手伝い記録', type: :system, js: true do
  let(:user_a) { FactoryBot.create(:user, name:'ユーザーA', email: 'a@test.com') }
  # let(:user_b) { FactoryBot.create(:user, name:'ユーザーB', email: 'b@test.com') }
  let!(:profile_admin) { FactoryBot.create(:profile, name:'管理者', user: user_a) }
  let!(:profile_kids) { FactoryBot.create(:profile, name:'キッズ', user: user_a) }

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

  end

    
end