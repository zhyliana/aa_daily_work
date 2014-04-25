class CatsController < ApplicationController

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params, :user_id = @session_user.id)
    if @cat.try(:save)
      flash.notice = 'Cat "#{@cat.name}" has been born!'
      redirect_to cat_url(@cat)
    else
      flash.notice = 'Cat "#{@cat.name}" was not saved!'
      render :new
    end
  end

  def destroy
    @cat = Cat.find(params[:id])
    flash.notice = 'Cat "#{@cat.name}" has been put to rest...'
    @cat.try(:destroy)
    redirect_to cats_url
  end

  def edit
    @cat = Cat.find(params[:id])
    render :edit
  end

  def update
    @cat = Cat.find(params[:id])
    before_action :check_owner(@cat)

    if @cat.update_attributes(cat_params)
      flash.notice = "#{@cat.name} has been fixed."
      redirect_to cat_url(@cat)
    else
      flash.notice = '"#{@cat.name}" could not be fixed. Please try again.'
      render :edit
    end
  end

  private

  def cat_params
    params.require(:cat).permit(:age, :birth_date, :color, :name, :sex)
  end

  def check_owner(cat)
    unless @session_user.id = cat.user_id
      flash[:notice] = "Can't edit someone else's cat!"
      redirect_to cats_url
    end
  end

end
