require 'rails_helper'

RSpec.describe 'お手伝い記録', type: :system, js: true do
  let(:user_a) { FactoryBot.create(:user, :with_profiles) }
  let!(:point_kids) { FactoryBot.create(:point, point: 1000, profile: user_a.profiles.find_by(name: "キッズ")) }
  let!(:reword_a) { FactoryBot.create(:reword, name:'ご褒美A', description: 'ご褒美Aの説明', 
                                      cost_point: 100, user: user_a) }
  let!(:reword_b) { FactoryBot.create(:reword, name:'ご褒美B', description: 'ご褒美Bの説明', 
                                      cost_point: 200, user: user_b) }

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