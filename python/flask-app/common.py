from flask import session

def is_logged_in():
    if "user_id" in session:
        if session["user_id"] is not None:
            return True
        else:
            return False
    else:
        return False