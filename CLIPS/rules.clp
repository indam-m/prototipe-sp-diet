(defrule init-run
	(declare (salience 99))
	?mulai <- (mulai)
	=>
	(retract ?mulai)
	(load-facts "CLIPS/skeletal-model.dat")
	(load-facts "CLIPS/standar-diet.dat")
	(load-facts "CLIPS/bahan-makanan.dat")
	(assert (queue a)))

;; ?bb dalam kg, ?tb dalam cm, amb dalam kkal

(defrule hitung-amb-laki-laki
	(declare (salience 15))
	?aksi <- (aksi HITUNG-AMB)
	?data <- (pasien (berat-badan ?bb) (tinggi-badan ?tb) (jenis-kelamin ?jk) (usia ?u) (AMB ?amb))
	(test (eq ?jk Laki-laki))
	=>
	(retract ?aksi)
	(modify ?data (AMB (round (+ 66 (* 13.7 ?bb) (* 5 ?tb) (- 0 (* 6.8 ?u)))))))

(defrule hitung-amb-perempuan
	(declare (salience 15))
	?aksi <- (aksi HITUNG-AMB)
	?data <- (pasien (berat-badan ?bb) (tinggi-badan ?tb) (jenis-kelamin ?jk) (usia ?u) (AMB ?amb))
	(test (eq ?jk Perempuan))
	=>
	(retract ?aksi)
	(modify ?data (AMB (round (+ 655 (* 9.6 ?bb) (* 1.8 ?tb) (- 0 (* 4.7 ?u)))))))

(defrule hitung-imt
	(declare (salience 11))
	?aksi <- (aksi HITUNG-IMT)
	?data <- (pasien (berat-badan ?bb) (tinggi-badan ?tb) (IMT ?imt))
	=>
	(retract ?aksi)
	(modify ?data (IMT (ubah-satu-desimal (/ ?bb (* (/ ?tb 100) (/ ?tb 100)))))))

(defrule tentukan-kategori-berat-badan-kurus
	(declare (salience 10))
	?aksi <- (aksi TENTUKAN-KATEGORI-BERAT-BADAN)
	?data <- (pasien (IMT ?imt) (kategori-berat-badan ?kategori))
	(test (<= ?imt 18.5))
	=>
	(retract ?aksi)
	(if (< ?imt 17) then (modify ?data (kategori-berat-badan -2)) else
		(modify ?data (kategori-berat-badan -1))))

(defrule tentukan-kategori-berat-badan-sedang
	(declare (salience 10))
	?aksi <- (aksi TENTUKAN-KATEGORI-BERAT-BADAN)
	?data <- (pasien (IMT ?imt) (kategori-berat-badan ?kategori))
	(test (and (> ?imt 18.5) (<= ?imt 25)))
	=>
	(retract ?aksi)
	(modify ?data (kategori-berat-badan 0)))

(defrule tentukan-kategori-berat-badan-gemuk
	(declare (salience 10))
	?aksi <- (aksi TENTUKAN-KATEGORI-BERAT-BADAN)
	?data <- (pasien (IMT ?imt) (kategori-berat-badan ?kategori))
	(test (> ?imt 25))
	=>
	(retract ?aksi)
	(if (> ?imt 27) then (modify ?data (kategori-berat-badan 2)) else
		(modify ?data (kategori-berat-badan 1))))

(defrule hitung-kebutuhan-kalori-laki-laki
	(declare (salience 10))
	?aksi <- (aksi HITUNG-KEBUTUHAN-KALORI)
	?data <- (pasien (AMB ?amb) (jenis-kelamin ?jk) (usia ?u) (aktivitas ?aktivitas) (kategori-berat-badan ?kategori) (kebutuhan-kalori ?kal))
	(test (eq ?jk Laki-laki))
	=>
	(retract ?aksi)
	(if (eq ?aktivitas "Sangat ringan") then (bind ?kalori (* ?amb 1.3)))
	(if (eq ?aktivitas "Ringan") then (bind ?kalori (* ?amb 1.65)))
	(if (eq ?aktivitas "Sedang") then (bind ?kalori (* ?amb 1.76)))
	(if (eq ?aktivitas "Berat") then (bind ?kalori (* ?amb 2.1)))
	(if (< ?kategori 0) then (bind ?kalori (+ ?kalori 500)))
	(if (> ?kategori 0) then (bind ?kalori (- ?kalori 500)))
	(if (> ?u 50) then (bind ?kalori (* ?kalori 0.95)))
	(modify ?data (kebutuhan-kalori (round ?kalori)))

	(if (<= ?kalori 1200) then (bind ?kelompok 1100))
	(if (and (> ?kalori 1200) (<= ?kalori 1400)) then (bind ?kelompok 1300))
	(if (and (> ?kalori 1400) (<= ?kalori 1600)) then (bind ?kelompok 1500))
	(if (and (> ?kalori 1600) (<= ?kalori 1800)) then (bind ?kelompok 1700))
	(if (and (> ?kalori 1800) (<= ?kalori 2000)) then (bind ?kelompok 1900))
	(if (and (> ?kalori 2000) (<= ?kalori 2200)) then (bind ?kelompok 2100))
	(if (and (> ?kalori 2200) (<= ?kalori 2400)) then (bind ?kelompok 2300))
	(if (> ?kalori 2400) then (bind ?kelompok 2500))
	(assert (kelompok-kalori ?kelompok)))

