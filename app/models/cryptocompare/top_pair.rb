class Cryptocompare::TopPair < ApplicationRecord
  # 358 symbols (toplist + japan)
  SYMBOLS = %w(007 2GIVE 8BT ABY ACP ADA ADX AE AEON AGRS AMB AMP ANT APX ARDR ARK ARN AST ATM ATOM AUR AURS AVT BAT BAY BCD BCH BCN BCY BELA BIS BITB BITOK BLITZ BLK BLOCK BNB BNT BQX BRK BRX BSD BT1 BT2 BTC BTCD BTCM BTCRED BTD BTG BTM BTS BTX BURST BWK BYC CANN CAPP CFI CHC CLAM CLOAK CLUB CMP CNBC CNX CORE COVAL CPC CRW CTC CTR CURE CVC DASH DATA DBIX DCR DCT DGB DGD DLT DMD DNA DNT DOGE DOPE DOT DRZ DTB DYN EBST EBTC EDG EDO EDR EDRC EFL EGC EKO EMC2 ENG ENJ ENRG EOS ERC ERO ETC ETH ETN ETP EVR EVX EXCL EXP FAIR FCT FLDC FLO FTC FUN FUTC GAM GAME GAS GBX GBYTE GCR GEO GLD GNO GNT GOLOS GRC GRS GRWI GUP HMQ HOLD HSR HUC HUSH HVN ICN INCNT IND INFX INN IOC ION IOP IOT IXT KICK KMD KNC KOLION KORE KRB LBC LBTC LC LINK LINX LKK LMC LRC LSK LTC LTH LUN LUX MAD MAID MAN MANA MCAP MCAR MCO MDA MEME MER MGO MOD MONA MTH MTL MUE MUSIC MYST NAV NBT NEBL NEO NEOS NLC2 NLG NMC NMR NTRN NULS NXC NXS NXT OAX ODN OK OMG OMNI ONION ONX ORLY ORME OSC PAC PART PASC PAY PBT PDC PEN PEPECASH PHR PINK PIRL PIVX PKB PLBT POLL POT POWR PPC PPT PQT PRG PTA PTC PTOY PURA PWR QASH QRL QSP QTUM QWARK R RADS RBIT RCN RDD REP REQ RIC RISE RLC RNS RRT RUP RYZ SAFEX SALT SAN SAR SBC SBD SC SEND SEQ SHIFT SHREK SIB SJCX SKY SLR SLS SNC SNGLS SNM SNRG SNT SPHR SPR START STEEM STORJ STRAT STX SUB SWIFT SWT SXC SYNX SYS TAAS THC TIX TNT TOA TRIG TRST TRUST TRX TX UBQ UMC UNB UNIFY UNIT UNO USDT VEC2 VEN VIA VIB VIVO VOX VRC VRM VRS VTC VTR WAVES WC WCT WGR WINGS WTC XAUR XBC XBY XCP XDN XEL XEM XHI XLM XMG XMR XMY XPD XPM XRP XSPEC XST XTZ XUC XVC XVG XWC XZC YES YOYOW ZCL ZEC ZECD ZEN ZNY ZRX)

  IGNORE_LIST = %w(007 8BT ATM BT1 CORE CTC MAN PQT SAFEX SAR SWIFT BIS RYZ UMC)

  validates :from_symbol, presence: true, format: {with: /\A[A-Z0-9]{1,10}\z/}
  validates :data, presence: true

  class << self
    def build_from_response(res)
      json = JSON.parse(res)
      data = json['Data'].map do |row|
        {to_symbol: row['toSymbol'], volume: row['volume24h']}
      end
      new(
          from_symbol: json['Data'][0]['fromSymbol'],
          data: data)
    end

    def symbols_pairs
      # クエリの実行回数を減らすために、決め打ちのlimit付きで一括取得する
      # 最新のレコードのみを残すためにindex_byの前にreverseしている
      top_pairs = order(created_at: :desc)
                      .where(from_symbol: SYMBOLS)
                      .limit(SYMBOLS.size)
                      .reverse
                      .index_by(&:from_symbol)

      pairs = []

      SYMBOLS.each do |from|
        top_pair = top_pairs[from]
        unless top_pair
          # 最初のクエリで取りこぼした時のために、念のため取得する
          top_pair = order(created_at: :desc).find_by(from_symbol: from)
        end
        next unless top_pair

        top_pair.data.map {|pair| pair['to_symbol']}.uniq.each do |to|
          pairs << [from, to]
        end
      end

      pairs
    end
  end
end
