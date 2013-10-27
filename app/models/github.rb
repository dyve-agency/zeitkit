class Github
  # Class to get commit messages from github
  attr_accessor :client

  def initialize(user)
    self.client = Octokit::Client.new login: user.github_user, password: user.github_password
  end

  def get_repo_names
    begin
      client.repositories.map{|repo| repo.full_name }
    rescue
      []
    end
  end

  def get_commits_on(date: DateTime.now, repo: nil)
    return [] unless repo
    date = date.strftime("%Y-%m-%d")
    begin
      client.commits_on(repo, date).map{|commit| commit.commit.message }
    rescue
      []
    end
  end

  def get_all_commits_on_date(date: DateTime.now)
    repos = get_repo_names
    repos.map{|repo| get_commits_on(date: date, repo: repo)}.flatten
  end

end
