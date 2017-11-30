class Stock < ApplicationRecord
	has_many :user_stocks
	has_many :users, through: :user_stocks

	def self.find_by_ticker(ticker_symbol)
		where(ticker: ticker_symbol).first
	end

	def self.new_from_lookup(ticker_symbol)
		begin
			look_up_stock = StockQuote::Stock.quote(ticker_symbol)
			return nil unless look_up_stock.name

			stripped_price = strip_commas(price(ticker_symbol))

			new_stock = new(ticker: look_up_stock.t, name: look_up_stock.name)
			new_stock.last_price = stripped_price
			new_stock
		rescue Exception => e
			return nil
		end
	end

	def self.strip_commas(number)
		number.gsub(',', '')
	end


	def self.price(ticker)
		closing_price = StockQuote::Stock.quote(ticker).l
		return closing_price if closing_price

		opening_price = StockQuote::Stock.quote(ticker).op
		return opening_price if opening_price

		"Unavailable"
	end


end
