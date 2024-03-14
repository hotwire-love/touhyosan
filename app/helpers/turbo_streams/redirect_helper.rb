# このコードは以下の記事を参照して作成しました。
#
# [\[Rails\]turboのカスタムアクションを使ってみる](https://zenn.dev/redheadchloe/articles/d567e7795f0acf)

module TurboStreams::RedirectHelper
  def redirect(url)
    turbo_stream_action_tag("redirect", url: url)
  end
end

Turbo::Streams::TagBuilder.prepend(TurboStreams::RedirectHelper)
