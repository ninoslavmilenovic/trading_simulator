module TradingSimulator
  class Trade
    WIN = 1
    LOOSE = 0

    attr_reader :amount
    attr_reader :number_of_trades
    attr_reader :wins_percentage
    attr_reader :trading_account
    attr_reader :balance_before
    attr_reader :balance_after

    def initialize(amount, number_of_trades, wins_percentage, trading_account)
      @amount = amount
      @number_of_trades = number_of_trades
      @wins_percentage = wins_percentage
      @trading_account = trading_account
      @balance_before = nil
      @balance_after = nil
    end

    def execute!
      balance_snapshot do
        win? ? trading_account.add!(profit) : trading_account.take!(amount)
      end
    end

    def asset
      @asset ||= TradingSimulator::Asset.new(Array(84..86).sample)
    end

    def result
      @result ||= result_pool.sample
    end

    def win?
      result == WIN
    end

    def loose?
      !win?
    end

    def profit
      win? ? (amount * asset.profit_percentage) / 100 : 0
    end

    private

      def result_pool
        [[WIN] * ((number_of_trades * wins_percentage) / 100), [LOOSE] * ((number_of_trades * (100 - wins_percentage)) / 100)].flatten.shuffle
      end

      def balance_snapshot
        @balance_before = trading_account.balance
        yield
        @balance_after = trading_account.balance
      end
  end
end
