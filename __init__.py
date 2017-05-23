from flask import Flask, render_template, request, redirect, url_for, abort, session

app = Flask(__name__)
app.config['SECRET_KEY'] = 'F34TF$($e34D';

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/signup', methods=['POST'])
def signup():
    session['username'] = request.form['username']
    session['message'] = request.form['message']
    session['fileupload'] = request.form['fileupload']
    #with open(session['fileupload'], "r") as f:
    print session['fileupload'] #.read()
    #f.close()
    return redirect(url_for('message'))

@app.route('/message')
def message():
    if not 'username' in session:
        return abort(403)
    return render_template('message.html', username=session['username'], 
                                           message=session['message'], 
					   fileupload=session['fileupload'])

if __name__ == '__main__':
    app.run()
