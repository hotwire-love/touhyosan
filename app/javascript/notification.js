// このコードは以下の記事を参照して作成しました。
//
// [\[Rails\]turboのカスタムアクションを使ってみる](https://zenn.dev/redheadchloe/articles/d567e7795f0acf)

import { Turbo } from "@hotwired/turbo-rails";
const { StreamActions } = Turbo;

Turbo.StreamActions.redirect = function () {
  const url = this.getAttribute("url") || "/";
  Turbo.visit(url, { frame: "_top", action: "advance" });
};
