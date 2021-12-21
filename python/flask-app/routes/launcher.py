from flask import Blueprint, render_template, session
import common
launcher_routes = Blueprint('launcher_routes', __name__)

@launcher_routes.route("/")
def get_home():
    return render_template(
        'pg_launch.html',
        page_title="Home Page!"
    )

@launcher_routes.route("/somethingelse")
def get_home():
    if common.is_logged_in():
        return render_template(
            'page_home.html',
            page_title="Logged In!"
        )
    else:
        return render_template(
            'page_user_register.html',
            page_title="Sign Up"
        )
