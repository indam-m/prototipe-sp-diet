(deffunction hitung-amb-laki (?bb ?tb ?u)
	(round (+ 66 (* 13.7 ?bb) (* 5 ?tb) (- 0 (* 6.8 ?u)))))

(deffunction hitung-amb-perempuan (?bb ?tb ?u)
	(round (+ 655 (* 9.6 ?bb) (* 1.8 ?tb) (- 0 (* 4.7 ?u)))))

(deffunction output-kategori-berat-badan (?kat)
	(switch ?kat
		(case -2 then "Kurus berat")
		(case -1 then "Kurus ringan")
		(case 1 then "Gemuk ringan")
		(case 2 then "Gemuk berat")
		(default "Sedang")))

(deffunction ubah-satu-desimal (?angka)
	(if (or (= (mod (round (* ?angka 100)) 100) 25) (= (mod (round (* ?angka 100)) 100) 75) (= (mod (round (* ?angka 100)) 100) 33) (= (mod (round (* ?angka 100)) 100) 67)) then (/ (round (* ?angka 100)) 100)
		else (/ (round (* ?angka 10)) 10)))

(deffunction output-golongan-makanan (?gol)
	(switch ?gol
		(case 1 then "<option value=\"\">------ Sumber Hidrat Arang ------</option>")
        (case 2 then "<option value=\"\">---- Sumber Protein Hewani -----</option>")
        (case 3 then "<option value=\"\">----- Sumber Protein Nabati -----</option>")
        (case 4 then "<option value=\"\">------------ Sayuran ------------</option>")
        (case 5 then "<option value=\"\">--------- Buah atau Gula --------</option>")
        (case 6 then "<option value=\"\">------------- Susu --------------</option>")
        (case 7 then "<option value=\"\">------------ Minyak -------------</option>")
        (default " ")))

