"""Gunicorn configuration"""



wsgi_app = "app.main:app"

bind = "0.0.0.0:8080"
workers = 2
worker_class = "uvicorn.workers.UvicornWorker"


timeout = 3600

accesslog = "-"
access_log_format = (
    '%(h)s %(l)s %(u)s %(t)s "%(r)s" %(s)s %(b)s "%(f)s" "%(a)s" "%(D)s"'
)

errorlog = "-"
loglevel = "info"


