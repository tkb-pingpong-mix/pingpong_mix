# [WIP]PingPongMix

**PingPongMix** は卓球プレイヤー同士のマッチングをサポートするアプリです。スキルレベルや地域、プレイスタイルに応じた相手探しが可能で、チャットやイベント参加機能も備えています。

## 🚀 機能一覧
- **ユーザー認証**: Firebase Authentication を使用したメール認証。
   - ![AuthScreen](%E3%83%A6%E3%83%BC%E3%82%B5%E3%82%99%E3%83%BC%E8%AA%8D%E8%A8%BC.png)
- **チャット**: Firestore によるリアルタイムチャット。
   - ![Alt text](%E3%82%A4%E3%83%98%E3%82%99%E3%83%B3%E3%83%88%E4%BD%9C%E6%88%90.png)
- **イベント管理**: 卓球イベントの作成・参加。
   - ![Alt text](%E3%82%A4%E3%83%98%E3%82%99%E3%83%B3%E3%83%88%E6%A4%9C%E7%B4%A2.png)
   - ![Event Fileter](%E3%82%A4%E3%83%98%E3%82%99%E3%83%B3%E3%83%88%E7%B5%9E%E3%82%8A%E8%BE%BC%E3%81%BF.png)
   - ![Alt text](%E3%82%A4%E3%83%98%E3%82%99%E3%83%B3%E3%83%88%E6%A4%9C%E7%B4%A2%E5%BE%8C.png)
- **投稿機能**: ユーザーが画像付きの投稿を共有可能。
  - ![Alt text](%E6%8A%95%E7%A8%BF%E4%B8%80%E8%A6%A7.png)
  - ![Alt text](post_detail.png)
- **プロフィール編集**: ユーザー自分のプロフィールを編集できます
  - ![Alt text](Profile.png)
  - ![Alt text](profile_edit.png)
  

## 📱 画面構成
1. **スプラッシュ画面** - アプリ起動時のローディング処理
2. **ログイン/登録画面** - ユーザー認証を行う画面
3. **ホーム画面** - 各機能へのナビゲーション
4. **マッチング画面** - 対戦相手を検索
5. **チャット画面** - ユーザー間のメッセージのやり取り
6. **イベント一覧・詳細画面** - 卓球イベントの確認と参加
7. **プロフィール画面** - ユーザー情報の表示・編集
8. **マップ画面** - 卓球場やプレイヤーの位置を地図で確認

## 📂 プロジェクト構成
```
lib/
├── models/         # Firestore用のデータモデル
├── screens/        # 各画面のUI
├── viewmodels/     # Riverpodによる状態管理
├── services/       # Firebaseとのやり取りを行うサービス
├── widgets/        # 再利用可能なウィジェット
├── app.dart        # アプリのエントリーポイント
├── app_router.dart # 画面遷移の定義
├── main.dart       # Firebase初期化とアプリ起動
```

## 🔥 技術スタック
- **Flutter 3.22.0**
- **Firebase (Auth, Firestore, Cloud Messaging)**
- **Flutter Riverpod 2.5.1**
- **go_router 10.1.2** (画面遷移)
- **FlutterFire UI**

## 💻 環境構築
### 1. Firebase 設定
```bash
flutterfire configure --project=pong-mix
```

### 2. パッケージインストール
```bash
flutter pub get
```

### 3. アプリ実行
```bash
flutter run
```

## 📜 Firestore データ構造
```json
{
  "Users": {
    "userId": {
      "displayName": "John Doe",
      "email": "john@example.com",
      "region": "Tokyo"
    }
  },
  "Matches": {
    "matchId": {
      "playerOneId": "user123",
      "playerTwoId": "user456",
      "result": "Player One won"
    }
  }
}
```

## 📝 コーディング規約
- **クラス名**: PascalCase (`MyClass`)
- **メソッド名**: camelCase (`myMethod()`)
- **ファイル名**: snake_case (`my_file.dart`)
- **コード整形**: `flutter format .`

## 🎨 デザインテーマ
`appainter_theme.json` に定義されたデザイン設定を使用。

## 🛠️ 今後の開発予定
- **マップ機能**: 近くの卓球場やプレイヤーを表示。
- 試合結果登録機能の実装
- Eloレーティングによるランキング機能
- 団体戦のサポート
- ユーザー間マッチング: スキルレベル・地域に基づく対戦相手検索
   - 上記に伴う本人確認
- ライブ配信機能

## 📜 ライセンス
MIT License