(deffunction output-list-bahan-makanan-utama (?waktu ?penyakit ?td)
	(bind ?out "")
	(loop-for-count (?i 1 7) do
		(if (any-factp ((?f solusi-menu)) (and (eq ?f:waktu ?waktu) (= ?f:golongan ?i))) then
			(if (> ?i 1) then (bind ?out (str-cat ?out "<br>")))
			(bind ?out (str-cat ?out "<select id=\"" ?waktu "-" ?i "\" class=\"form-control selcls\" id=\"a\">"))
			(bind ?out (str-cat ?out (output-golongan-makanan ?i)))
			(if (= ?i 2) then
				(if (any-factp ((?f solusi-menu)) (and (eq ?f:waktu ?waktu) (= ?f:golongan ?i) (eq ?f:lemak sedang))) then 
					(bind ?out (str-cat ?out "<option value=\"\">-- rendah lemak --</option>")))
				(do-for-all-facts ((?bahan solusi-menu)) (and (eq ?bahan:waktu ?waktu) (= ?bahan:golongan ?i) (eq ?bahan:lemak rendah))
					(bind ?out (str-cat ?out "<option>" ?bahan:nama "  " ?bahan:berat " gr / " (nth$ 1 ?bahan:URT) " " (nth$ 2 ?bahan:URT) "</option>")))
				(if (any-factp ((?f solusi-menu)) (and (eq ?f:waktu ?waktu) (= ?f:golongan ?i) (eq ?f:lemak sedang))) then 
					(bind ?out (str-cat ?out "<option value=\"\">-- lemak sedang --</option>")))
				(do-for-all-facts ((?bahan solusi-menu)) (and (eq ?bahan:waktu ?waktu) (= ?bahan:golongan ?i) (eq ?bahan:lemak sedang))
					(bind ?out (str-cat ?out "<option>" ?bahan:nama "  " ?bahan:berat " gr / " (nth$ 1 ?bahan:URT) " " (nth$ 2 ?bahan:URT) "</option>")))
				(if (any-factp ((?f solusi-menu)) (and (eq ?f:waktu ?waktu) (= ?f:golongan ?i) (eq ?f:lemak tinggi))) then
					(bind ?out (str-cat ?out "<option value=\"\">-- tinggi lemak --</option>")))
				(do-for-all-facts ((?bahan solusi-menu)) (and (eq ?bahan:waktu ?waktu) (= ?bahan:golongan ?i) (eq ?bahan:lemak tinggi))
					(bind ?out (str-cat ?out "<option>" ?bahan:nama "  " ?bahan:berat " gr / " (nth$ 1 ?bahan:URT) " " (nth$ 2 ?bahan:URT) "</option>")))
			)
			(if (= ?i 6) then
				(if (any-factp ((?f solusi-menu)) (and (eq ?f:waktu ?waktu) (= ?f:golongan ?i) (eq ?f:lemak sedang))) then 
					(bind ?out (str-cat ?out "<option value=\"\">-- tanpa lemak --</option>")))
				(do-for-all-facts ((?bahan solusi-menu)) (and (eq ?bahan:waktu ?waktu) (= ?bahan:golongan ?i) (eq ?bahan:lemak tanpa))
					(bind ?out (str-cat ?out "<option>" ?bahan:nama "  " ?bahan:berat " gr / " (nth$ 1 ?bahan:URT) " " (nth$ 2 ?bahan:URT) "</option>")))
				(if (any-factp ((?f solusi-menu)) (and (eq ?f:waktu ?waktu) (= ?f:golongan ?i) (eq ?f:lemak rendah))) then 
					(bind ?out (str-cat ?out "<option value=\"\">-- rendah lemak --</option>")))
				(do-for-all-facts ((?bahan solusi-menu)) (and (eq ?bahan:waktu ?waktu) (= ?bahan:golongan ?i) (eq ?bahan:lemak rendah))
					(bind ?out (str-cat ?out "<option>" ?bahan:nama "  " ?bahan:berat " gr / " (nth$ 1 ?bahan:URT) " " (nth$ 2 ?bahan:URT) "</option>")))
				(if (any-factp ((?f solusi-menu)) (and (eq ?f:waktu ?waktu) (= ?f:golongan ?i) (eq ?f:lemak rendah))) then
					(bind ?out (str-cat ?out "<option value=\"\">-- tinggi lemak --</option>")))
				(do-for-all-facts ((?bahan solusi-menu)) (and (eq ?bahan:waktu ?waktu) (= ?bahan:golongan ?i) (eq ?bahan:lemak tinggi))
					(bind ?out (str-cat ?out "<option>" ?bahan:nama "  " ?bahan:berat " gr / " (nth$ 1 ?bahan:URT) " " (nth$ 2 ?bahan:URT) "</option>")))
			)
			(if (= ?i 7) then
				(if (any-factp ((?f solusi-menu)) (and (eq ?f:waktu ?waktu) (= ?f:golongan ?i) (eq ?f:lemak jenuh))) then 
					(bind ?out (str-cat ?out "<option value=\"\">-- lemak tidak jenuh --</option>")))
				(do-for-all-facts ((?bahan solusi-menu)) (and (eq ?bahan:waktu ?waktu) (= ?bahan:golongan ?i) (eq ?bahan:lemak tak-jenuh))
					(bind ?out (str-cat ?out "<option>" ?bahan:nama "  " ?bahan:berat " gr / " (nth$ 1 ?bahan:URT) " " (nth$ 2 ?bahan:URT) "</option>")))
				(if (any-factp ((?f solusi-menu)) (and (eq ?f:waktu ?waktu) (= ?f:golongan ?i) (eq ?f:lemak jenuh))) then 
					(bind ?out (str-cat ?out "<option value=\"\">-- lemak jenuh --</option>")))
				(do-for-all-facts ((?bahan solusi-menu)) (and (eq ?bahan:waktu ?waktu) (= ?bahan:golongan ?i) (eq ?bahan:lemak jenuh))
					(bind ?out (str-cat ?out "<option>" ?bahan:nama "  " ?bahan:berat " gr / " (nth$ 1 ?bahan:URT) " " (nth$ 2 ?bahan:URT) "</option>")))
			)
			(if (and (<> ?i 2) (<> ?i 6) (<> ?i 7)) then 
				(do-for-all-facts ((?bahan solusi-menu)) (and (eq ?bahan:waktu ?waktu) (= ?bahan:golongan ?i))
					(bind ?out (str-cat ?out "<option>" ?bahan:nama "  " ?bahan:berat " gr / " (nth$ 1 ?bahan:URT) " " (nth$ 2 ?bahan:URT) "</option>")))
			)
			(bind ?out (str-cat ?out "</select>"))
		)
		(if (= ?i 3) then 
			(bind ?out (str-cat ?out "<br>"))
			(bind ?out (str-cat ?out "<select id=\"" ?waktu "-A" "\" class=\"form-control selcls\" id=\"a\">"))
			(bind ?out (str-cat ?out "<option value=\"\">-- Sayuran A (sekehendaknya) ---</option>"))
			(do-for-all-facts ((?SA sayuran-A))
				(and (if (eq ?penyakit "Jantung") then (neq ?SA:serat tinggi) else true) (if (eq ?td tinggi-serat) then (or (eq ?SA:serat tinggi) (eq ?SA:serat nul)) else true))
				(bind ?out (str-cat ?out "<option value=\"" ?SA:nama " (sekehendaknya)\">" ?SA:nama "</option>")))
			(bind ?out (str-cat ?out "</select>")))

		(if (= ?i 7) then (break))
	)
	?out)