(defrule hitung-kebutuhan-kalori-perempuan
	(declare (salience 10))
	?aksi <- (aksi HITUNG-KEBUTUHAN-KALORI)
	?data <- (pasien (AMB ?amb) (jenis-kelamin ?jk) (usia ?u) (aktivitas ?aktivitas) (kategori-berat-badan ?kategori) (kebutuhan-kalori ?kal))
	(test (eq ?jk Perempuan))
	=>
	(retract ?aksi)
	(if (eq ?aktivitas "Sangat ringan") then (bind ?kalori (* ?amb 1.3)))
	(if (eq ?aktivitas "Ringan") then (bind ?kalori (* ?amb 1.55)))
	(if (eq ?aktivitas "Sedang") then (bind ?kalori (* ?amb 1.7)))
	(if (eq ?aktivitas "Berat") then (bind ?kalori (* ?amb 2.0)))
	(if (< ?kategori 0) then (bind ?kalori (+ ?kalori 500)))
	(if (> ?kategori 0) then (bind ?kalori (- ?kalori 500)))
	(if (> ?u 50) then (bind ?kalori (* ?kalori 0.95)))
	(modify ?data (kebutuhan-kalori (round ?kalori)))

	(if (<= ?kalori 1200) then (bind ?kelompok 1100))
	(if (and (> ?kalori 1200) (<= ?kalori 1400)) then (bind ?kelompok 1300))
	(if (and (> ?kalori 1400) (<= ?kalori 1600)) then (bind ?kelompok 1500))
	(if (and (> ?kalori 1600) (<= ?kalori 1800)) then (bind ?kelompok 1700))
	(if (and (> ?kalori 1800) (<= ?kalori 2000)) then (bind ?kelompok 1900))
	(if (and (> ?kalori 2000) (<= ?kalori 2200)) then (bind ?kelompok 2100))
	(if (and (> ?kalori 2200) (<= ?kalori 2400)) then (bind ?kelompok 2300))
	(if (> ?kalori 2400) then (bind ?kelompok 2500))
	(assert (kelompok-kalori ?kelompok)))

(defrule tentukan-tipe-diet
	(declare (salience 9))
	?aksi <- (aksi TENTUKAN-TIPE-DIET)
	?pasien <- (pasien (penyakit ?penyakit))
	=>
	(retract ?aksi)
	(if (or (eq ?penyakit "-") (eq ?penyakit "Jantung") (eq ?penyakit "Hipertrigliserida")) then 
		(assert (goal PENETAPAN-DIET-BIASA)))
	(if (or (eq ?penyakit "Hiperkolesterol") (eq ?penyakit "Hipertensi") (eq ?penyakit "Konstipasi kronis") (eq ?penyakit "Penyakit lambung")) then 
		(assert (goal PENETAPAN-DIET-TINGGI-SERAT)))
	(if (eq ?penyakit "Diabetes melitus") then (assert (goal PENETAPAN-DIET-DIABETES)))
	(if (eq ?penyakit "Asam urat") then (assert (goal PENETAPAN-DIET-RENDAH-PURIN))))

(defrule tetapkan-diet-biasa
	(declare (salience 9))
	?aksi <- (aksi TETAPKAN-DIET-BIASA)
	=>
	(retract ?aksi)
	(assert (tipe-diet biasa)))

(defrule tetapkan-diet-diabetes
	(declare (salience 9))
	?aksi <- (aksi TETAPKAN-DIET-DIABETES)
	=>
	(retract ?aksi)
	(assert (tipe-diet diabetes)))

(defrule tetapkan-diet-rendah-purin
	(declare (salience 9))
	?aksi <- (aksi TETAPKAN-DIET-RENDAH-PURIN)
	=>
	(retract ?aksi)
	(assert (tipe-diet rendah-purin)))

(defrule tetapkan-diet-tinggi-serat
	(declare (salience 9))
	?aksi <- (aksi TETAPKAN-DIET-TINGGI-SERAT)
	=>
	(retract ?aksi)
	(assert (tipe-diet tinggi-serat)))

(defrule tentukan-diet-lemak
	(declare (salience 9))
	?aksi <- (aksi TENTUKAN-DIET-LEMAK)
	?pasien <- (pasien (kategori-berat-badan ?kategori-berat-badan) (penyakit ?penyakit))
	=>
	(retract ?aksi)
	(if (or (> ?kategori-berat-badan 0) (eq ?penyakit "Asam urat") (eq ?penyakit "Hipertensi") (eq ?penyakit "Hiperkolesterol") (eq ?penyakit "Hipertrigliserida") (eq ?penyakit "Jantung")) then (assert (goal DENGAN-DIET-RENDAH-LEMAK))
		else (assert (goal TANPA-DIET-RENDAH-LEMAK))))

(defrule tetapkan-diet-dengan-rendah-lemak
	(declare (salience 8))
	?aksi <- (aksi TETAPKAN-DENGAN-DIET-RENDAH-LEMAK)
	=>
	(retract ?aksi)
	(assert (rendah-lemak ya)))

(defrule tetapkan-diet-tanpa-rendah-lemak
	(declare (salience 8))
	?aksi <- (aksi TETAPKAN-TANPA-DIET-RENDAH-LEMAK)
	=>
	(retract ?aksi)
	(assert (rendah-lemak tidak)))

