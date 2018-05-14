require 'rails_helper'

RSpec.describe 'Worklogs', :type => :request do

  before {
    allow(SecureRandom).to receive(:hex).and_return('superRandom')
  }

  let (:endpoint) {'/api/worklogs'}
  let (:password) {'super-secret-123'}
  let (:user) {User.create!(email: 'foo@bar.com', password: password, time_zone: 'Berlin')}
  let (:client) {Client.create!(hourly_rate: 100, user_id: user.id, name: 'client name')}
  let (:team) {Team.create!({name: 'team name', creator: user}, without_protection: true)}


  describe 'with invalid token' do
    it 'prevents access' do
      post endpoint
      expect(response.status).to eq(401)
    end
  end

  describe 'with correct credentials' do
    it 'responds with 200 for a complete worklog' do
      expect(user.token).to eq('superRandom')

      headers = {
        "ACCEPT" => "application/json",
        "CONTENT_TYPE" => "application/json",
        "Authorization" => "Token superRandom",
      }

      timeframes = [[1526304551,1526305015], [1526304551,1526305015]]

      post endpoint, { client_id: client.id, team_id: team.id, worklogs: timeframes, description: 'This is a test' }.to_json, headers

      expect(response.status).to eq(200)
      expect(Worklog.last.timeframes.count).to eq(2)
    end
  end
end
