import firebase_admin
from firebase_admin import credentials, firestore
import os
from dotenv import load_dotenv

# .envファイルの内容を読み込む
load_dotenv()

# 環境変数からサービスアカウントキーのパスを取得
service_account_key_path = os.getenv('GOOGLE_APPLICATION_CREDENTIALS')
if not service_account_key_path:
    raise ValueError("環境変数 'GOOGLE_APPLICATION_CREDENTIALS' が設定されていません。")

# サービスアカウントキーのパスを指定
cred = credentials.Certificate(service_account_key_path)
firebase_admin.initialize_app(cred)

db = firestore.client()

# ユーザー一覧を取得する関数
def get_all_users():
    users_ref = db.collection('Users')
    users_docs = users_ref.stream()

    users = []
    for doc in users_docs:
        user_data = doc.to_dict()
        users.append(user_data)
    
    return users

# プロフィール画面用のクエリ関数
def get_user_profile(user_id):
    # ユーザーの基本情報を取得
    user_ref = db.collection('Users').document(user_id)
    user_doc = user_ref.get()
    if not user_doc.exists:
        print(f"No user found with ID {user_id}")
        return

    user_data = user_doc.to_dict()

    # 最近の試合情報を取得
    recent_matches = []
    for match_id in user_data.get('recentMatches', []):
        match_ref = db.collection('Matches').document(match_id)
        match_doc = match_ref.get()
        if match_doc.exists:
            recent_matches.append(match_doc.to_dict())
    user_data['recentMatches'] = recent_matches

    # 参加しているクランを取得
    clans = []
    for clan_id in user_data.get('clans', []):
        clan_ref = db.collection('Clans').document(clan_id)
        clan_doc = clan_ref.get()
        if clan_doc.exists:
            clans.append(clan_doc.to_dict())
    user_data['clans'] = clans

    # 参加しているイベントを取得
    events = []
    for event_id in user_data.get('events', []):
        event_ref = db.collection('Events').document(event_id)
        event_doc = event_ref.get()
        if event_doc.exists:
            events.append(event_doc.to_dict())
    user_data['events'] = events

    # ユーザーの投稿を取得
    posts = []
    for post_id in user_data.get('posts', []):
        post_ref = db.collection('Posts').document(post_id)
        post_doc = post_ref.get()
        if post_doc.exists:
            posts.append(post_doc.to_dict())
    user_data['posts'] = posts

    return user_data

# ユーザー一覧を取得
users = get_all_users()
print("ユーザー一覧:")
for user in users:
    print(user)

# テストユーザーIDを指定してプロフィール情報を取得
if users:
    test_user_id = users[0]['userId']
    profile_data = get_user_profile(test_user_id)
    print(f"\nプロフィール情報 ({test_user_id}):")
    print(profile_data)
else:
    print("ユーザーが存在しません。")
