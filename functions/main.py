"""main.py"""
import os
import logging
import requests
from flask import jsonify

from src.constants import BACKEND_URL

# ロギングの設定
logging.basicConfig(level=logging.INFO)


def check_backend_health(request):
    """
    Google Cloud Function: Cloud Runのヘルスチェックを実行
    """
    if not BACKEND_URL:
        logging.error("BACKEND_URL environment variable is not set")
        return jsonify({"status": "error", "message": "Configuration error"}), 500

    try:
        # タイムアウト設定を追加
        response = requests.get(f"{BACKEND_URL}/health", timeout=10)
        response.raise_for_status()

        return jsonify({
            "status": "success",
            "response": response.json()
        }), 200

    except requests.exceptions.RequestException as e:
        logging.error(f"Request failed: {str(e)}")
        return jsonify({
            "status": "error",
            "message": f"Backend connection error: {str(e)}"
        }), 502

    except Exception as e:
        logging.error(f"Unexpected error: {str(e)}")
        return jsonify({
            "status": "error",
            "message": "Internal server error"
        }), 500


if __name__ == "__main__":
    os.environ["BACKEND_URL"] = "http://localhost:8080"
    test_response = check_backend_health(None)
    print(test_response)
