Requirements to run the website:

Install latest:
- [Python](https://www.python.org/downloads/) (3.10+)
- [PostgreSQL](https://www.postgresql.org/download/)

-> In PostgreSQL create a user, password and a database, remember these. 
(You can use pgAdmin4 for a graphical interface which comes with your installation)

-> Clone the repository.

-> `pip install -r requirements.txt`

In pycharm:

-> Setup your run configuration like this:
![run configuration](https://i.imgur.com/lqFcYIz.png)

-> Set up your environment variables:
```
FLASK_APP=server.py
FLASK_DEBUG=1
MY_PSQL_DBNAME=<your_db_name>
MY_PSQL_USER=<your_username>
MY_PSQL_HOST=localhost
MY_PSQL_PASSWORD=<your_password>
```

-> Add the database

-> Run the database schema: `./data/db_schema.sql`
