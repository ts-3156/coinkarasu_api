namespace :cryptocompare do
  namespace :top_pairs do
    desc 'update'
    task update: :environment do
      symbols = %w(LTC ETH BCH USDT IOT ETC DASH XRP XMR XEM EOS STRAT XLM WAVES ZEC MEME NXT NEO PTOY OMG BTG EMC2 MCO POWR QTUM ARDR VTC YOYOW BAT ADA LSK XEL HSR RCN SALT SNT MTL MANA REQ WTC CVC SWT ARK QSP EDG TRX NAV VRC IOP STORJ GCR VEN SYS LINK VOX SNGLS MONA DOGE GUP XDN PAY AMP KMD DGB BAY SC RISE BSD MAID BCN BNB BNT CFI ION MUE OK ADX BQX SBD FCT LRC SAN FLDC BTS ENG DNT SUB GRS XZC CTR MOD XVG TIX STEEM MER GNO GNT ZRX ERO GAME DCR REP KNC ETN ORME PIVX AST FUN SNM SAFEX THC EBST VIB POT HMQ LBC DLT ZEN TRIG AMB ARN RLC EVX DCT VIA AGRS GAS TX OAX BLK SHIFT ENJ WINGS UBQ BYC GOLOS CLUB FTC NBT XBY MUSIC ICN MCAP RADS PPC TRST SPHR NXS AUR DGD XAUR RDD MDA EXP MGO EXCL SYNX SLS NMR KORE LMC BURST WC MTH MYST XCP ANT QWARK DOPE XMG CLOAK UNIT PDC ETP CLAM GRC BLOCK VTR CANN GBYTE ZCL UNB PART NULS QRL FLO XWC POLL RIC NEOS KOLION XUC R AE XTZ BWK BTCD AVT NXC PASC PBT DYN HVN PLBT BCD LUX TAAS XST ZNY XVC NEBL BTX SIB LUN GBX EGC DTB BTM AEON ERC PKB PEPECASH BLITZ PPT SWIFT BITB NLG ONX MAN PIRL IND IXT INFX VRM BCY DNA IOC WGR NMC EDO OMNI KICK COVAL CNX PHR NLC2 GRWI CRW FUTC XMY ONION APX PTC SEQ PINK CPC PURA SKY ABY FAIR SAR ENRG SLR XBC BT2 SBC ODN START XHI DBIX INN VIVO BIS QASH LINX SPR BRK RYZ DMD CURE TRUST PTA GLD GEO TOA XPM WCT GAM RUP EFL CHC HOLD AURS XSPEC BTD SNRG 2GIVE RRT BELA BRX MCAR CNBC KRB UNIFY HUC UNO BT1 XPD OSC PEN DOT ATOM SXC SEND RNS MAD NTRN CORE CMP INCNT EVR HUSH)
      url = 'https://min-api.cryptocompare.com/data/top/pairs?limit=1000&fsym='
      error = 0
      m = Mutex.new
      processed = Queue.new

      Parallel.each(symbols, in_threads: 3) do |from|
        begin
          res = Net::HTTP.get(URI.parse(url + from))
          processed << [from, res] if res
        rescue => e
          puts "#{Time.zone.now} error from=#{from} #{e.inspect}"
          m.synchronize {error += 1}
          raise Parallel::Break if error >= symbols.size / 10
        end
      end

      processed.size.times.map {processed.pop}.each do |from, res|
        begin
          Cryptocompare::TopPair.create_from_response!(res)
        rescue => e
          puts "#{Time.zone.now} error from=#{from} res=#{res} #{e.inspect}"
        end
      end
    end
  end
end
