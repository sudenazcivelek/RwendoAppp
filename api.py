from flask import Flask, jsonify, Response
import firebase_admin
from firebase_admin import credentials, firestore
import json

# Firebase Admin SDK ile kimlik doğrulama
cred = credentials.Certificate("database.json")  # Firebase hizmet hesabı anahtarınızın yolu
firebase_admin.initialize_app(cred)

# Firestore istemcisi oluşturun
db = firestore.client()

# Flask uygulamasını oluşturun
app = Flask(__name__)

@app.route('/get_landmarks', methods=['GET'])
def get_landmarks():
    collection_name = "landmarks"
    landmarks_ref = db.collection(collection_name)
    landmarks = [doc.to_dict() for doc in landmarks_ref.stream()]
    print(landmarks)
    return Response(
        json.dumps(landmarks, ensure_ascii=False, indent=2),
        mimetype='application/json'
    )

@app.route('/get_hikes', methods=['GET'])
def get_hikes():
    collection_name = "hikes"
    landmarks_ref = db.collection(collection_name)
    landmarks = [doc.to_dict() for doc in landmarks_ref.stream()]
    print(landmarks)
    return Response(
        json.dumps(landmarks, ensure_ascii=False, indent=2),
        mimetype='application/json'
    )
if __name__ == '__main__':
    app.run(debug=True)