(defrule tentukan-menu-pagi-dengan-rendah-lemak
	(declare (salience -5))
	?aksi <- (aksi TENTUKAN-MENU-PAGI)
	?pasien <- (pasien (kebutuhan-kalori ?kekal) (penyakit ?penyakit))
	?kelompok-kalori <- (kelompok-kalori ?kelompok)
	?rendah-lemak <- (rendah-lemak ?rl)
	(test (eq ?rl ya))
	?kategori-diet <- (tipe-diet ?td)
	?standar-diet <- (standar-diet (kalori ?kelompok) (pagi $?pagi))
	=>
	(retract ?aksi)
	(bind ?s1 (nth$ 1 $?pagi))
	(bind ?s2 (nth$ 2 $?pagi))
	(bind ?s3 (nth$ 3 $?pagi))
	(bind ?s4 (nth$ 4 $?pagi))
	(bind ?s5 (nth$ 5 $?pagi))
	(bind ?s6 (nth$ 6 $?pagi))
	(bind ?s7 (nth$ 7 $?pagi))

	(bind ?satuan-baru ?s1 ?s2 ?s3 ?s4 ?s5 ?s6 ?s7)
	(do-for-all-facts ((?bahan bahan-makanan))
		(and (> (nth$ ?bahan:golongan ?satuan-baru) 0) 
		(neq ?bahan:lemak tinggi) (neq ?bahan:lemak jenuh) 
		(not (member$ ?penyakit ?bahan:tidak-dianjurkan))
		(not (member$ ?td ?bahan:tidak-dianjurkan)) 
		(if (eq ?td rendah-purin) then (eq ?bahan:purin rendah) else true) 
		(if (eq ?penyakit "Jantung") then (neq ?bahan:serat tinggi) else true) 
		(if (eq ?td tinggi-serat) then 
			(or (eq ?bahan:serat tinggi) (eq ?bahan:serat nul)) else true))

		(bind ?pengali (nth$ ?bahan:golongan ?satuan-baru))
		(assert (solusi-menu (nama ?bahan:nama) (golongan ?bahan:golongan) 
		(waktu pagi) (berat (round (* ?bahan:berat ?pengali))) 
		(URT (ubah-satu-desimal (* (nth$ 1 ?bahan:URT) ?pengali)) 
		(nth$ 2 ?bahan:URT)) (lemak ?bahan:lemak)))))

(defrule tentukan-menu-pagi-tanpa-rendah-lemak
	(declare (salience -5))
	?aksi <- (aksi TENTUKAN-MENU-PAGI)
	?pasien <- (pasien (kebutuhan-kalori ?kekal) (penyakit ?penyakit))
	?kelompok-kalori <- (kelompok-kalori ?kelompok)
	?rendah-lemak <- (rendah-lemak ?rl)
	(test (eq ?rl tidak))
	?kategori-diet <- (tipe-diet ?td)
	?standar-diet <- (standar-diet (kalori ?kelompok) (pagi $?pagi))
	=>
	(retract ?aksi)
	(bind ?s1 (nth$ 1 $?pagi))
	(bind ?s2 (nth$ 2 $?pagi))
	(bind ?s3 (nth$ 3 $?pagi))
	(bind ?s4 (nth$ 4 $?pagi))
	(bind ?s5 (nth$ 5 $?pagi))
	(bind ?s6 (nth$ 6 $?pagi))
	(bind ?s7 (nth$ 7 $?pagi))

	(bind ?satuan-baru ?s1 ?s2 ?s3 ?s4 ?s5 ?s6 ?s7)
	(do-for-all-facts ((?bahan bahan-makanan))
		(and (> (nth$ ?bahan:golongan ?satuan-baru) 0) 
		(not (member$ ?penyakit ?bahan:tidak-dianjurkan)) 
		(not (member$ ?td ?bahan:tidak-dianjurkan)) 
		(if (eq ?td rendah-purin) then (eq ?bahan:purin rendah) else true) 
		(if (eq ?penyakit "Jantung") then (neq ?bahan:serat tinggi) else true) 
		(if (eq ?td tinggi-serat) then 
			(or (eq ?bahan:serat tinggi) (eq ?bahan:serat nul)) else true))

		(bind ?pengali (nth$ ?bahan:golongan ?satuan-baru))
		(assert (solusi-menu (nama ?bahan:nama) (golongan ?bahan:golongan) (waktu pagi) (berat (round (* ?bahan:berat ?pengali))) (URT (ubah-satu-desimal (* (nth$ 1 ?bahan:URT) ?pengali)) (nth$ 2 ?bahan:URT)) (lemak ?bahan:lemak)))
	))

(defrule tentukan-menu-siang-dengan-rendah-lemak
	(declare (salience -5))
	?aksi <- (aksi TENTUKAN-MENU-SIANG)
	?pasien <- (pasien (kebutuhan-kalori ?kekal) (penyakit ?penyakit))
	?kelompok-kalori <- (kelompok-kalori ?kelompok)
	?rendah-lemak <- (rendah-lemak ?rl)
	(test (eq ?rl ya))
	?kategori-diet <- (tipe-diet ?td)
	?standar-diet <- (standar-diet (kalori ?kelompok) (siang $?siang))
	=>
	(retract ?aksi)
	(bind ?s1 (nth$ 1 $?siang))
	(bind ?s2 (nth$ 2 $?siang))
	(bind ?s3 (nth$ 3 $?siang))
	(bind ?s4 (nth$ 4 $?siang))
	(bind ?s5 (nth$ 5 $?siang))
	(bind ?s6 (nth$ 6 $?siang))
	(bind ?s7 (nth$ 7 $?siang))
	(bind ?satuan-baru ?s1 ?s2 ?s3 ?s4 ?s5 ?s6 ?s7)
	(do-for-all-facts ((?bahan bahan-makanan))
		(and (> (nth$ ?bahan:golongan ?satuan-baru) 0) 
		(neq ?bahan:lemak tinggi) (neq ?bahan:lemak jenuh) 
		(not (member$ ?penyakit ?bahan:tidak-dianjurkan)) 
		(not (member$ ?td ?bahan:tidak-dianjurkan)) 
		(if (eq ?td rendah-purin) then (neq ?bahan:purin tinggi) else true) 
		(if (eq ?penyakit "Jantung") then (neq ?bahan:serat tinggi) else true)
		(if (eq ?td tinggi-serat) then (or (eq ?bahan:serat tinggi) (eq ?bahan:serat nul)) else true))

		(bind ?pengali (nth$ ?bahan:golongan ?satuan-baru))
		(assert (solusi-menu (nama ?bahan:nama) (golongan ?bahan:golongan) (waktu siang) (berat (round (* ?bahan:berat ?pengali))) (URT (ubah-satu-desimal (* (nth$ 1 ?bahan:URT) ?pengali)) (nth$ 2 ?bahan:URT)) (lemak ?bahan:lemak)))
	))

