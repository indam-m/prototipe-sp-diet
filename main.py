from flask import Flask, render_template, Markup, request, redirect
import clips

app = Flask(__name__)

@app.route("/")
def index():
	return render_template("index.html")

@app.route("/start")
def start():
	return render_template("start.html")

@app.route("/result", methods=['GET', 'POST'])
def result():
	if request.form['bb'] is not None and request.form['tb'] is not None and request.form['usia'] is not None and request.form['jk'] is not None and request.form['penyakit'] is not None and request.form['aktivitas'] is not None:
		env = clips.Environment()
		env.Load("CLIPS/templates.clp")
		env.Load("CLIPS/functions.clp")
		env.Load("CLIPS/rules.clp")
		env.Load("CLIPS/skeletal-kontrol.clp")
		bb = request.form['bb']
		tb = request.form['tb']
		usia = request.form['usia']
		jk = request.form['jk']
		aktivitas = request.form['aktivitas']
		penyakit = request.form['penyakit']
		env.BuildDeffacts("pasien", "(pasien (berat-badan " + bb + ") (tinggi-badan " + tb + ") (usia " + usia + ") (jenis-kelamin " + jk + ") (aktivitas \"" + aktivitas + "\") (penyakit \"" + penyakit + "\"))")
		env.Reset()
		env.Assert("(mulai)")
		env.Run()
		env.SaveFacts("a.txt")
		t = clips.StdoutStream.Read()
		return render_template("result.html", t=Markup(t))
	else:
		return redirect("/")

if __name__ == "__main__":
	app.run()