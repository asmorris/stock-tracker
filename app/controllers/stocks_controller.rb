class StocksController < ApplicationController

  def search
  	if params[:stock].blank?
      flash.now[:danger] = "You have entered and empty search string. You need to look for a stock!"
    else
  		@stock = Stock.new_from_lookup(params[:stock])
      flash.now[:danger] = "You have entered an incorrect symbol! Please find your correct ticker." unless @stock
    end
    respond_to do |format|
      format.js { render partial: 'users/result' }
    end
  end

end