(defrule tentukan-menu-siang-tanpa-rendah-lemak
	(declare (salience -5))
	?aksi <- (aksi TENTUKAN-MENU-SIANG)
	?pasien <- (pasien (kebutuhan-kalori ?kekal) (penyakit ?penyakit))
	?kelompok-kalori <- (kelompok-kalori ?kelompok)
	?rendah-lemak <- (rendah-lemak ?rl)
	(test (eq ?rl tidak))
	?kategori-diet <- (tipe-diet ?td)
	?standar-diet <- (standar-diet (kalori ?kelompok) (siang $?siang))
	=>
	(retract ?aksi)
	(bind ?s1 (nth$ 1 $?siang))
	(bind ?s2 (nth$ 2 $?siang))
	(bind ?s3 (nth$ 3 $?siang))
	(bind ?s4 (nth$ 4 $?siang))
	(bind ?s5 (nth$ 5 $?siang))
	(bind ?s6 (nth$ 6 $?siang))
	(bind ?s7 (nth$ 7 $?siang))
	(bind ?satuan-baru ?s1 ?s2 ?s3 ?s4 ?s5 ?s6 ?s7)
	(do-for-all-facts ((?bahan bahan-makanan))
		(and (> (nth$ ?bahan:golongan ?satuan-baru) 0) 
		(not (member$ ?penyakit ?bahan:tidak-dianjurkan)) 
		(not (member$ ?td ?bahan:tidak-dianjurkan)) 
		(if (eq ?td rendah-purin) then (neq ?bahan:purin tinggi) else true) 
		(if (eq ?penyakit "Jantung") then (neq ?bahan:serat tinggi) else true)
		(if (eq ?td tinggi-serat) then (or (eq ?bahan:serat tinggi) (eq ?bahan:serat nul)) else true))

		(bind ?pengali (nth$ ?bahan:golongan ?satuan-baru))
		(assert (solusi-menu (nama ?bahan:nama) (golongan ?bahan:golongan) (waktu siang) (berat (round (* ?bahan:berat ?pengali))) (URT (ubah-satu-desimal (* (nth$ 1 ?bahan:URT) ?pengali)) (nth$ 2 ?bahan:URT)) (lemak ?bahan:lemak)))
	))

(defrule tentukan-menu-malam-dengan-rendah-lemak
	(declare (salience -5))
	?aksi <- (aksi TENTUKAN-MENU-MALAM)
	?pasien <- (pasien (kebutuhan-kalori ?kekal) (penyakit ?penyakit))
	?kelompok-kalori <- (kelompok-kalori ?kelompok)
	?rendah-lemak <- (rendah-lemak ?rl)
	(test (eq ?rl ya))
	?kategori-diet <- (tipe-diet ?td)
	?standar-diet <- (standar-diet (kalori ?kelompok) (malam $?malam))
	=>
	(retract ?aksi)
	(bind ?s1 (nth$ 1 $?malam))
	(bind ?s2 (nth$ 2 $?malam))
	(bind ?s3 (nth$ 3 $?malam))
	(bind ?s4 (nth$ 4 $?malam))
	(bind ?s5 (nth$ 5 $?malam))
	(bind ?s6 (nth$ 6 $?malam))
	(bind ?s7 (nth$ 7 $?malam))
	(bind ?satuan-baru ?s1 ?s2 ?s3 ?s4 ?s5 ?s6 ?s7)
	(do-for-all-facts ((?bahan bahan-makanan))
		(and (> (nth$ ?bahan:golongan ?satuan-baru) 0) 
		(neq ?bahan:lemak tinggi) (neq ?bahan:lemak jenuh) 
		(not (member$ ?penyakit ?bahan:tidak-dianjurkan)) 
		(not (member$ ?td ?bahan:tidak-dianjurkan)) 
		(if (eq ?td rendah-purin) then (eq ?bahan:purin rendah) else true) 
		(if (eq ?penyakit "Jantung") then (neq ?bahan:serat tinggi) else true)
		(if (eq ?td tinggi-serat) then (or (eq ?bahan:serat tinggi) (eq ?bahan:serat nul)) else true))

		(bind ?pengali (nth$ ?bahan:golongan ?satuan-baru))
		(assert (solusi-menu (nama ?bahan:nama) (golongan ?bahan:golongan) (waktu malam) (berat (round (* ?bahan:berat ?pengali))) (URT (ubah-satu-desimal (* (nth$ 1 ?bahan:URT) ?pengali)) (nth$ 2 ?bahan:URT)) (lemak ?bahan:lemak)))
	))

(defrule tentukan-menu-malam-tanpa-rendah-lemak
	(declare (salience -5))
	?aksi <- (aksi TENTUKAN-MENU-MALAM)
	?pasien <- (pasien (kebutuhan-kalori ?kekal) (penyakit ?penyakit))
	?kelompok-kalori <- (kelompok-kalori ?kelompok)
	?rendah-lemak <- (rendah-lemak ?rl)
	(test (eq ?rl tidak))
	?kategori-diet <- (tipe-diet ?td)
	?standar-diet <- (standar-diet (kalori ?kelompok) (malam $?malam))
	=>
	(retract ?aksi)
	(bind ?s1 (nth$ 1 $?malam))
	(bind ?s2 (nth$ 2 $?malam))
	(bind ?s3 (nth$ 3 $?malam))
	(bind ?s4 (nth$ 4 $?malam))
	(bind ?s5 (nth$ 5 $?malam))
	(bind ?s6 (nth$ 6 $?malam))
	(bind ?s7 (nth$ 7 $?malam))
	(bind ?satuan-baru ?s1 ?s2 ?s3 ?s4 ?s5 ?s6 ?s7)
	(do-for-all-facts ((?bahan bahan-makanan))
		(and (> (nth$ ?bahan:golongan ?satuan-baru) 0) 
		(not (member$ ?penyakit ?bahan:tidak-dianjurkan)) 
		(not (member$ ?td ?bahan:tidak-dianjurkan)) 
		(if (eq ?td rendah-purin) then (eq ?bahan:purin rendah) else true) 
		(if (eq ?penyakit "Jantung") then (neq ?bahan:serat tinggi) else true)
		(if (eq ?td tinggi-serat) then (or (eq ?bahan:serat tinggi) (eq ?bahan:serat nul)) else true))

		(bind ?pengali (nth$ ?bahan:golongan ?satuan-baru))
		(assert (solusi-menu (nama ?bahan:nama) (golongan ?bahan:golongan) (waktu malam) (berat (round (* ?bahan:berat ?pengali))) (URT (ubah-satu-desimal (* (nth$ 1 ?bahan:URT) ?pengali)) (nth$ 2 ?bahan:URT)) (lemak ?bahan:lemak)))
	))

