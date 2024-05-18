import firebase_admin
from firebase_admin import credentials, firestore
import datetime
from faker import Faker
import random
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
fake = Faker()

# ユーザーを格納するリスト
user_ids = []
clan_ids = []
event_ids = []
post_ids = []

# Users コレクションにランダムなデータを追加
users_ref = db.collection('Users')
for _ in range(10):
    user_id = fake.uuid4()
    user_ids.append(user_id)
    users_ref.document(user_id).set({
        'userId': user_id,
        'email': fake.email(),
        'displayName': fake.name(),
        'profilePicture': fake.image_url(),
        'skillLevel': random.choice(['Beginner', 'Intermediate', 'Advanced']),
        'region': fake.city(),
        'playStyle': random.choice(['Aggressive', 'Defensive', 'Balanced']),
        'createdAt': datetime.datetime.now(),
        'totalWins': random.randint(0, 50),
        'totalLosses': random.randint(0, 50),
        'winRate': round(random.uniform(0, 1), 2),
        'recentMatches': [],
        'clans': [],
        'events': [],
        'posts': []
    })

# Matches コレクションにランダムなデータを追加
matches_ref = db.collection('Matches')
for _ in range(10):
    match_id = fake.uuid4()
    player_one_id, player_two_id = random.sample(user_ids, 2)
    match_data = {
        'matchId': match_id,
        'playerOneId': player_one_id,
        'playerTwoId': player_two_id,
        'date': fake.date_time_this_year(),
        'location': fake.city(),
        'result': random.choice(['Player One won', 'Player Two won', 'Draw']),
        'winnerId': random.choice([player_one_id, player_two_id]),
        'matchDetails': fake.text(),
        'comments': fake.sentence()
    }
    matches_ref.document(match_id).set(match_data)
    users_ref.document(player_one_id).update({'recentMatches': firestore.ArrayUnion([match_id])})
    users_ref.document(player_two_id).update({'recentMatches': firestore.ArrayUnion([match_id])})

# Clans コレクションにランダムなデータを追加
clans_ref = db.collection('Clans')
for _ in range(10):
    clan_id = fake.uuid4()
    members = random.sample(user_ids, random.randint(2, 10))
    clan_data = {
        'clanId': clan_id,
        'clanName': fake.company(),
        'description': fake.text(),
        'geoPoint': firestore.GeoPoint(fake.latitude(), fake.longitude()),
        'members': members,
        'createdAt': datetime.datetime.now()
    }
    clans_ref.document(clan_id).set(clan_data)
    for member in members:
        users_ref.document(member).update({'clans': firestore.ArrayUnion([clan_id])})
    clan_ids.append(clan_id)

# Events コレクションにランダムなデータを追加
events_ref = db.collection('Events')
for _ in range(10):
    event_id = fake.uuid4()
    participants = random.sample(user_ids, random.randint(2, 10))
    event_data = {
        'eventId': event_id,
        'title': fake.catch_phrase(),
        'description': fake.text(),
        'startTime': fake.date_time_this_year(),
        'endTime': fake.date_time_this_year(),
        'location': fake.city(),
        'organizerId': random.choice(user_ids),
        'imageURL': fake.image_url(),
        'participants': participants
    }
    events_ref.document(event_id).set(event_data)
    for participant in participants:
        users_ref.document(participant).update({'events': firestore.ArrayUnion([event_id])})
    event_ids.append(event_id)

# Posts コレクションにランダムなデータを追加
posts_ref = db.collection('Posts')
for _ in range(10):
    post_id = fake.uuid4()
    author_id = random.choice(user_ids)
    post_data = {
        'postId': post_id,
        'authorId': author_id,
        'content': fake.text(),
        'postedAt': datetime.datetime.now(),
        'imageURLs': [fake.image_url() for _ in range(random.randint(1, 5))],
        'linkedEventId': random.choice([None, *event_ids])
    }
    posts_ref.document(post_id).set(post_data)
    users_ref.document(author_id).update({'posts': firestore.ArrayUnion([post_id])})
    post_ids.append(post_id)

print('Random test data added successfully.')
