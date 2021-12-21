from flask import Blueprint, render_template, request, session, redirect
from werkzeug.security import generate_password_hash, check_password_hash
user_profile_routes = Blueprint('user_profile_routes', __name__)
from dummy_data import user_profile_data

@user_profile_routes.route("/signup")
def get_register_view():
    return render_template(
        'pg_user_register.html',
        page_title="Sign Up"
    )

@user_profile_routes.route("/login")
def get_login_view():
    return render_template(
        'pg_user_login.html',
        page_title="Log In"
    )

@user_profile_routes.route("/signup", methods=["POST"])
def register_user():
    name = request.form['name']
    email = request.form['email']
    password = request.form['password']
    if name and email and password and request.method == 'POST':
        hashed_password = generate_password_hash(password)
        
    user_data = user_profile_data
    session["user_id"] = user_data["id"]
    session["user_name"] = user_data["name"]
    return redirect("/launch/index")
        