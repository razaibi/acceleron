import os

from flask import Flask
from flask_sqlalchemy import SQLAlchemy
import secrets
import string

from routes.launcher import launcher_routes
from routes.template import template_routes
from routes.userprofile import user_profile_routes

app = Flask(__name__)

app.register_blueprint(launcher_routes, url_prefix="/launch")
app.register_blueprint(template_routes, url_prefix="/templates")
app.register_blueprint(user_profile_routes, url_prefix="/user")

#app.config.from_object(os.environ['APP_SETTINGS'])
alphabet = string.ascii_letters + string.digits
appkey = ''.join(secrets.choice(alphabet) for i in range(64))

app.config['SECRET_KEY'] = appkey
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

if __name__ == "__main__":
    app.run()
