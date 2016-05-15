MoneyRails.configure do |config|
  require 'money'
  require 'money/bank/google_currency'

  Money::Bank::GoogleCurrency.ttl_in_seconds = 86400

  config.default_bank = Money::Bank::GoogleCurrency.new
  config.default_currency = :myr
  config.no_cents_if_whole = false
  #config.symbol_before_without_space = false
  #config.add_rate "MYR", "USD", 0.25000
  #config.add_rate "USD", "MYR", 4.00000
end