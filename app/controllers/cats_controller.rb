class CatsController < ApplicationController
  before_action :set_cat, only: [:edit, :update, :show]
  before_action :correct_owner, only: [:edit, :update]
  helper_method :correct_owner?

  def index
    @cats = Cat.all
    render :index
  end

  def show
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    render :edit
  end

  def update
    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  def correct_owner?
    current_user && @cat.user_id == current_user.id
  end

  private
  def set_cat
    @cat = Cat.find(params[:id])
  end

  def correct_owner
    unless current_user && current_user.id == @cat.user_id
      redirect_to cats_url
    end
  end

  def cat_params
    params.require(:cat)
      .permit(:age, :birth_date, :color, :description, :name, :sex)
  end
end
