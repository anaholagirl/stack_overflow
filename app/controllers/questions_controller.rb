class QuestionsController < ApplicationController
  before_action :authorize, except: [:index, :show]

  def index
    @questions = Question.all
  end

  def show
    if session[:user_id]
      @user = User.find(session[:user_id])
    else
      @user = User.find(params[:user_id])
    end
    @question = @user.questions.find(params[:id])
  end

  def new
    current_user = User.find(params[:user_id])
    @question = current_user.questions.new
  end

  def create
    @user = User.find(session[:user_id])
    @question = @user.questions.new(question_params)
    if @question.save
      flash[:notice] = 'Question asked'
      redirect_to user_question_path(@user, @question)
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(session[:user_id])
    @question = @user.questions.find(params[:id])
  end

  def update
    @user = User.find(session[:user_id])
    @question = @user.questions.find(params[:id])
    if @question.update(question_params)
      flash[:notice] = 'Question updated'
      redirect_to user_question_path(@user, @question)
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(session[:user_id])
    @question = @user.questions.find(params[:id])
    @question.destroy
    flash[:alert] = 'Question deleted'
    redirect_to user_path(@user.id)
  end

private
  def question_params
    params.require(:question).permit(:title, :question, :user_id)
  end
end
