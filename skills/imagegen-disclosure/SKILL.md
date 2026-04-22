---
name: imagegen-disclosure
description: Add and validate AI-generation disclosure labels for generated or edited raster images. Use whenever Codex creates, edits, saves, or prepares generated bitmap images and must ensure the disclosure text is applied after generation rather than drawn by the image model.
---

# 画像生成の開示ラベル

## 基本ルール

生成段階では画像をクリーンな状態に保つ。画像生成モデルに、署名、ウォーターマーク、キャプション、開示ラベルを描画させないこと。

生成または編集されたビットマップ画像をローカルファイルとして扱える状態になった後で、ImageMagick を使って次の開示ラベルを合成する。

```text
この画像はChatGPTにより生成されました
```

ローカルファイルとして処理できない場合、または ImageMagick を利用できない場合は、画像生成プロンプトでラベルを再現しようとせず、後処理できない理由を説明する。

## 手順

1. 画像外部的なメタ情報テキストを含めずに、画像を生成または編集する。
2. 採用するビットマップ画像をローカルファイルとして保存または特定する。
3. `magick -version` で ImageMagick を利用できるか確認する。
4. ユーザが別の位置を指定していない限り、開示ラベルを右下に追加する。
5. 可読性を確保できるコントラストにする。背景が複雑な場合は半透明の下地を付ける。
6. ユーザが明示的に上書きを求めていない限り、元画像を破壊せず別ファイルとして保存する。
7. 最終的な出力パスを報告する。ラベルを適用できなかった場合は理由を報告する。

## ImageMagick の実行例

古い `convert` ではなく、`magick` を優先して使用する。

デフォルトでは右下に配置する。実行中の shell に合う例を選ぶ。

```powershell
magick input.png ^
  -gravity southeast ^
  -font "Yu-Gothic" ^
  -pointsize 24 ^
  -fill white ^
  -undercolor "#00000080" ^
  -annotate +20+20 "この画像はChatGPTにより生成されました" ^
  output.png
```

```bash
magick input.png \
  -gravity southeast \
  -font "Yu-Gothic" \
  -pointsize 24 \
  -fill white \
  -undercolor "#00000080" \
  -annotate +20+20 "この画像はChatGPTにより生成されました" \
  output.png
```

画像に合わせて `-pointsize`、`-fill`、`-undercolor` を調整する。フォントはサンセリフ体を使用する。指定したフォントを利用できない場合は、インストール済みの日本語対応サンセリフ体フォントを選ぶ。

## 制約

- 画像生成プロンプトに開示ラベルの文言を含めないこと。
- 画像生成モデルに後処理を模倣させないこと。
- 明示的に依頼されていない限り、既存ファイルを上書きしないこと。
- 無関係なキャプション、署名、作成者名、装飾的なウォーターマークを追加しないこと。
- UI、図、チャート、軸ラベル、凡例、ボタンなどの一部として自然に必要なテキストは許可する。
