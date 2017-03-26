module TradingSimulator
  class TradingSession
    attr_reader :trades
    attr_reader :number_of_trades
    attr_reader :wins_percentage
    attr_reader :trading_account
    attr_reader :bank_account
    # attr_reader :withdrawed_300
    attr_reader :withdrawed_1000

    def initialize(number_of_trades, wins_percentage, trading_account, bank_account)
      @number_of_trades = number_of_trades
      @wins_percentage = wins_percentage
      @trading_account = trading_account
      @bank_account = bank_account
      @trades = []
      # @withdrawed_300 = false
      @withdrawed_1000 = false
    end

    def run
      number_of_trades.times do |i|
        if trading_account.balance < 1
          puts "Busted on #{i} trade!"
          puts "Busted with bank balance of #{bank_account.balance}"
          exit
        end

        if (trading_account.balance < (trading_account.initial_investment / 2)) && (bank_account.balance > (trading_account.initial_investment + (trading_account.initial_investment - trading_account.balance)))
          trading_account.add!((trading_account.initial_investment - trading_account.balance).to_i)
          bank_account.withdraw!((trading_account.initial_investment - trading_account.balance).to_i)
        end

        # if withdraw_allowed_for_300?
        #   trading_account.take!(300)
        #   bank_account.deposit!(300)
        #   @withdrawed_300 = true
        # end
        
        if withdraw_allowed_for_first_1000?
          trading_account.take!(1000)
          bank_account.deposit!(1000)
          @withdrawed_1000 = true
          puts "W1"
        end
        
        while withdraw_allowed_for_next_1000? do
          trading_account.take!(1000)
          bank_account.deposit!(1000)
          puts "W2"
        end

        trade = TradingSimulator::Trade.new(amount, number_of_trades, wins_percentage, trading_account)
        puts "Balance before: #{trading_account.balance.to_i}"
        puts "Trade amount: #{amount.to_i}"

        trade.execute!
        
        puts "Trade won: #{trade.win?}"
        puts "Balance after: #{trading_account.balance.to_i}"
        puts "\n"
        @trades << trade
      end
    end

    private

      def amount
        am = if !trades.any?
          a = trading_account.safe_balance / 2
          a > percent_of_balance(5) ? a : percent_of_balance(5)
        elsif trades.last.win?
          if trading_account.balance_in_danger?
            percent_of_balance(5)
          else
            a = trading_account.safe_balance / 2
            a > percent_of_balance(5) ? a : percent_of_balance(5)
          end
        elsif trades.last.loose?
          if trading_account.balance_in_danger?
            percent_of_balance(5)
          else
            if martingale_available?
              martingale
            else
              a = trading_account.safe_balance / 2
              a > percent_of_balance(5) ? a : percent_of_balance(5)
            end
          end
        end

        return 1 if am < 1
        return TradingSimulator::TradingAccount::MAX_INVESTMENT_PER_TRADE if am > TradingSimulator::TradingAccount::MAX_INVESTMENT_PER_TRADE
        am
      end

      def percent_of_balance(percent)
        (trading_account.balance * percent) / 100
      end

      def martingale_available?
        return false
        # result = (trades.last.amount * 2.5) <= (trading_account.balance / 3) && (trades.last.amount * 2.5) <= TradingSimulator::TradingAccount::MAX_INVESTMENT_PER_TRADE
        # if result
        #   puts "Martingale #{(trades.last.amount * 2.5).to_i} on #{trading_account.balance.to_i}"
        #   return result
        # else
        #   result
        # end
      end

      def martingale
        trades.last.amount * 2.5
      end

      # def withdraw_allowed_for_300?
      #   return false if withdrawed_300
      #   trading_account.safe_balance > 400 
      # end

      def withdraw_allowed_for_first_1000?
        return false if withdrawed_1000
        trading_account.safe_balance > 1000
      end

      def withdraw_allowed_for_next_1000?
        trading_account.safe_balance > 2000
      end
  end
end
