class SlackClient
  def initialize(url)
    @instance = Slack::Notifier.new(url)
  end

  def ping(*args)
    @instance.ping(*args)
  end

  class << self
    def cron
      new(ENV['SLACK_CRON_WEBHOOK'])
    end

    def server
      new(ENV['SLACK_SERVER_WEBHOOK'])
    end
  end
end
