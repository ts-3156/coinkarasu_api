module SlackClient
  URL = ENV['SLACK_CRON_WEBHOOK']

  def self.new
    Slack::Notifier.new(URL)
  end
end
