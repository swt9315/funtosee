class TweetsController < ApplicationController
  before_action :set_tweet, only: [:edit, :show]
  before_action :move_to_index, except: [:index, :show, :search]

  def index
    @tweets = Tweet.includes(:user).order("created_at DESC")
    # @tweets = Tweet.all（⇐上記に変更前の記述） 上記の記述は、N+1問題を解決するためのもの。なお、allは省略されている。
  end

  def new
    @tweet = Tweet.new
  end

  def create
    Tweet.create(tweet_params)
  end

  def destroy
    tweet = Tweet.find(params[:id])
    tweet.destroy
  end

  def update
    tweet = Tweet.find(params[:id])
    tweet.update(tweet_params)
  end

  def edit
  end

  def show
    @comment = Comment.new
    @comments = @tweet.comments.includes(:user)
    # tweets/show.html.erbでform_withを使用して、comments#createを実行するリクエストを飛ばしたいので、
    # @comment = Comment.newというインスタンス変数を生成しておかないといけません。
    # tweetsテーブルとcommentsテーブルはアソシエーションが組まれているので、@tweet.commentsとすることで、
    # @tweetへ投稿されたすべてのコメントを取得できます。
    # また、ビューでは誰のコメントか明らかにするため、アソシエーションを使ってユーザーのレコードを取得する処理を繰り返します。
    # そのときに「N+1問題」が発生してしまうので、includesメソッドを使って、N+1問題を解決している点にも注意してください。
    # コントローラーであるツイートについて投稿されたコメントの全レコードを取得することができたので、これらをビューで表示しましょう。
  end

  def search
    @tweets = Tweet.search(params[:keyword])
  end

  private
  def tweet_params
    params.require(:tweet).permit(:image, :text).merge(user_id: current_user.id)
  end

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end

end
