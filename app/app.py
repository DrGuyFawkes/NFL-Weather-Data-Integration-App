from flask import Flask, request, render_template
import sqlite3
import os

app = Flask(__name__)

# Function to get SQL query results
def execute_query(query):
    db_path = os.path.join(os.path.dirname(__file__), '../data/weather_data.db')
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    try:
        cursor.execute(query)
        results = cursor.fetchall()
        column_names = [description[0] for description in cursor.description]
        conn.close()
        return column_names, results
    except Exception as e:
        conn.close()
        return [], str(e)

# Route for the home page
@app.route('/', methods=['GET', 'POST'])
def home():
    results = []
    column_names = []
    error = None
    query = ""
    if request.method == 'POST':
        query = request.form['query']
        if query:
            column_names, results = execute_query(query)
            if isinstance(results, str):
                error = results
                results = []
    return render_template('index.html', query=query, column_names=column_names, results=results, error=error)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
