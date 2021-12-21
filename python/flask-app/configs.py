import os
basedir = os.path.abspath(os.path.dirname(__file__))

class Config(object):
    DEBUG = False
    TESTING = False
    CSRF_ENABLED = True
    SECRET_KEY = 'this-really-needs-to-be-changed'
    SQLALCHEMY_DATABASE_URI = os.environ['DATABASE_URL']
    #Queueing Microservice
    ENDPOINT_QUEUEING_SERVICE=''

class ProductionConfig(Config):
    DEBUG = False

class StagingConfig(Config):
    DEVELOPMENT = True
    DEBUG = True

class DevelopmentConfig(Config):
    DEVELOPMENT = True
    DEBUG = True

class TestingConfig(Config):
    TESTING = True



#Authentication
#GOOGLE_CLIENT_ID = os.environ.get("", None)
#GOOGLE_CLIENT_SECRET = os.environ.get("", None)
GOOGLE_CLIENT_ID = ''
GOOGLE_CLIENT_SECRET = ''
GOOGLE_DISCOVERY_URL = ''

#App Secret
APP_SECRET=''



