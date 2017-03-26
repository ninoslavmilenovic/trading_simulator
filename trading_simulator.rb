require_relative "trading_simulator/asset"
require_relative "trading_simulator/bank_account"
require_relative "trading_simulator/trade"
require_relative "trading_simulator/trading_account"
require_relative "trading_simulator/trading_session"

require "pry"

bank_account = TradingSimulator::BankAccount.new
trading_account = TradingSimulator::TradingAccount.new(1000)

200.times do |i|

  if [25, 50, 75, 100, 125, 150, 175].include?(i)
  # if [5, 10, 15].include?(i)
    trading_account = TradingSimulator::TradingAccount.new(trading_account.initial_investment + 1000, 5000, trading_account.balance)
  end

  ba_balance_before = bank_account.balance

  trading_session = TradingSimulator::TradingSession.new(Array(60..80).sample, Array(55..65).sample, trading_account, bank_account)
  trading_session.run

  puts "Session ##{i.succ}, Ended with trading account balance: #{trading_account.balance.round}"
  puts "Session ##{i.succ}, Ended with profit: #{bank_account.balance - ba_balance_before}"
  puts "-------------------------------------------------------------------------"
end

# binding.pry

puts "Total bank acount balance: #{bank_account.balance}"
puts "Total after-tax estimated profit: #{(bank_account.balance / 2.1).round}"

exit
