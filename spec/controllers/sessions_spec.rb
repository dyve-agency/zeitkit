require 'rails_helper'

RSpec.describe 'Sessions', :type => :request do

  describe 'with correct credentials' do
    before {
      allow(SecureRandom).to receive(:hex).and_return('superRandom')
    }

    let (:password) {'super-secret-123'}
    let (:user) {User.create(email: 'foo@bar.com', password: password, time_zone: 'Berlin')}
    let (:endpoint) {'/sessions'}

    xit 'responds with a newly generated access token' do
      post endpoint, {email: user.email, password: password }.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

      expect(response.body).to eq({access_token: 'superRandom'})
    end

    xit 'responds with an existing access token' do
      user.token = 'Foobarrr123'
      user.save!

      post endpoint, {email: user.email, password: password }.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response.body).to eq({access_token: 'Foobarrr123'})
    end
  end
end