(deffunction output-list-bahan-makanan-snack (?waktu)
	(bind ?out "")
	(loop-for-count (?i 5 6) do
		(if (any-factp ((?f solusi-menu)) (and (eq ?f:waktu ?waktu) (= ?f:golongan ?i))) then
			(if (> ?i 5) then (bind ?out (str-cat ?out "<br>")))
			(bind ?out (str-cat ?out "<select id=\"" ?waktu "-" ?i "\" class=\"form-control selcls\" id=\"a\">"))
			(bind ?out (str-cat ?out (output-golongan-makanan ?i)))
			(if (= ?i 6) then
				(if (any-factp ((?f solusi-menu)) (and (eq ?f:waktu ?waktu) (= ?f:golongan ?i) (eq ?f:lemak rendah))) then 
					(bind ?out (str-cat ?out "<option value=\"\">-- tanpa lemak --</option>")))
				(do-for-all-facts ((?bahan solusi-menu)) (and (eq ?bahan:waktu ?waktu) (= ?bahan:golongan ?i) (eq ?bahan:lemak tanpa))
					(bind ?out (str-cat ?out "<option>" ?bahan:nama "  " ?bahan:berat " gr / " (nth$ 1 ?bahan:URT) " " (nth$ 2 ?bahan:URT) "</option>")))
				(if (any-factp ((?f solusi-menu)) (and (eq ?f:waktu ?waktu) (= ?f:golongan ?i) (eq ?f:lemak rendah))) then 
					(bind ?out (str-cat ?out "<option value=\"\">-- rendah lemak --</option>")))
				(do-for-all-facts ((?bahan solusi-menu)) (and (eq ?bahan:waktu ?waktu) (= ?bahan:golongan ?i) (eq ?bahan:lemak rendah))
					(bind ?out (str-cat ?out "<option>" ?bahan:nama "  " ?bahan:berat " gr / " (nth$ 1 ?bahan:URT) " " (nth$ 2 ?bahan:URT) "</option>")))
				(if (any-factp ((?f solusi-menu)) (and (eq ?f:waktu ?waktu) (= ?f:golongan ?i) (eq ?f:lemak tinggi))) then
					(bind ?out (str-cat ?out "<option value=\"\">-- tinggi lemak --</option>")))
				(do-for-all-facts ((?bahan solusi-menu)) (and (eq ?bahan:waktu ?waktu) (= ?bahan:golongan ?i) (eq ?bahan:lemak tinggi))
					(bind ?out (str-cat ?out "<option>" ?bahan:nama "  " ?bahan:berat " gr / " (nth$ 1 ?bahan:URT) " " (nth$ 2 ?bahan:URT) "</option>")))
			)
			(if (<> ?i 6) then 
				(do-for-all-facts ((?bahan solusi-menu)) (and (eq ?bahan:waktu ?waktu) (= ?bahan:golongan ?i))
					(bind ?out (str-cat ?out "<option>" ?bahan:nama "  " ?bahan:berat " gr / " (nth$ 1 ?bahan:URT) " " (nth$ 2 ?bahan:URT) "</option>")))
			)
			(bind ?out (str-cat ?out "</select>"))
		)
		(if (= ?i 6) then (break))
	)
	?out)
