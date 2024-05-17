curl -X POST -d '{"username":"newuser","password":"newpassword"}' \
     -H "Content-Type: application/json" \
     http://localhost:8080/register

curl -X POST -d '{"username":"admin","password":"admin.123"}' \
     -H "Content-Type: application/json" \
     -H "X-API-Key: YourSecretAPIKey123" \
     http://localhost:8080/register-admin


curl -X POST -d '{"username":"admin","password":"admin.123"}' \
     -H "Content-Type: application/json" \
     http://localhost:8080/token


curl -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFkbWluIiwicm9sZXMiOlsiYWRtaW4iXSwiZXhwIjoxNzE1NzA4NDkzfQ.9M0_pbBOPfbUmaSc9ox58g5TnAVZAwODbKfsjMx6ANE" \
     http://localhost:8080/secured
