require 'rails_helper'

RSpec.describe Team, type: :model do
  before(:each) do
    @user = User.create(email: 'foo@bar.com', password: 'foobar', username: 'TestUser')
    @team_user = User.create(email: 'team@user.com', password: 'foo', username: 'TeamUser')
    @team = Team.create(name: 'TestTeam')
    @team.creator = @team_user
    @team.save
  end

  it 'should indicate it was created by given user' do
    expect(@team.created_by?(@team_user)).to eq(true)
  end

  it 'should indicate it was not created by given user' do
    expect(@team.created_by?(@user)).to eq(false)
  end

  it 'should indicate it was not created by given guest user' do
    expect(@team.created_by?(User.new)).to eq(false)
  end
end
