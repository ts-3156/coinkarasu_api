slack = SlackClient.server
slack.ping("df ```#{`df -h`}```")

[
    Coincheck::SalesRate,
    Coincheck::TradingRate,
    Cryptocompare::CoinSnapshot,
    Cryptocompare::TopPair
].each do |clazz|
  slack.ping("#{clazz} ```#{clazz.all.size}```")
end
