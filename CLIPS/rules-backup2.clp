(defrule init-run
	(declare (salience 99))
	?mulai <- (mulai)
	?pasien <- (pasien (usia ?u) (jenis-kelamin ?jk) (tinggi-badan ?tb) (berat-badan ?bb))
	=>
	(retract ?mulai)
	(load-facts "CLIPS/skeletal-model-sementara-3.dat")
	(load-facts "CLIPS/standar-diet.dat")
	(load-facts "CLIPS/bahan-makanan-2.dat")
	(assert (queue a))
	(assert (solusi-pembagian-kalori))
	(printout t "
      <div class=\"row\">
        <div class=\"col-sm-1\"></div>
        <div class=\"col-sm-5\">
          <div class=\"row\">
            <div class=\"col-sm-5\"><b>Jenis kelamin</b></div>
            <div class=\"col-sm-5\">" ?jk "</div>
          </div>
          <div class=\"row\">
            <div class=\"col-sm-5\"><b>Usia</b></div>
            <div class=\"col-sm-5\">" ?u " tahun</div>
          </div>
          <div class=\"row\">
            <div class=\"col-sm-5\"><b>Tinggi badan</b></div>
            <div class=\"col-sm-5\">" ?tb " cm</div>
          </div>
          <div class=\"row\">
            <div class=\"col-sm-5\"><b>Berat badan</b></div>
            <div class=\"col-sm-5\">" ?bb " kg</div>
          </div>
          <div class=\"row\">
            <div class=\"col-sm-5\"><b>Penyakit</b></div>
            <div class=\"col-sm-5\">-</div>
          </div>
        </div>
    ")
)

; ?bb dalam kg, ?tb dalam cm, amb dalam kkal

(defrule hitung-amb
	(declare (salience 15))
	?aksi <- (aksi HITUNG-AMB)
	?data <- (pasien (berat-badan ?bb) (tinggi-badan ?tb) (jenis-kelamin ?jk) (usia ?u) (AMB ?amb))
	=>
	(retract ?aksi)
	(if (eq ?jk Laki-laki) then (modify ?data (AMB (hitung-amb-laki ?bb ?tb ?u)))
		else (modify ?data (AMB (hitung-amb-perempuan ?bb ?tb ?u)))
	)
	;(printout t "AMB " ?amb crlf)
)

(defrule hitung-imt
	(declare (salience 11))
	?aksi <- (aksi HITUNG-IMT)
	?data <- (pasien (berat-badan ?bb) (tinggi-badan ?tb) (IMT ?imt))
	=>
	(retract ?aksi)
	(modify ?data (IMT (ubah-satu-desimal (/ ?bb (* (/ ?tb 100) (/ ?tb 100))))))
	;(printout t "IMT adalah " ?imt crlf)
)

(defrule tentukan-tipe-badan
	(declare (salience 10))
	?aksi <- (aksi TENTUKAN-TIPE-BADAN)
	?data <- (pasien (IMT ?imt) (tipe-badan ?tipe))
	=>
	(retract ?aksi)
	(if (<= ?imt 18.5) then
		(if (< ?imt 17) then (modify ?data (tipe-badan -2)) else
			(modify ?data (tipe-badan -1))
		) else
			(if (> ?imt 25) then
				(if (> ?imt 27) then (modify ?data (tipe-badan 2)) else
					(modify ?data (tipe-badan 1))
				) else
				(modify ?data (tipe-badan 0))
			)
	)
	;(printout t "Tipe badan " ?tipe crlf)
)

(defrule hitung-kebutuhan-kalori
	(declare (salience 10))
	?aksi <- (aksi HITUNG-KEBUTUHAN-KALORI)
	?data <- (pasien (AMB ?amb) (jenis-kelamin ?jk) (tipe-badan ?tipe) (kebutuhan-kalori-total ?kal))
	=>
	(retract ?aksi)
	(if (< ?tipe 0) then 
		(bind ?kalori (+ ?amb 500))
		(modify ?data (kebutuhan-kalori-total (+ ?amb 500))) else
			(if (> ?tipe 0) then
				(bind ?kalori (- ?amb 500))
				(modify ?data (kebutuhan-kalori-total (- ?amb 500))) else
					(bind ?kalori ?amb)
					(modify ?data (kebutuhan-kalori-total ?amb)))
	)
	(if (<= ?kalori 1200) then (bind ?kelompok 1100))
	(if (and (> ?kalori 1200) (<= ?kalori 1400)) then (bind ?kelompok 1300))
	(if (and (> ?kalori 1400) (<= ?kalori 1600)) then (bind ?kelompok 1500))
	(if (and (> ?kalori 1600) (<= ?kalori 1800)) then (bind ?kelompok 1700))
	(if (and (> ?kalori 1800) (<= ?kalori 2000)) then (bind ?kelompok 1900))
	(if (and (> ?kalori 2000) (<= ?kalori 2200)) then (bind ?kelompok 2100))
	(if (and (> ?kalori 2200) (<= ?kalori 2400)) then (bind ?kelompok 2300))
	(if (> ?kalori 2400) then (bind ?kelompok 2500))
	(assert (kelompok-kalori ?kelompok))
	;(printout t "Kebutuhan kalori total " ?kalori crlf)
)

(defrule tentukan-tipe-diet
	(declare (salience 9))
	?aksi <- (aksi TENTUKAN-TIPE-DIET)
	?pasien <- (pasien (penyakit ?penyakit))
	=>
	(retract ?aksi)
	(assert (goal PENETAPAN-DIET-BIASA))
)

(defrule tetapkan-diet-biasa
	(declare (salience 9))
	?aksi <- (aksi TETAPKAN-DIET-BIASA)
	=>
	(retract ?aksi)
	(assert (tipe-diet biasa))
)

(defrule tetapkan-diet-diabetes
	(declare (salience 9))
	?aksi <- (aksi TETAPKAN-DIET-DIABETES)
	=>
	(retract ?aksi)
	(assert (tipe-diet diabetes))
)

(defrule tetapkan-diet-rendah-purin
	(declare (salience 9))
	?aksi <- (aksi TETAPKAN-DIET-RENDAH-PURIN)
	=>
	(retract ?aksi)
	(assert (tipe-diet rendah-purin))
)

(defrule tetapkan-diet-rendah-serat
	(declare (salience 9))
	?aksi <- (aksi TETAPKAN-DIET-RENDAH-SERAT)
	=>
	(retract ?aksi)
	(assert (tipe-diet rendah-serat))
)

(defrule tentukan-diet-lemak
	(declare (salience 9))
	?aksi <- (aksi TENTUKAN-DIET-LEMAK)
	?pasien <- (pasien (tipe-badan ?tipe-badan))
	=>
	(retract ?aksi)
	(if (> ?tipe-badan 0) then (assert (goal DENGAN-DIET-RENDAH-LEMAK))
		else (assert (goal TANPA-DIET-RENDAH-LEMAK)))
)

(defrule tetapkan-diet-dengan-rendah-lemak
	(declare (salience 9))
	?aksi <- (aksi TETAPKAN-DENGAN-DIET-RENDAH-LEMAK)
	=>
	(retract ?aksi)
	(assert (rendah-lemak ya))
)

(defrule tetapkan-diet-tanpa-rendah-lemak
	(declare (salience 9))
	?aksi <- (aksi TETAPKAN-TANPA-DIET-RENDAH-LEMAK)
	=>
	(retract ?aksi)
	(assert (rendah-lemak tidak))
)

(defrule tentukan-menu-pagi
	(declare (salience -5))
	?aksi <- (aksi TENTUKAN-MENU-PAGI)
	?pasien <- (pasien (kebutuhan-kalori-total ?kekal))
	?pembagian-kalori <- (solusi-pembagian-kalori (karbohidrat-pagi-malam ?kpma ?kpmb) (protein-pagi-malam ?ppma ?ppmb) (lemak-pagi-malam ?lpma ?lpmb))
	?kelompok-kalori <- (kelompok-kalori ?kelompok)
	?standar-diet <- (standar-diet (kalori ?kelompok) (pagi $?pagi))
	=>
	(retract ?aksi)
	(bind ?kalori-pagi (* ?kekal 0.2))
	(bind ?s1 (nth$ 1 $?pagi))
	(bind ?s2 (nth$ 2 $?pagi))
	(bind ?s3 (nth$ 3 $?pagi))
	(bind ?s4 (nth$ 4 $?pagi))
	(bind ?s5 (nth$ 5 $?pagi))
	(bind ?s6 (nth$ 6 $?pagi))
	(bind ?s7 (nth$ 7 $?pagi))
	(do-for-all-facts ((?n1 nutrisi-bahan-makanan) (?n2 nutrisi-bahan-makanan)
			(?n3 nutrisi-bahan-makanan) (?n4 nutrisi-bahan-makanan) (?n5 nutrisi-bahan-makanan)
			(?n6 nutrisi-bahan-makanan) (?n7 nutrisi-bahan-makanan))
		(and (= ?n1:tipe ?n2:tipe ?n3:tipe ?n4:tipe ?n5:tipe ?n6:tipe ?n7:tipe)
			(= ?n1:golongan 1) (= ?n2:golongan 2) (= ?n3:golongan 3) (= ?n4:golongan 4)
			(= ?n5:golongan 5) (= ?n6:golongan 6) (= ?n7:golongan 7)
		)
		(bind ?kalori (+ (* ?n1:kalori ?s1) (* ?n2:kalori ?s2) (* ?n3:kalori ?s3) (* ?n4:kalori ?s4) (* ?n5:kalori ?s5) (* ?n6:kalori ?s6) (* ?n7:kalori ?s7)))
		(bind ?protein (+ (* ?n1:protein ?s1) (* ?n2:protein ?s2) (* ?n3:protein ?s3) (* ?n4:protein ?s4) (* ?n5:protein ?s5) (* ?n6:protein ?s6) (* ?n7:protein ?s7)))
		(bind ?karbo (+ (* ?n1:karbohidrat ?s1) (* ?n2:karbohidrat ?s2) (* ?n3:karbohidrat ?s3) (* ?n4:karbohidrat ?s4) (* ?n5:karbohidrat ?s5) (* ?n6:karbohidrat ?s6) (* ?n7:karbohidrat ?s7)))
		(bind ?lemak (+ (* ?n1:lemak ?s1) (* ?n2:lemak ?s2) (* ?n3:lemak ?s3) (* ?n4:lemak ?s4) (* ?n5:lemak ?s5) (* ?n6:lemak ?s6) (* ?n7:lemak ?s7)))

		(bind ?satuan-baru ?s1 ?s2 ?s3 ?s4 ?s5 ?s6 ?s7)
		(do-for-all-facts ((?bahan bahan-makanan))
			(and (= ?n1:tipe ?bahan:tipe) (> (nth$ ?bahan:golongan ?satuan-baru) 0))
			(bind ?pengali (nth$ ?bahan:golongan ?satuan-baru))
			(assert (solusi-menu (nama ?bahan:nama) (tipe ?bahan:tipe) (golongan ?bahan:golongan) (waktu pagi) (berat (round (* ?bahan:berat ?pengali))) (satuan (ubah-satu-desimal (* (nth$ 1 ?bahan:satuan) ?pengali)) (nth$ 2 ?bahan:satuan))))
		)
	)
)

(defrule tentukan-menu-siang
	(declare (salience -5))
	?aksi <- (aksi TENTUKAN-MENU-SIANG)
	?pasien <- (pasien (kebutuhan-kalori-total ?kekal))
	?pembagian-kalori <- (solusi-pembagian-kalori (karbohidrat-siang ?ksa ?ksb) (protein-siang ?psa ?psb) (lemak-siang ?lsa ?lsb))
	?kelompok-kalori <- (kelompok-kalori ?kelompok)
	?standar-diet <- (standar-diet (kalori ?kelompok) (siang $?siang))
	=>
	(retract ?aksi)
	(bind ?kalori-siang (* ?kekal 0.2))
	(bind ?s1 (nth$ 1 $?siang))
	(bind ?s2 (nth$ 2 $?siang))
	(bind ?s3 (nth$ 3 $?siang))
	(bind ?s4 (nth$ 4 $?siang))
	(bind ?s5 (nth$ 5 $?siang))
	(bind ?s6 (nth$ 6 $?siang))
	(bind ?s7 (nth$ 7 $?siang))
	(do-for-all-facts ((?n1 nutrisi-bahan-makanan) (?n2 nutrisi-bahan-makanan)
			(?n3 nutrisi-bahan-makanan) (?n4 nutrisi-bahan-makanan) (?n5 nutrisi-bahan-makanan)
			(?n6 nutrisi-bahan-makanan) (?n7 nutrisi-bahan-makanan))
		(and (= ?n1:tipe ?n2:tipe ?n3:tipe ?n4:tipe ?n5:tipe ?n6:tipe ?n7:tipe)
			(= ?n1:golongan 1) (= ?n2:golongan 2) (= ?n3:golongan 3) (= ?n4:golongan 4)
			(= ?n5:golongan 5) (= ?n6:golongan 6) (= ?n7:golongan 7)
		)
		(bind ?kalori (+ (* ?n1:kalori ?s1) (* ?n2:kalori ?s2) (* ?n3:kalori ?s3) (* ?n4:kalori ?s4) (* ?n5:kalori ?s5) (* ?n6:kalori ?s6) (* ?n7:kalori ?s7)))
		(bind ?protein (+ (* ?n1:protein ?s1) (* ?n2:protein ?s2) (* ?n3:protein ?s3) (* ?n4:protein ?s4) (* ?n5:protein ?s5) (* ?n6:protein ?s6) (* ?n7:protein ?s7)))
		(bind ?karbo (+ (* ?n1:karbohidrat ?s1) (* ?n2:karbohidrat ?s2) (* ?n3:karbohidrat ?s3) (* ?n4:karbohidrat ?s4) (* ?n5:karbohidrat ?s5) (* ?n6:karbohidrat ?s6) (* ?n7:karbohidrat ?s7)))
		(bind ?lemak (+ (* ?n1:lemak ?s1) (* ?n2:lemak ?s2) (* ?n3:lemak ?s3) (* ?n4:lemak ?s4) (* ?n5:lemak ?s5) (* ?n6:lemak ?s6) (* ?n7:lemak ?s7)))

		(bind ?satuan-baru ?s1 ?s2 ?s3 ?s4 ?s5 ?s6 ?s7)
		(do-for-all-facts ((?bahan bahan-makanan))
			(and (= ?n1:tipe ?bahan:tipe) (> (nth$ ?bahan:golongan ?satuan-baru) 0))
			(bind ?pengali (nth$ ?bahan:golongan ?satuan-baru))
			(assert (solusi-menu (nama ?bahan:nama) (tipe ?bahan:tipe) (golongan ?bahan:golongan) (waktu siang) (berat (round (* ?bahan:berat ?pengali))) (satuan (ubah-satu-desimal (* (nth$ 1 ?bahan:satuan) ?pengali)) (nth$ 2 ?bahan:satuan))))
		)
	)
)

(defrule tentukan-menu-malam
	(declare (salience -5))
	?aksi <- (aksi TENTUKAN-MENU-MALAM)
	?pasien <- (pasien (kebutuhan-kalori-total ?kekal))
	?pembagian-kalori <- (solusi-pembagian-kalori (karbohidrat-pagi-malam ?kpma ?kpmb) (protein-pagi-malam ?ppma ?ppmb) (lemak-pagi-malam ?lpma ?lpmb))
	?kelompok-kalori <- (kelompok-kalori ?kelompok)
	?standar-diet <- (standar-diet (kalori ?kelompok) (malam $?malam))
	=>
	(retract ?aksi)
	(bind ?kalori-malam (* ?kekal 0.2))
	(bind ?s1 (nth$ 1 $?malam))
	(bind ?s2 (nth$ 2 $?malam))
	(bind ?s3 (nth$ 3 $?malam))
	(bind ?s4 (nth$ 4 $?malam))
	(bind ?s5 (nth$ 5 $?malam))
	(bind ?s6 (nth$ 6 $?malam))
	(bind ?s7 (nth$ 7 $?malam))
	(do-for-all-facts ((?n1 nutrisi-bahan-makanan) (?n2 nutrisi-bahan-makanan)
			(?n3 nutrisi-bahan-makanan) (?n4 nutrisi-bahan-makanan) (?n5 nutrisi-bahan-makanan)
			(?n6 nutrisi-bahan-makanan) (?n7 nutrisi-bahan-makanan))
		(and (= ?n1:tipe ?n2:tipe ?n3:tipe ?n4:tipe ?n5:tipe ?n6:tipe ?n7:tipe)
			(= ?n1:golongan 1) (= ?n2:golongan 2) (= ?n3:golongan 3) (= ?n4:golongan 4)
			(= ?n5:golongan 5) (= ?n6:golongan 6) (= ?n7:golongan 7)
		)
		(bind ?kalori (+ (* ?n1:kalori ?s1) (* ?n2:kalori ?s2) (* ?n3:kalori ?s3) (* ?n4:kalori ?s4) (* ?n5:kalori ?s5) (* ?n6:kalori ?s6) (* ?n7:kalori ?s7)))
		(bind ?protein (+ (* ?n1:protein ?s1) (* ?n2:protein ?s2) (* ?n3:protein ?s3) (* ?n4:protein ?s4) (* ?n5:protein ?s5) (* ?n6:protein ?s6) (* ?n7:protein ?s7)))
		(bind ?karbo (+ (* ?n1:karbohidrat ?s1) (* ?n2:karbohidrat ?s2) (* ?n3:karbohidrat ?s3) (* ?n4:karbohidrat ?s4) (* ?n5:karbohidrat ?s5) (* ?n6:karbohidrat ?s6) (* ?n7:karbohidrat ?s7)))
		(bind ?lemak (+ (* ?n1:lemak ?s1) (* ?n2:lemak ?s2) (* ?n3:lemak ?s3) (* ?n4:lemak ?s4) (* ?n5:lemak ?s5) (* ?n6:lemak ?s6) (* ?n7:lemak ?s7)))

		(bind ?satuan-baru ?s1 ?s2 ?s3 ?s4 ?s5 ?s6 ?s7)
		(do-for-all-facts ((?bahan bahan-makanan))
			(and (= ?n1:tipe ?bahan:tipe) (> (nth$ ?bahan:golongan ?satuan-baru) 0))
			(bind ?pengali (nth$ ?bahan:golongan ?satuan-baru))
			(assert (solusi-menu (nama ?bahan:nama) (tipe ?bahan:tipe) (golongan ?bahan:golongan) (waktu malam) (berat (round (* ?bahan:berat ?pengali))) (satuan (ubah-satu-desimal (* (nth$ 1 ?bahan:satuan) ?pengali)) (nth$ 2 ?bahan:satuan))))
		)
	)
)

(defrule tentukan-menu-snack-pagi
	(declare (salience -5))
	?aksi <- (aksi TENTUKAN-MENU-SNACK-PAGI)
	?pasien <- (pasien (kebutuhan-kalori-total ?kekal))
	?kelompok-kalori <- (kelompok-kalori ?kelompok)
	?standar-diet <- (standar-diet (kalori ?kelompok) (snack-pagi $?snack-pagi))
	=>
	(retract ?aksi)
	(bind ?s5 (nth$ 5 $?snack-pagi))
	(bind ?s6 (nth$ 6 $?snack-pagi))
	(do-for-all-facts ((?n5 nutrisi-bahan-makanan) (?n6 nutrisi-bahan-makanan))
		(and (= ?n5:tipe ?n6:tipe) (= ?n5:golongan 5) (= ?n6:golongan 6))

		(do-for-all-facts ((?bahan bahan-makanan))
			(and (= ?n5:tipe ?bahan:tipe) (= ?bahan:golongan 5))
			(assert (solusi-menu (nama ?bahan:nama) (tipe ?bahan:tipe) (golongan ?bahan:golongan) (waktu snack-pagi) (berat (round (* ?bahan:berat ?s5))) (satuan (ubah-satu-desimal (* (nth$ 1 ?bahan:satuan) ?s5)) (nth$ 2 ?bahan:satuan))))
		)
		(if (> ?s6 0) then
			(do-for-all-facts ((?bahan bahan-makanan))
				(and (= ?n5:tipe ?bahan:tipe) (= ?bahan:golongan 6))
				(assert (solusi-menu (nama ?bahan:nama) (tipe ?bahan:tipe) (golongan ?bahan:golongan) (waktu snack-pagi) (berat (round (* ?bahan:berat ?s6))) (satuan (ubah-satu-desimal (* (nth$ 1 ?bahan:satuan) ?s6)) (nth$ 2 ?bahan:satuan))))
			)
		)
	)
)

(defrule tentukan-menu-snack-sore
	(declare (salience -5))
	?aksi <- (aksi TENTUKAN-MENU-SNACK-SORE)
	?pasien <- (pasien (kebutuhan-kalori-total ?kekal))
	?kelompok-kalori <- (kelompok-kalori ?kelompok)
	?standar-diet <- (standar-diet (kalori ?kelompok) (snack-sore $?snack-sore))
	=>
	(retract ?aksi)
	(bind ?s5 (nth$ 5 $?snack-sore))
	(do-for-all-facts ((?n5 nutrisi-bahan-makanan) (?n6 nutrisi-bahan-makanan))
		(and (= ?n5:tipe ?n6:tipe) (= ?n5:golongan 5) (= ?n6:golongan 6))

		(do-for-all-facts ((?bahan bahan-makanan))
			(and (= ?n5:tipe ?bahan:tipe) (= ?bahan:golongan 5))
			(assert (solusi-menu (nama ?bahan:nama) (tipe ?bahan:tipe) (golongan ?bahan:golongan) (waktu snack-sore) (berat (round (* ?bahan:berat ?s5))) (satuan (ubah-satu-desimal (* (nth$ 1 ?bahan:satuan) ?s5)) (nth$ 2 ?bahan:satuan))))
		)
	)
)

(defrule proses-selesai
	(queue)
	?pasien <- (pasien (usia ?u) (jenis-kelamin ?jk) (tinggi-badan ?tb) (berat-badan ?bb) (AMB ?amb) (IMT ?imt) (tipe-badan ?tipe) (kebutuhan-kalori-total ?kalori))
	=>
	(printout t "
        <div class=\"col-sm-5\">
          <div class=\"row\">
            <div class=\"col-sm-5\"><b>IMT</b></div>
            <div class=\"col-sm-5\">" ?imt "</div>
          </div>
          <div class=\"row\">
            <div class=\"col-sm-5\"><b>Tipe badan</b></div>
            <div class=\"col-sm-5\">" (print-tipe-badan ?tipe) "</div>
          </div>
          <div class=\"row\">
            <div class=\"col-sm-5\"><b>AMB</b></div>
            <div class=\"col-sm-5\">" ?amb " kkal</div>
          </div>
          <div class=\"row\">
            <div class=\"col-sm-5\"><b>Kebutuhan kalori</b></div>
            <div class=\"col-sm-5\">" ?kalori " kkal</div>
          </div>
        </div>
        <div class=\"col-sm-1\"></div>
      </div>
      <div class=\"result\">
      </div>
      <br>
   ")
)

(defrule print-solusi
	(declare (salience -50))
	?aksi <- (aksi TAMPILKAN-SOLUSI-MENU)
	=>
	(retract ?aksi)
	(do-for-all-facts ((?nut nutrisi-bahan-makanan)) (= ?nut:golongan 1)
		(printout t "
			<div class=\"row\">
            <div class=\"col-md-4 result2\">
              <div class=\"pa--heading\">
                Menu Pagi
              </div>
		")
		(loop-for-count (?i 1 7) do
			(if (any-factp ((?f solusi-menu)) (and (= ?f:tipe ?nut:tipe) (eq ?f:waktu pagi) (= ?f:golongan ?i))) then
				(if (> ?i 1) then (printout t "<div align=\"center\"><span class=\"glyphicon glyphicon-plus\"></span></div>"))
				(printout t "<select class=\"form-control selcls\" id=\"a\">")
				(printout t (print-golongan-makanan ?i))
				(do-for-all-facts ((?bahan solusi-menu)) (and (= ?bahan:tipe ?nut:tipe) (eq ?bahan:waktu pagi) (= ?bahan:golongan ?i))
					(printout t "<option>" ?bahan:nama "  " ?bahan:berat " gr / " (nth$ 1 ?bahan:satuan) " " (nth$ 2 ?bahan:satuan) "</option>"))
				(printout t "</select>")
			)
			(if (= ?i 3) then 
				(printout t "<div align=\"center\"><span class=\"glyphicon glyphicon-plus\"></span></div>")
				(printout t "<select class=\"form-control selcls\" id=\"a\">")
				(printout t "<option>-- Sayuran A (sekehendaknya) --</option>")
				(do-for-all-facts ((?sayur sayuran-A)) TRUE 
 					(printout t "<option>" ?sayur:nama "</option>"))
				(printout t "</select>"))

			(if (= ?i 7) then (break))
		)
		(printout t "
			</div>
			<div class=\"col-md-4 result2\">
              <div class=\"pa--heading\">
                Menu Siang
              </div>
		")
		(loop-for-count (?i 1 7) do
			(if (any-factp ((?f solusi-menu)) (and (= ?f:tipe ?nut:tipe) (eq ?f:waktu siang) (= ?f:golongan ?i))) then
				(if (> ?i 1) then (printout t "<div align=\"center\"><span class=\"glyphicon glyphicon-plus\"></span></div>"))
				(printout t "<select class=\"form-control selcls\" id=\"a\">")
				(printout t (print-golongan-makanan ?i))
				(do-for-all-facts ((?bahan solusi-menu)) (and (= ?bahan:tipe ?nut:tipe) (eq ?bahan:waktu siang) (= ?bahan:golongan ?i))
					(printout t "<option>" ?bahan:nama "  " ?bahan:berat " gr / " (nth$ 1 ?bahan:satuan) " " (nth$ 2 ?bahan:satuan) "</option>"))
				(printout t "</select>")
			)
			(if (= ?i 3) then 
				(printout t "<div align=\"center\"><span class=\"glyphicon glyphicon-plus\"></span></div>")
				(printout t "<select class=\"form-control selcls\" id=\"a\">")
				(printout t "<option>-- Sayuran A (sekehendaknya) --</option>")
				(do-for-all-facts ((?sayur sayuran-A)) TRUE 
					(printout t "<option>" ?sayur:nama "</option>"))
				(printout t "</select>"))

			(if (= ?i 7) then (break))
		)
		(printout t "
			</div>
			<div class=\"col-md-4\">
              <div class=\"pa--heading\">
                Menu Malam
              </div>
		")
		(loop-for-count (?i 1 7) do
			(if (any-factp ((?f solusi-menu)) (and (= ?f:tipe ?nut:tipe) (eq ?f:waktu malam) (= ?f:golongan ?i))) then
				(if (> ?i 1) then (printout t "<div align=\"center\"><span class=\"glyphicon glyphicon-plus\"></span></div>"))
				(printout t "<select class=\"form-control selcls\" id=\"a\">")
				(printout t (print-golongan-makanan ?i))
				(do-for-all-facts ((?bahan solusi-menu)) (and (= ?bahan:tipe ?nut:tipe) (eq ?bahan:waktu malam) (= ?bahan:golongan ?i))
					(printout t "<option>" ?bahan:nama "  " ?bahan:berat " gr / " (nth$ 1 ?bahan:satuan) " " (nth$ 2 ?bahan:satuan) "</option>"))
				(printout t "</select>")
			)
			(if (= ?i 3) then 
				(printout t "<div align=\"center\"><span class=\"glyphicon glyphicon-plus\"></span></div>")
				(printout t "<select class=\"form-control selcls\" id=\"a\">")
				(printout t "<option>-- Sayuran A (sekehendaknya) --</option>")
				(do-for-all-facts ((?sayur sayuran-A)) TRUE 
					(printout t "<option>" ?sayur:nama "</option>"))
				(printout t "</select>"))

			(if (= ?i 7) then (break))
		)

		(printout t "
			</div>
          </div>
          <br>
          <div class=\"row\">
            <div class=\"col-md-4 result2\">
              <div class=\"pa--heading\">
                Snack Pagi (10.00)
              </div>
		")
		(loop-for-count (?i 1 7) do
			(if (any-factp ((?f solusi-menu)) (and (= ?f:tipe ?nut:tipe) (eq ?f:waktu snack-pagi) (= ?f:golongan ?i))) then
				(if (> ?i 5) then (printout t "<div align=\"center\"><span class=\"glyphicon glyphicon-plus\"></span></div>"))
				(printout t "<select class=\"form-control selcls\" id=\"a\">")
				(printout t (print-golongan-makanan ?i))
				(do-for-all-facts ((?bahan solusi-menu)) (and (= ?bahan:tipe ?nut:tipe) (eq ?bahan:waktu snack-pagi) (= ?bahan:golongan ?i))
					(printout t "<option>" ?bahan:nama "  " ?bahan:berat " gr / " (nth$ 1 ?bahan:satuan) " " (nth$ 2 ?bahan:satuan) "</option>"))
				(printout t "</select>")
			)

			(if (= ?i 7) then (break))
		)

		(printout t "
			</div>
            <div class=\"col-md-4\">
              <div class=\"pa--heading\">
                Snack Sore (16.00)
              </div>
		")
		(loop-for-count (?i 1 7) do
			(if (any-factp ((?f solusi-menu)) (and (= ?f:tipe ?nut:tipe) (eq ?f:waktu snack-sore) (= ?f:golongan ?i))) then
				(printout t "<select class=\"form-control selcls\" id=\"a\">")
				(printout t (print-golongan-makanan ?i))
				(do-for-all-facts ((?bahan solusi-menu)) (and (= ?bahan:tipe ?nut:tipe) (eq ?bahan:waktu snack-sore) (= ?bahan:golongan ?i))
					(printout t "<option>" ?bahan:nama "  " ?bahan:berat " gr / " (nth$ 1 ?bahan:satuan) " " (nth$ 2 ?bahan:satuan) "</option>"))
				(printout t "</select></div></div>")
			)

			(if (= ?i 7) then (break))
		)
	)
)