(defrule tentukan-menu-snack-pagi-dengan-rendah-lemak
	(declare (salience -5))
	?aksi <- (aksi TENTUKAN-MENU-SNACK-PAGI)
	?pasien <- (pasien (kebutuhan-kalori ?kekal) (penyakit ?penyakit))
	?kelompok-kalori <- (kelompok-kalori ?kelompok)
	?rendah-lemak <- (rendah-lemak ?rl)
	(test (eq ?rl ya))
	?kategori-diet <- (tipe-diet ?td)
	?standar-diet <- (standar-diet (kalori ?kelompok) (snack-pagi $?snack-pagi))
	=>
	(retract ?aksi)
	(bind ?s5 (nth$ 5 $?snack-pagi))
	(bind ?s6 (nth$ 6 $?snack-pagi))
	(do-for-all-facts ((?bahan bahan-makanan))
		(and (= ?bahan:golongan 5) (not (member$ ?penyakit ?bahan:tidak-dianjurkan)) (not (member$ ?td ?bahan:tidak-dianjurkan)) (if (eq ?td rendah-purin) then (eq ?bahan:purin rendah) else true) (neq ?bahan:lemak tinggi))
		(assert (solusi-menu (nama ?bahan:nama) (golongan ?bahan:golongan) (waktu snack-pagi) (berat (round (* ?bahan:berat ?s5))) (URT (ubah-satu-desimal (* (nth$ 1 ?bahan:URT) ?s5)) (nth$ 2 ?bahan:URT))))
	)
	(if (> ?s6 0) then
		(do-for-all-facts ((?bahan bahan-makanan))
			(and (= ?bahan:golongan 6) (neq ?bahan:lemak tinggi) (not (member$ ?penyakit ?bahan:tidak-dianjurkan)) (not (member$ ?td ?bahan:tidak-dianjurkan)) (if (eq ?td rendah-purin) then (eq ?bahan:purin rendah) else true))
			
			(assert (solusi-menu (nama ?bahan:nama) (golongan ?bahan:golongan) (waktu snack-pagi) (berat (round (* ?bahan:berat ?s6))) (URT (ubah-satu-desimal (* (nth$ 1 ?bahan:URT) ?s6)) (nth$ 2 ?bahan:URT)) (lemak ?bahan:lemak)))
		)))

(defrule tentukan-menu-snack-pagi-tanpa-rendah-lemak
	(declare (salience -5))
	?aksi <- (aksi TENTUKAN-MENU-SNACK-PAGI)
	?pasien <- (pasien (kebutuhan-kalori ?kekal) (penyakit ?penyakit))
	?kelompok-kalori <- (kelompok-kalori ?kelompok)
	?rendah-lemak <- (rendah-lemak ?rl)
	(test (eq ?rl tidak))
	?kategori-diet <- (tipe-diet ?td)
	?standar-diet <- (standar-diet (kalori ?kelompok) (snack-pagi $?snack-pagi))
	=>
	(retract ?aksi)
	(bind ?s5 (nth$ 5 $?snack-pagi))
	(bind ?s6 (nth$ 6 $?snack-pagi))
	(do-for-all-facts ((?bahan bahan-makanan))
		(and (= ?bahan:golongan 5) (not (member$ ?penyakit ?bahan:tidak-dianjurkan)) (not (member$ ?td ?bahan:tidak-dianjurkan)) (if (eq ?td rendah-purin) then (eq ?bahan:purin rendah) else true))
		(assert (solusi-menu (nama ?bahan:nama) (golongan ?bahan:golongan) (waktu snack-pagi) (berat (round (* ?bahan:berat ?s5))) (URT (ubah-satu-desimal (* (nth$ 1 ?bahan:URT) ?s5)) (nth$ 2 ?bahan:URT))))
	)
	(if (> ?s6 0) then
		(do-for-all-facts ((?bahan bahan-makanan))
			(and (= ?bahan:golongan 6) (not (member$ ?penyakit ?bahan:tidak-dianjurkan)) (not (member$ ?td ?bahan:tidak-dianjurkan)) (if (eq ?td rendah-purin) then (eq ?bahan:purin rendah) else true))
			(assert (solusi-menu (nama ?bahan:nama) (golongan ?bahan:golongan) (waktu snack-pagi) (berat (round (* ?bahan:berat ?s6))) (URT (ubah-satu-desimal (* (nth$ 1 ?bahan:URT) ?s6)) (nth$ 2 ?bahan:URT)) (lemak ?bahan:lemak)))
		)))

