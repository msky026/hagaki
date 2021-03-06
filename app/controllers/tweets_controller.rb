class TweetsController < ApplicationController
  before_action :authenticate, only: [:new, :create, :edit, :update, :destroy]

  def index
    @tweets = Tweet.all
  end

  def show
    @tweet = Tweet.find(params[:id])
    return redirect_to tweets_path if @tweet.pic.nil?
    pic = JSON.parse(@tweet.pic)
    @image_url = pic["url"] if pic
  end

  def new
    @tweet = current_user.tweets.build
  end

  def create
    @tweet = Tweet.new.create_with_image(current_user.id, tweet_params)
    if @tweet.save
      redirect_to @tweet, notice: '作成しました'
    else
      render :new
    end
  end

  def edit
    @tweet = Tweet.find(params[:id])
  end

  def update
    @tweet = Tweet.find(params[:id])
    if @tweet.update_with_image(current_user.id, tweet_params)
      redirect_to @tweet, notice: '更新しました'
    else
      render :edit
    end
  end

  def destroy
    @tweet = Tweet.find(params[:id])
    @tweet.delete_with_image
    redirect_to root_path, notice: '削除しました'
  end

  def image
    @tweet = Tweet.find(params[:id])
    @user = @tweet.user
    pic = JSON.parse(@tweet.pic)
    @image_url = pic["url"] if pic
    render :image, layout: false
  end

  private

  def tweet_params
    params.require(:tweet).permit(
      :content
    )
  end
end
