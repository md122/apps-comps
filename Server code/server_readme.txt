Server code written by Sam Neubauer and Marco Dow.

The code is our API written in Python, and using psycopg2 to connect to a PosgreSQL database. 
As of now the server is not running, however the serve does implement basic security, using GoogleAuth for storing
sensitive user data. It also implements error handing at each step in the process. The API returns values in a basic
json [error, data] format.

api.py runs using flask, and handles all of the incoming server calls, which it passes to queries.py. queries.py 
handles the database connections, SQL calls, and creation of dictionaries to hold data. Invalid queries, database connection
errors, and invalid data should raise exceptions and return a dictionary with a string explaining the failure.