(defrule tentukan-menu-snack-sore-dengan-rendah-lemak
	(declare (salience -5))
	?aksi <- (aksi TENTUKAN-MENU-SNACK-SORE)
	?pasien <- (pasien (kebutuhan-kalori ?kekal) (penyakit ?penyakit))
	?kelompok-kalori <- (kelompok-kalori ?kelompok)
	?rendah-lemak <- (rendah-lemak ?rl)
	?kategori-diet <- (tipe-diet ?td)
	?standar-diet <- (standar-diet (kalori ?kelompok) (snack-sore $?snack-sore))
	=>
	(retract ?aksi)
	(bind ?s5 (nth$ 5 $?snack-sore))
	(do-for-all-facts ((?bahan bahan-makanan))
		(and (= ?bahan:golongan 5) (not (member$ ?penyakit ?bahan:tidak-dianjurkan)) (not (member$ ?td ?bahan:tidak-dianjurkan)) (if (eq ?td rendah-purin) then (eq ?bahan:purin rendah) else true) (neq ?bahan:lemak tinggi))
		(assert (solusi-menu (nama ?bahan:nama) (golongan ?bahan:golongan) (waktu snack-sore) (berat (round (* ?bahan:berat ?s5))) (URT (ubah-satu-desimal (* (nth$ 1 ?bahan:URT) ?s5)) (nth$ 2 ?bahan:URT)) (lemak ?bahan:lemak)))
	))

(defrule tentukan-menu-snack-sore-tanpa-rendah-lemak
	(declare (salience -5))
	?aksi <- (aksi TENTUKAN-MENU-SNACK-SORE)
	?pasien <- (pasien (kebutuhan-kalori ?kekal) (penyakit ?penyakit))
	?kelompok-kalori <- (kelompok-kalori ?kelompok)
	?rendah-lemak <- (rendah-lemak ?rl)
	?kategori-diet <- (tipe-diet ?td)
	?standar-diet <- (standar-diet (kalori ?kelompok) (snack-sore $?snack-sore))
	=>
	(retract ?aksi)
	(bind ?s5 (nth$ 5 $?snack-sore))
	(do-for-all-facts ((?bahan bahan-makanan))
		(and (= ?bahan:golongan 5) (not (member$ ?penyakit ?bahan:tidak-dianjurkan)) (not (member$ ?td ?bahan:tidak-dianjurkan)) (if (eq ?td rendah-purin) then (eq ?bahan:purin rendah) else true))
		(assert (solusi-menu (nama ?bahan:nama) (golongan ?bahan:golongan) (waktu snack-sore) (berat (round (* ?bahan:berat ?s5))) (URT (ubah-satu-desimal (* (nth$ 1 ?bahan:URT) ?s5)) (nth$ 2 ?bahan:URT)) (lemak ?bahan:lemak)))
	))

