class Tweet < ApplicationRecord
  validates :text, presence: true
  belongs_to :user
  has_many :comments

  def self.search(search)
    if search
      Tweet.where('text LIKE(?)', "%#{search}%")
    else
      Tweet.all
    end
  end
  # 引数のsearchは、検索フォームから送信されたパラメーターが入るため、
  # if searchと記述し、検索フォームに何か値が入力されていた場合を条件としています。
  # もし検索フォームに何も入力をせずに検索ボタンを押すと、引数で渡されるsearchの中身は空になります。
  # この場合はelseに該当し、Tweet.allという記述は、そのときすべての投稿を取得して表示するためのものです。
  # 実際の開発現場でも、テーブルとのやりとりに関するメソッドはモデルに置くという意識が必要です。
  # コントローラーはあくまでモデルの機能を利用し処理を呼ぶだけで、複雑な処理は組みません。
end
