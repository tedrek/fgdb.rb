class DatebocksController < ApplicationController
	def index
	end
	
	def help
		render :partial => 'datebocks/help'
	end
end