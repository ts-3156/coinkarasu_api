slack = SlackClient.server
slack.ping("df ```#{`df -h`}```")

[
    Coincheck::SalesRate,
    Coincheck::TradingRate,
    Cryptocompare::TopPair,
    Cryptocompare::CoinSnapshot,
    Cryptocompare::PriceMultiFull,
].each do |clazz|
  lines = []
  clazz.where('created_at > ?', 3.hours.ago.beginning_of_hour)
      .select('date_format(created_at, "%Y/%m/%d %H:00") date, count(*) cnt')
      .group('date')
      .each {|r| lines << "#{r[:date]} #{r[:cnt]}"}
  slack.ping("#{clazz} ```#{lines.join("\n")}```")
end
