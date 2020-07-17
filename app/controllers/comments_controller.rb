class CommentsController < ApplicationController
  def create
    Comment.create(comment_params)
    redirect_to "/tweets/#{comment.tweet.id}"  # コメントと結びつくツイートの詳細画面に遷移する
  end

  private
  def comment_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id, tweet_id: params[:tweet_id])
    # Commentモデルのcreateメソッドの引数では、ストロングパラメーターを用いて保存できるカラムを指定しています。
    # 渡されたparamsの中にcommentというハッシュがある二重構造になっているため、requireメソッドの引数に指定して、textを取り出しました。
    # user_idカラムには、ログインしているユーザーのidとなるcurrent_user.idを保存し、tweet_idカラムは、paramsで渡されるようにするので、params[:tweet_id]として保存しています。
  end
end
