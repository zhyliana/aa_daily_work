class CatRentalRequestsController < ApplicationController
  def index
    @request = CatRentalRequest.all
    render :index
  end

  def show
    @request = CatRentalRequest.find(params[:id])
    render :show
  end

  def new
    @request = CatRentalRequest.new
    render :new
  end

  def create
    @request = CatRentalRequest.new(request_params)
    if @request.try(:save)
      flash.notice = 'Cat rental request submitted'
      redirect_to cat_url(request_params[:cat_id])
    else
      flash.notice = 'Cat rental request not submitted'
    end
  end



  # def destroy
  #   @request = CatRentalRequest.find(params[:id])
  #   flash.notice = 'CatRentalRequest "#{@request.name}" has been put to rest...'
  #   @request.try(:destroy)
  #   redirect_to requests_url
  # end
  #
  # def edit
  #   @request = CatRentalRequest.find(params[:id])
  #   render :edit
  # end

  # def update
  #   @request = CatRentalRequest.find(params[:id])
  #   if @request.update_attributes(request_params)
  #     flash.notice = "#{@request.name} has been fixed."
  #     redirect_to request_url(@request)
  #   else
  #     flash.notice = '"#{@request.name}" could not be fixed. Please try again.'
  #     render :edit
  #   end
  # end

  # def approve
  #   @request = CatRentalRequest.find(params[:id])
  #
  #   if request.approve!
  #     redirect_to cat_url(@request.cat_id)
  #   else
  #     render text: @request.errors.full_messages
  #   end
  # end

  # def deny
  #   @request = CatRentalRequest.find(params[:id])
  #
  #   if request.deny!
  #     redirect_to cat_url(@request.cat_id)
  #   else
  #     render text: @request.errors.full_messages
  #   end
  # end


  private

  def request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end
end
