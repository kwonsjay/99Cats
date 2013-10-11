class CatRentalRequestsController < ApplicationController
  before_filter :current_user_owns_cat, :only => [:approve, :deny]
  before_filter :user_logged_in, :only => [:new, :create]

  def new
    @request = CatRentalRequest.new
    @cats = Cat.all
    render :new
  end

  def create
    # @request = CatRentalRequest.new(params[:cat_rental_request])
    @request = current_user.cat_rental_requests.build(params[:cat_rental_request])

    if @request.save
      redirect_to cat_url(@request.cat_id)
    else
      @cats = Cat.all
      render :new
    end
  end

  def approve
     # @request = CatRentalRequest.find(params[:id])
     @request.approve!
     redirect_to cat_url(@request.cat_id)
  end

  def deny
    # @request = CatRentalRequest.find(params[:id])
    @request.deny!
    redirect_to cat_url(@request.cat_id)
  end

  private
    def current_user_owns_cat
      @request = CatRentalRequest.find(params[:id])
      @cat = @request.cat
      return true if @cat.user_id == current_user.id
      flash[:errors] = ["Unauthorized cat rental approve/deny attempt"]
      redirect_to cat_url(@cat)
    end

    def user_logged_in
      if logged_in?
        return true
      else
        flash[:errors] = ["Must be logged in to make request"]
        redirect_to new_session_url
      end
    end
end
