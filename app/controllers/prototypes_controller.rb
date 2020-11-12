class PrototypesController < ApplicationController
  
  before_action :authenticate_user! ,except: [:index,:show]
  before_action :set_prototype, only: [:edit, :show]
  
  def index
    @prototypes = Prototype.includes(:user)
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.create(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit 
    unless user_signed_in?
    redirect_to action: :index
    end
  end
  
  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    if prototype.destroy
      redirect_to root_path
    end
  end

  def update
    prototypes = Prototype.find(params[:id])
    prototypes.update(prototype_params)
    if prototypes.update(prototype_params)
      redirect_to prototype_path(prototypes.id)   
    else
      render :edit
    end
  end

  private
  def prototype_params
    params.require(:prototype).permit(:title,:catch_copy,:concept,:image,:user).merge(user_id: current_user.id)
  end

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end

end
