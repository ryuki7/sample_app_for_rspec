require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    let(:user) { FactoryBot.create(:user) }
    it 'is valid with all attributes' do
      task = Task.new(
        title: "test",
        status: 0,
        user: user
      )
      expect(task).to be_valid
    end
    it 'is invalid without title' do 
      task = Task.new(title: nil)
      task.valid?
      expect(task.errors[:title]).to include("can't be blank")
    end
    it 'is invalid without status' do
      task = Task.new(status: nil)
      task.valid?
      expect(task.errors[:status]).to include("can't be blank")
    end
    it 'is invalid with a duplicate title' do
      Task.create(
        title: "test",
        status: 0,
        user: user
      )
      task = Task.new(
        title: "test",
        status: 0,
        user: user
      )
      task.valid?
      expect(task.errors[:title]).to include("has already been taken")
    end
    it 'is valid with another title' do
      Task.create(
        title: "test",
        status: 0,
        user: user
      )
      task = Task.new(
        title: "practice",
        status: 0,
        user: user
      )
      expect(task).to be_valid
    end
  end
end
