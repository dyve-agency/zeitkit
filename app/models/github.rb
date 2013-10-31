class Github
  # Class to get commit messages from github
  attr_accessor :client

  def initialize(user)
    self.client = Octokit::Client.new login: user.github_user, password: user.github_password
  end

  def get_repo_names
    begin
      @repo_names ||= client.repositories.map{|repo| repo.full_name }
    rescue
      []
    end
  end

  def get_commits_on(date: DateTime.now.strftime("%F"), repo: nil)
    return [] unless repo
    begin
      filter_commits_by_user_id(commits: client.commits_on(repo, date)).map{|commit| commit.commit.message }
    rescue
      []
    end
  end

  def get_commits_on_date(date: DateTime.now)
    repos = get_repo_names
    repos.map{|repo| get_commits_on(date: date, repo: repo)}.flatten
  end

  def get_commits_between(start_date: DateTime.now.strftime("%F"), end_date: DateTime.now.strftime("%F"))
    return [] if start_date.blank? || end_date.blank?
    # Get the data for the current day if the dates are on the same day.
    return get_commits_on_date(date: start_date) if start_date == end_date
    get_repo_names.map do |repo|
      begin
        filter_commits_by_user_id(commits: client.commits_between(repo, start_date, end_date)).map{|commit| commit.commit.message}
      rescue
        []
      end
    end.flatten
  end

  def filter_commits_by_user_id(commits: [], user_id: client.user.id)
    begin
      # Could be that there is no author associated.
      commits.select{|commit| commit.author.id == user_id }
    rescue
      []
    end
  end

end
