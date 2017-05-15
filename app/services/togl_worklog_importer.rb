class ToglWorklogImporter
  include Virtus.model
  attribute :client, Client
  attribute :user, User
  attribute :file_path, String
  attribute :perform_import, Boolean, default: false

  def import
    raise ArgumentError.new('please set client user and file_path') if [client, user, file_path].any?(&:blank?)
    rows = CSV.read(file_path, headers: true).map {|row| row}
    Worklog.transaction do
      import_rows(rows)
      raise ArgumentError.new("in a dry run. set perform_import to true") unless perform_import
    end
  end

  private

  def import_rows(rows)
    data = rows.map do |row|
      build_worklog(row)
    end
    data.each(&:save!)
  end

  def build_worklog(row)
    wl      = client.worklogs.build(summary: row["Description"])
    wl.user = user
    started = DateTime.parse("#{row['Start date']} #{row['Start time']}")
    ended   = DateTime.parse("#{row["End date"]} #{row["End time"]}")
    wl.timeframes.build(started: started, ended: ended)
    wl.hourly_rate = client.hourly_rate
    wl.client_share = find_client_share
    wl
  end

  def find_client_share
    @client_share ||= ClientShare.where(user_id: user.id, client_id: client.id).first
  end
end
