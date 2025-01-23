"""main.py"""

from fastapi import FastAPI

app = FastAPI()


@app.get("/health")
def health():
    return {"backend_status": "ok"}
