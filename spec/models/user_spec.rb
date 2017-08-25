RSpec.describe User, type: :model do
  before(:each) do
    @user = User.create(email: 'foo@bar.com', password: 'foobar', username: 'TestUser', first_name: 'Hans', last_name: 'Merkel')
  end

  describe "#full_name" do
    it 'returns the first name and last name' do
      expect(@user.full_name).to eql('Hans Merkel')
    end

    it 'returns nothing in case user has no name set' do
      @user.first_name = nil
      expect(@user.full_name).to eql('Merkel')
      @user.first_name = 'Hans'
      @user.last_name = nil
      expect(@user.full_name).to eql('Hans')
    end
  end

  describe '#full_name_or_username' do
    it 'returns the full name if it is present' do
      expect(@user.full_name_or_username).to eql('Hans Merkel')
    end

    it 'returns the user name if the full name is not present' do
      @user.first_name = nil
      @user.last_name = nil
      expect(@user.full_name_or_username).to eql('TestUser')
    end
  end
end
