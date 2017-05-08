class PriceCalculator
  include Virtus.model
  attribute :user
  attribute :worklog

  # returns which rate to display based on the user and the worklog.
  # subcontractors want to see a different price than the owners of the
  # worklog.
  def total
    if client_share.present?
      client_share_rate
    else
      worklog.total
    end
  end

  private

  def client_share_rate
    if created_as_subcontractor?
      client_share.subcontractor_hourly_rate
    else
      client_share.hourly_rate
    end
  end

  def created_as_subcontractor?
    return unless client_share
    client_share.works_as_subcontractor
  end

  def client_share
    @client_share ||= worklog.client_share
  end

end
