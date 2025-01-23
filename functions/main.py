"""main.py"""
import requests

from src.constants import BACKEND_URL


def check_backend_health(request):
    """
    Google Cloud Function: Cloud Runのヘルスチェックを実行します。
    """
    try:
        # Cloud RunのヘルスチェックエンドポイントにGETリクエストを送信
        response = requests.get(BACKEND_URL + "/health")
        response.raise_for_status()

        return {
            "status": "success",
            "response": response.json(),
        }
    except requests.exceptions.RequestException as e:
        return {
            "status": "error",
            "error": str(e),
        }


def main() -> None:
    return check_backend_health()


if __name__ == "__main__":
    main()
