require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  let(:user) { create(:user) }

  describe 'ログイン前' do
    context 'フォームの入力値が正常' do
      example 'ログイン処理が成功する' do
        login_user = user
        visit login_path
        fill_in 'Email', with: login_user.email
        fill_in 'Password', with: 'test-password'
        click_button 'Login'
        expect(page).to have_content 'Login successful'
        expect(current_path).to eq root_path
      end
    end

    context 'フォームが未入力' do
      example 'ログイン処理が失敗する' do
        login_user = user
        visit login_path
        fill_in 'Email', with: nil
        fill_in 'Password', with: nil
        click_button 'Login'
        expect(page).to have_content 'Login failed'
        expect(current_path).to eq login_path
      end
    end
  end

  describe 'ログイン後' do
    context 'ログアウトボタンをクリック' do
      example 'ログアウト処理が成功する' do
        login_as(user)
        visit root_path
        click_link 'Logout'
        expect(page).to have_content 'Logged out'
        expect(current_path).to eq root_path
      end
    end
  end
end
