# PingPongMix

## 環境設定

1. **Firebaseプロジェクトの設定**:
   Firebaseコンソールでプロジェクトを作成し、サービスアカウントキーをダウンロードします。

   1. Firebaseコンソールにアクセスし、新しいプロジェクトを作成します。
   2. プロジェクト設定の「サービスアカウント」タブに移動します。
   3. 「新しい秘密鍵を生成」ボタンをクリックし、JSONファイルをダウンロードします。
   4. ダウンロードしたJSONファイルを安全な場所に保存します。

2. **環境変数の設定**:
   プロジェクトルートに `.env` ファイルを作成し、以下の内容を追加します：
   ```
   GOOGLE_APPLICATION_CREDENTIALS=/path/to/your/serviceAccountKey.json
   ```

3. **必要なパッケージのインストール**:

   まず、仮想環境を作成してアクティブにします：
   ```bash
   python -m venv venv
   source venv/bin/activate  # Windowsの場合は venv\Scripts\activate
   ```

   次に、`requirements.txt` に記載されたパッケージをインストールします：
   ```bash
   pip install -r scripts/requirements.txt
   ```

## データ追加スクリプトの実行手順

1. 仮想環境をアクティブにします：
   ```bash
   source venv/bin/activate  # Windowsの場合は venv\Scripts\activate
   ```

2. データ追加スクリプトを実行します：
   ```bash
   python scripts/add_random_data.py
   ```

3. スクリプトの実行が完了したら、仮想環境を無効化します：
   ```bash
   deactivate
   ```

## プロフィール取得スクリプトの実行手順

1. 仮想環境をアクティブにします：
   ```bash
   source venv/bin/activate  # Windowsの場合は venv\Scripts\activate
   ```

2. プロフィール取得スクリプトを実行します：
   ```bash
   python scripts/get_profile.py
   ```

3. スクリプトの実行が完了したら、仮想環境を無効化します：
   ```bash
   deactivate
   ```
```
