class CatRentalRequestsController < ApplicationController
  def new
    @request = CatRentalRequest.new
    @cats = Cat.all
    render :new
  end

  def create
    @request = CatRentalRequest.new(params[:cat_rental_request])

    if @request.save
      redirect_to cat_url(@request.cat_id)
    else
      @cats = Cat.all
      render :new
    end
  end
end
