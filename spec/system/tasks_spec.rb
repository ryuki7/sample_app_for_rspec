require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:user) { create(:user) }
  let(:task) { create(:task, user: user) }

  describe 'ログイン前' do
    describe 'ページ遷移確認' do
      context 'タスクの新規作成ページにアクセス' do
        example '新規作成ページへのアクセスが失敗する' do
          visit new_task_path
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end
    
      context 'タスクの編集ページにアクセス' do
        example '編集ページへのアクセスが失敗する' do
          visit edit_task_path(task)
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login_as(user) }

    describe 'タスク新規作成' do
      context 'フォームの入力値が正常' do
        example 'タスクの新規作成が成功する' do
          visit new_task_path
          fill_in 'Title', with: 'test-title'
          fill_in 'Content', with: 'test-content'
          select 'todo', from: 'Status'
          fill_in 'Deadline', with: DateTime.new(2021, 2, 15, 7, 50)
          click_button 'Create Task'
          new_task = user.tasks.find(1)
          expect(page).to have_content 'Task was successfully created.'
          expect(page).to have_content 'Title: test-title'
          expect(page).to have_content 'Content: test-content'
          expect(page).to have_content 'Status: todo'
          expect(page).to have_content 'Deadline: 2021/2/15 7:50'
          expect(current_path).to eq task_path(new_task)
        end
      end

      context 'タイトルが未入力' do
        example 'タスクの新規作成が失敗する' do
          visit new_task_path
          fill_in 'Title', with: nil
          fill_in 'Content', with: 'test-content'
          select 'todo', from: 'Status'
          click_button 'Create Task'
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content "Title can't be blank"
          expect(page).not_to have_content 'Content: test-content'
          expect(current_path).to eq tasks_path
        end
      end

      context '登録済みのタイトルを使用' do
        example 'タスクの新規作成が失敗する' do
          exist_title_task = create(:task)
          visit new_task_path
          fill_in 'Title', with: exist_title_task.title
          fill_in 'Content', with: 'test-content'
          select 'todo', from: 'Status'
          click_button 'Create Task'
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content 'Title has already been taken'
          expect(page).not_to have_content 'Content: test-content'
          expect(current_path).to eq tasks_path
        end
      end
    end
 
    describe 'タスク編集' do
      context 'フォームの入力値が正常' do
        example 'タスクの編集が成功する' do
          visit edit_task_path(task)
          fill_in 'Title', with: 'update-title'
          fill_in 'Content', with: 'update-content'
          select 'doing', from: 'Status'
          fill_in 'Deadline', with: DateTime.new(2021, 2, 14, 10, 30)
          click_button 'Update Task'
          expect(page).to have_content 'Task was successfully updated.'
          expect(page).to have_content 'Title: update-title'
          expect(page).to have_content 'Content: update-content'
          expect(page).to have_content 'Status: doing'
          expect(page).to have_content 'Deadline: 2021/2/14 10:30'
          expect(current_path).to eq task_path(task)
        end
      end

      context 'タイトルが未入力' do
        example 'タスクの編集が失敗する' do
          visit edit_task_path(task)
          fill_in 'Title', with: nil
          select 'doing', from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content "Title can't be blank"
          expect(page).not_to have_content 'Status: doing'
          expect(current_path).to eq task_path(task)
        end
      end

      context '登録済みのタイトルを使用' do
        example 'タスクの編集が失敗する' do
          exist_title_task = create(:task)
          visit edit_task_path(task)
          fill_in 'Title', with: exist_title_task.title
          select 'doing', from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content 'Title has already been taken'
          expect(page).not_to have_content "Title: #{exist_title_task.title}"
          expect(current_path).to eq task_path(task)
        end
      end

      context '他のユーザーのタスク編集ページにアクセス' do
        example '編集ページへのアクセスが失敗する' do
          other_user_task = create(:task)
          visit edit_task_path(other_user_task)
          expect(page).to have_content 'Forbidden access.'
          expect(current_path).to eq root_path 
        end
      end
    end

    describe 'タスク削除' do
      context '削除ボタンをクリック' do
        example 'タスクを削除する' do
          destory_task = task
          visit tasks_path
          click_link 'Destroy'
          expect(page.accept_confirm).to eq 'Are you sure?'
          expect(page).to have_content 'Task was successfully destroyed.'
          expect(current_path).to eq tasks_path
          expect(page).not_to have_content destory_task.title 
        end
      end
    end
  end
end