(defrule keluarkan-tips-diet-biasa
	(declare (salience -60))
	?aksi <- (aksi TENTUKAN-TIPS-DIET)
	?pasien <- (pasien (penyakit "-") (kategori-berat-badan ?kategori))
	=>
	(retract ?aksi)
	(printout t "
		<div class="result"></div><br>
	    <div class="pa--heading2">&nbsp;&nbsp; Tips </div>
	    <div class="tips-text"><ul>
	")
	(printout t "<li>Konsumsi cairan yang dianjurkan adalah 2 liter (8 gelas) sehari.</li>")
	(printout t "<li>Konsumsi garam dapur yang dianjurkan adalah tidak lebih dari 6 gram sehari.</li>")
	(printout t "<li>Batasi makanan yang merangsang saluran cerna seperti makanan yang terlalu manis atau makanan dengan bumbu merangsang seperti pedas dan bersantan.</li>")
	(if (<= ?kategori 0) then
		(printout t "<li>Batasi konsumsi bahan makanan dengan lemak tinggi atau lemak jenuh tidak lebih dari sekali dalam sehari.</li>"))
	(printout t "<li>Kurangi konsumsi makanan yang digoreng. Cara memasak makanan yang dianjurkan adalah merebus, mengetim, memepes, memanggang, membakar, atau menumis.</li>")
	(printout t "<li>Batasi konsumsi minuman beralkohol.</li>")
	(printout t "<li>Lakukan aktivitas seperti jalan kaki 2 km per hari.</li>")
	(printout t "</ul></div>"))

(defrule keluarkan-tips-diet-asam-urat
	(declare (salience -60))
	?aksi <- (aksi TENTUKAN-TIPS-DIET)
	?pasien <- (pasien (penyakit ?penyakit) (kategori-berat-badan ?kategori))
	(test (eq ?penyakit "Asam urat"))
	=>
	(retract ?aksi)
	(printout t "
		<div class="result"></div><br>
	    <div class="pa--heading3">&nbsp;&nbsp; Tips </div>
	    <div class="tips-text"><ul>")
	(printout t "<li>Konsumsi cairan yang dianjurkan adalah 2 liter (8 gelas) sehari.</li>")
	(printout t "<li>Hindari makanan yang mengandung purin tinggi, seperti : otak, hati, jantung, ginjal, jeroan, ekstrak daging/kaldu, boillon, bebek, ikan sardin, makarel, remis, kerang.</li>")
	(printout t "<li>Batasi makanan yang mengandung purin sedang, seperti : daging sapi dan ikan (selain ikan dengan purin tinggi), ayam, udang; kacang kering dan hasil olah, seperti tahu dan tempe; asparagus, bayam, daun singkong, kangkung, daun dan biji melinjo, buncis.</li>")
	(printout t "<li>Jika mengonsumsi makanan yang mengandung ragi seperti roti, panaskan terlebih dahulu untuk mematikan peragian.</li>")
	(printout t "<li>Hindari konsumsi makanan yang mengandung natrium tinggi dan mengandung pengawet.</li>")
	(printout t "<li>Lakukan aktivitas seperti jalan kaki 2 km per hari.</li>")
	(printout t "</ul></div>"))

(defrule keluarkan-tips-diet-diabetes-melitus
	(declare (salience -60))
	?aksi <- (aksi TENTUKAN-TIPS-DIET)
	?pasien <- (pasien (penyakit ?penyakit) (kategori-berat-badan ?kategori))
	(test (eq ?penyakit "Diabetes melitus"))
	=>
	(retract ?aksi)
	(printout t "
		<div class="result"></div><br>
	    <div class="pa--heading3">&nbsp;&nbsp; Tips </div>
	    <div class="tips-text"><ul>")
	(printout t "<li>Konsumsi cairan yang dianjurkan adalah 2 liter (8 gelas) sehari.</li>")
	(printout t "<li>Tidak diperbolehkan menggunakan gula murni dalam makanan dan minuman, kecuali jumlahnya sedikit sebagai bumbu.</li>")
	(printout t "<li>Perbanyak konsumsi makanan berserat tinggi dari buah dan sayuran.</li>")
	(printout t "<li>Lakukan aktivitas seperti jalan kaki 2 km per hari.</li>")
	(printout t "</ul></div>"))

(defrule keluarkan-tips-diet-konstipasi-kronis
	(declare (salience -60))
	?aksi <- (aksi TENTUKAN-TIPS-DIET)
	?pasien <- (pasien (penyakit ?penyakit) (kategori-berat-badan ?kategori))
	(test (eq ?penyakit "Konstipasi kronis"))
	=>
	(retract ?aksi)
	(printout t "
		<div class="result"></div><br>
	    <div class="pa--heading3">&nbsp;&nbsp; Tips </div>
	    <div class="tips-text"><ul>")
	(printout t "<li>Perbanyak konsumsi cairan, yaitu 8 - 10 gelas sehari.</li>")
	(printout t "<li>Dianjurkan untuk mengonsumsi vitamin dan mineral yang tinggi, terutama vitamin B untuk memelihara kekuatan otot saluran cerna.</li>")
	(printout t "<li>Perbanyak konsumsi makanan berserat tinggi dari buah dan sayuran.</li>")
	(printout t "<li>Lakukan aktivitas seperti jalan kaki 2 km per hari.</li>")
	(printout t "</ul></div>"))

(defrule keluarkan-tips-diet-hiperkolesterol
	(declare (salience -60))
	?aksi <- (aksi TENTUKAN-TIPS-DIET)
	?pasien <- (pasien (penyakit ?penyakit) (kategori-berat-badan ?kategori))
	(test (eq ?penyakit "Hiperkolesterol"))
	=>
	(retract ?aksi)
	(printout t "
		<div class="result"></div><br>
	    <div class="pa--heading3">&nbsp;&nbsp; Tips </div>
	    <div class="tips-text"><ul>")
	(printout t "<li>Konsumsi cairan yang dianjurkan adalah 2 liter (8 gelas) sehari.</li>")
	(printout t "<li>Batasi penggunaan minyak dengan lemak jenuh.</li>")
	(printout t "<li>Hindari makanan yang digoreng. Cara memasak makanan yang dianjurkan adalah merebus, mengetim, memepes, memanggang, membakar, atau menumis.</li>")
	(printout t "<li>Batasi konsumsi makanan yang mengandung natrium tinggi dan mengandung pengawet.</li>")
	(printout t "<li>Perbanyak konsumsi makanan berserat tinggi dari buah dan sayuran.</li>")
	(printout t "<li>Lakukan aktivitas seperti jalan kaki 2 km per hari.</li>")
	(printout t "</ul></div>"))

(defrule keluarkan-tips-diet-hipertensi
	(declare (salience -60))
	?aksi <- (aksi TENTUKAN-TIPS-DIET)
	?pasien <- (pasien (penyakit ?penyakit) (kategori-berat-badan ?kategori))
	(test (eq ?penyakit "Hipertensi"))
	=>
	(retract ?aksi)
	(printout t "
		<div class="result"></div><br>
	    <div class="pa--heading3">&nbsp;&nbsp; Tips </div>
	    <div class="tips-text"><ul>")
	(printout t "<li>Perbanyak konsumsi cairan sekitar 10 gelas / hari.</li>")
	(printout t "<li>Batasi penggunaan garam pada makanan, yaitu tidak lebih dari 1 sdt (3 g) garam dapur. Dianjurkan tidak menambahkan garam lagi pada makanan karena kebanyakan bahan makanan sudah mengandung garam.</li>")
	(printout t "<li>Hindari bahan makanan dengan kadar natrium tinggi, seperti biskuit, snack ringan, dan makanan berpengawet seperti manisan.</li>")
	(printout t "<li>Perbanyak konsumsi makanan berserat tinggi dari buah dan sayuran.</li>")
	(printout t "<li>Tidak dianjurkan untuk mengonsumsi kopi dan alkohol.</li>")
	(printout t "<li>Lakukan aktivitas seperti jalan kaki 2 km per hari.</li>")
	(printout t "</ul></div>"))

(defrule keluarkan-tips-diet-hipertrigliserida
	(declare (salience -60))
	?aksi <- (aksi TENTUKAN-TIPS-DIET)
	?pasien <- (pasien (penyakit ?penyakit) (kategori-berat-badan ?kategori))
	(test (eq ?penyakit "Hipertrigliserida"))
	=>
	(retract ?aksi)
	(printout t "
		<div class="result"></div><br>
	    <div class="pa--heading3">&nbsp;&nbsp; Tips </div>
	    <div class="tips-text"><ul>")
	(printout t "<li>Konsumsi cairan yang dianjurkan adalah 2 liter (8 gelas) sehari.</li>")
	(printout t "<li>Batasi konsumsi makanan yang digoreng. Cara memasak makanan yang dianjurkan adalah merebus, mengetim, memepes, memanggang, membakar, atau menumis.</li>")
	(printout t "<li>Batasi konsumsi makanan yang mengandung natrium tinggi dan mengandung pengawet.</li>")
	(printout t "<li>Batasi konsumsi makanan yang mengandung gula tinggi dan karbohidrat terlalu banyak.</li>")
	(printout t "<li>Lakukan aktivitas seperti jalan kaki 2 km per hari.</li>")
	(printout t "</ul></div>"))

(defrule keluarkan-tips-diet-jantung
	(declare (salience -60))
	?aksi <- (aksi TENTUKAN-TIPS-DIET)
	?pasien <- (pasien (penyakit ?penyakit) (kategori-berat-badan ?kategori))
	(test (eq ?penyakit "Jantung"))
	=>
	(retract ?aksi)
	(printout t "
		<div class="result"></div><br>
	    <div class="pa--heading3">&nbsp;&nbsp; Tips </div>
	    <div class="tips-text"><ul>")
	(printout t "<li>Konsumsi cairan dibatasi agar tidak memperberat kerja jantung.</li>")
	(printout t "<li>Perbanyak konsumsi ikan yang mengandung omega 3, 6, dan 9.</li>")
	(printout t "<li>Cara memasak makanan yang dianjurkan adalah merebus, mengetim, memepes, memanggang, membakar, atau menumis.</li>")
	(printout t "<li>Hindari bahan makanan dengan kadar natrium tinggi, seperti biskuit, snack ringan, dan makanan berpengawet seperti manisan.</li>")
	(printout t "<li>Hindari makanan yang mengandung gas tinggi seperti ubi dan singkong.</li>")
	(printout t "<li>Perbanyak konsumsi makanan dengan kalsium tinggi, seperti susu, yoghurt; kacang-kacangan; buah seperti jeruk, pisang, dan alpukat.</li>")
	(printout t "<li>Tidak dianjurkan untuk mengonsumsi kopi dan alkohol.</li>")
	(printout t "<li>Bumbu masak yang diperbolehkan adalah semua macam bumbu tetapi tidak yang merangsang dan tidak pedas.</li>")
	(printout t "</ul></div>"))

(defrule keluarkan-tips-diet-penyakit-lambung
	(declare (salience -60))
	?aksi <- (aksi TENTUKAN-TIPS-DIET)
	?pasien <- (pasien (penyakit ?penyakit) (kategori-berat-badan ?kategori))
	(test (eq ?penyakit "Penyakit lambung"))
	=>
	(retract ?aksi)
	(printout t "
		<div class="result"></div><br>
	    <div class="pa--heading3">&nbsp;&nbsp; Tips </div>
	    <div class="tips-text"><ul>")
	(printout t "<li>Perbanyak konsumsi cairan, yaitu 8 - 10 gelas liter sehari.</li>")
	(printout t "<li>Hindari makanan bernatrium tinggi dan berpengawet seperti makanan kaleng.</li>")
	(printout t "<li>Hindari makanan yang mengandung gas tinggi seperti ubi, singkong, dan sayuran putih.</li>")
	(printout t "<li>Dianjurkan untuk makan dengan porsi kecil tetapi lebih sering.</li>")
	(printout t "</ul></div>"))

(defrule print-solusi
	(declare (salience -50))
	(queue)
	?pasien <- (pasien (usia ?u) (jenis-kelamin ?jk) (tinggi-badan ?tb) (berat-badan ?bb) (penyakit ?penyakit) (AMB ?amb) (IMT ?imt) (kategori-berat-badan ?kategori) (kebutuhan-kalori ?kalori) (aktivitas ?aktivitas))
	?kategori-diet <- (tipe-diet ?td)
	=>
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
            <div class=\"col-sm-6\">" ?penyakit "</div>
          </div>
        </div>
        <div class=\"col-sm-5\">
          <div class=\"row\">
            <div class=\"col-sm-6\"><b>Aktivitas fisik</b></div>
            <div class=\"col-sm-5\">" ?aktivitas "</div>
          </div>
          <div class=\"row\">
            <div class=\"col-sm-6\"><b>IMT</b></div>
            <div class=\"col-sm-4\">" ?imt "</div>
          </div>
          <div class=\"row\">
            <div class=\"col-sm-6\"><b>Kategori berat badan</b></div>
            <div class=\"col-sm-5\">" (output-kategori-berat-badan ?kategori) "</div>
          </div>
          <div class=\"row\">
            <div class=\"col-sm-6\"><b>AMB</b></div>
            <div class=\"col-sm-4\">" ?amb " kkal</div>
          </div>
          <div class=\"row\">
            <div class=\"col-sm-6\"><b>Kebutuhan kalori</b></div>
            <div class=\"col-sm-4\">" ?kalori " kkal</div>
          </div>
        </div>
        <div class=\"col-sm-1\"></div>
      </div>
      <div class=\"result\"></div><br>")

	(printout t "<form id=\"menu\">
		<div class=\"pa--heading4\">Pilihan Menu Makanan</div>
		<div class=\"pa--heading-star\">(Pilih salah satu untuk masing-masing bahan makanan)</div>")
	(printout t "
	<div class=\"row\">
        <div class=\"col-md-4 result2\">
          <div class=\"pa--heading3\">Menu Pagi</div>")
	(printout t (output-list-bahan-makanan-utama pagi ?penyakit ?td))
	
	(printout t "
		</div>
		<div class=\"col-md-4 result2\">
          <div class=\"pa--heading3\">Menu Siang</div>")
	(printout t (output-list-bahan-makanan-utama siang ?penyakit ?td))
	
	(printout t "
		</div>
		<div class=\"col-md-4\">
          <div class=\"pa--heading3\">Menu Malam</div>")
	(printout t (output-list-bahan-makanan-utama malam ?penyakit ?td))

	(printout t "
		</div>
      </div>
      <br><br>
      <div class=\"row\">
        <div class=\"col-md-4 result2\">
          <div class=\"pa--heading3\">Snack Pagi (10.00)</div>")
	(printout t (output-list-bahan-makanan-snack snack-pagi))

	(printout t "
		</div>
        <div class=\"col-md-4\">
          <div class=\"pa--heading3\">Snack Sore (16.00)</div>")
	(printout t (output-list-bahan-makanan-snack snack-sore))
	(printout t "</div></div>")
	(printout t "
		<div class="form-group">
          <div class=\"col-md-7 pa__btn-container-form\">
            <input type=\"submit\" class=\"btn btn-tosca btn-margin-bottom\" value=\"Lanjut\"></input>
          </div>
        </div><br><br>
	</form>"))
