module TradingSimulator
  class TradingAccount
    MAX_INVESTMENT_PER_TRADE = 5000

    attr_reader :initial_investment, :balance

    def initialize(initial_investment, max_investment_per_trade=MAX_INVESTMENT_PER_TRADE, balance=nil)
      @initial_investment = initial_investment
      @balance = balance || initial_investment
    end

    def safe_balance
      balance - initial_investment
    end

    def add!(amount)
      @balance += amount
    end

    def take!(amount)
      @balance -= amount
    end

    def balance_in_danger?
      balance < initial_investment
    end
  end
end
