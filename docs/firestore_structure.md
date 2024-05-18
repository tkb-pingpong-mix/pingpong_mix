# Firestore データベース構造定義書

## コレクションとフィールドの定義

### 1. Users コレクション
- **概要**: ユーザーのプロファイルと設定を保存します。
- **ドキュメントID**: `userId` (Firebase Auth の UID)
- **フィールド**:
  - `userId`: ユーザーID（ドキュメントIDと同じ）
  - `email`: メールアドレス
  - `displayName`: 表示名
  - `profilePicture`: プロフィール画像URL
  - `skillLevel`: スキルレベル（例: Beginner, Intermediate, Advanced）
  - `region`: 活動地域
  - `playStyle`: プレイスタイル（例: Aggressive, Defensive, Balanced）
  - `createdAt`: アカウント作成日時
  - `totalWins`: 勝利数
  - `totalLosses`: 敗北数
  - `winRate`: 勝率
  - `recentMatches`: 最近の試合のリスト（`Matches` コレクションの参照）
  - `clans`: 参加しているクランのリスト（`Clans` コレクションの参照）
  - `events`: 参加しているイベントのリスト（`Events` コレクションの参照）
  - `posts`: 作成した投稿のリスト（`Posts` コレクションの参照）

### 2. Matches コレクション
- **概要**: ユーザー間の試合の記録と戦績を管理します。
- **ドキュメントID**: `matchId` (自動生成)
- **フィールド**:
  - `matchId`: 試合ID（ドキュメントIDと同じ）
  - `playerOneId`: プレイヤー1のユーザーID
  - `playerTwoId`: プレイヤー2のユーザーID
  - `date`: 試合日時
  - `location`: 試合場所
  - `result`: 試合結果（例: Player One won, Player Two won, Draw）
  - `winnerId`: 勝者のユーザーID
  - `matchDetails`: 試合の詳細
  - `comments`: 試合に関するコメント

### 3. Chats コレクション
- **概要**: ユーザー間のチャット履歴を管理します。
- **ドキュメントID**: チャットID
- **サブコレクション**: `Messages`
  - **フィールド**:
    - `messageId`: メッセージID（自動生成）
    - `senderId`: 送信者のユーザーID
    - `text`: メッセージ内容
    - `sentAt`: 送信日時

### 4. Clans コレクション
- **概要**: クラン（グループ）情報を管理します。
- **ドキュメントID**: `clanId` (自動生成)
- **フィールド**:
  - `clanId`: クランID（ドキュメントIDと同じ）
  - `clanName`: クラン名
  - `description`: クランの詳細説明
  - `geoPoint`: 活動場所の地理座標
  - `members`: メンバーのユーザーIDリスト
  - `createdAt`: クラン作成日時

### 5. Events コレクション
- **概要**: イベント情報を管理します。
- **ドキュメントID**: `eventId` (自動生成)
- **フィールド**:
  - `eventId`: イベントID（ドキュメントIDと同じ）
  - `title`: イベントタイトル
  - `description`: イベント詳細説明
  - `startTime`: イベント開始時刻
  - `endTime`: イベント終了時刻
  - `location`: 開催場所
  - `organizerId`: 主催者のユーザーID
  - `imageURL`: イベントのイメージ画像URL
  - `participants`: 参加者リスト

### 6. Posts コレクション
- **概要**: ユーザーが作成する一般的な投稿を管理します。
- **ドキュメントID**: `postId` (自動生成)
- **フィールド**:
  - `postId`: 投稿ID（ドキュメントIDと同じ）
  - `authorId`: 投稿者のユーザーID
  - `content`: 投稿内容
  - `postedAt`: 投稿日時
  - `imageURLs`: 投稿に含まれる画像のURLリスト
  - `linkedEventId`: 関連付けられたイベントID（オプション）

---

### データベース構造の例

#### Users コレクションの例
```json
{
  "userId": "user123",
  "email": "user123@example.com",
  "displayName": "John Doe",
  "profilePicture": "https://example.com/profile.jpg",
  "skillLevel": "Intermediate",
  "region": "Tokyo",
  "playStyle": "Balanced",
  "createdAt": "2024-01-01T12:00:00Z",
  "totalWins": 15,
  "totalLosses": 10,
  "winRate": 0.6,
  "recentMatches": ["match123", "match456"],
  "clans": ["clan123"],
  "events": ["event123"],
  "posts": ["post123"]
}
```

#### Matches コレクションの例
```json
{
  "matchId": "match123",
  "playerOneId": "user123",
  "playerTwoId": "user456",
  "date": "2024-01-01T12:00:00Z",
  "location": "Tokyo",
  "result": "Player One won",
  "winnerId": "user123",
  "matchDetails": "Exciting match!",
  "comments": "Great game!"
}
```

#### Clans コレクションの例
```json
{
  "clanId": "clan123",
  "clanName": "PingPong Masters",
  "description": "A clan for advanced ping pong players.",
  "geoPoint": {"latitude": 35.6895, "longitude": 139.6917},
  "members": ["user123", "user456"],
  "createdAt": "2024-01-01T12:00:00Z"
}
```

#### Events コレクションの例
```json
{
  "eventId": "event123",
  "title": "Spring PingPong Tournament",
  "description": "Join us for a fun tournament this spring!",
  "startTime": "2024-03-20T09:00:00Z",
  "endTime": "2024-03-20T18:00:00Z",
  "location": "Tokyo Sports Center",
  "organizerId": "user123",
  "imageURL": "https://example.com/event.jpg",
  "participants": ["user123", "user456"]
}
```

#### Posts コレクションの例
```json
{
  "postId": "post123",
  "authorId": "user123",
  "content": "Had a great time at the tournament today!",
  "postedAt": "2024-03-20T19:00:00Z",
  "imageURLs": ["https://example.com/photo1.jpg", "https://example.com/photo2.jpg"],
  "linkedEventId": "event123"
}
```
