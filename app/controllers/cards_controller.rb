class CardsController < ApplicationController
  def new
    @client = ClientDetailsReport.find(:uid => params[:client_id])[0]
  end
  
  def create
    execute_command :assign_new_bank_card, params[:client_id], params[:card][:account]
    redirect_to client_path(params[:client_id])
  end
end
