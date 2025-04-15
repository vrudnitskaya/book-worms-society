require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    context 'when all required fields are present' do
      let(:user) do
        User.new(
          username: 'harrypotter',
          email: 'potter@owlpost.com',
          password: 'nimbus2000',
          password_confirmation: 'nimbus2000'
        )
      end

      it 'is valid' do
        expect(user).to be_valid
      end
    end

    context 'when email is missing' do
      let(:user) do
        User.new(
          username: 'harrypotter',
          password: 'nimbus2000',
          password_confirmation: 'nimbus2000'
        )
      end

      it 'is not valid' do
        expect(user).to_not be_valid
      end
    end

    context 'when password is missing' do
      let(:user) do
        User.new(
          username: 'harrypotter',
          email: 'potter@owlpost.com'
        )
      end

      it 'is not valid' do
        expect(user).to_not be_valid
      end
    end

    context 'when email is not unique' do
      before do
        User.create!(
          username: 'theboywholived',
          email: 'potter@owlpost.com',
          password: 'nimbus2000',
          password_confirmation: 'nimbus2000'
        )
      end

      let(:user) do
        User.new(
          username: 'harrypotter',
          email: 'potter@owlpost.com',
          password: 'nimbus2000',
          password_confirmation: 'nimbus2000'
        )
      end

      it 'is not valid' do
        expect(user).to_not be_valid
      end
    end
  end
end
