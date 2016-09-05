(deftemplate pasien
	(slot usia)
	(slot jenis-kelamin)
	(slot berat-badan)
	(slot tinggi-badan)
	(slot aktivitas)
	(slot penyakit)
	(slot AMB (default 0))
	(slot IMT (default 0))
	(slot kategori-berat-badan (default 0))
	(slot kebutuhan-kalori (default 0)))

(deftemplate bahan-makanan
	(slot nama (type STRING))
	(slot golongan)
	(slot berat (default 0)) ; berat dalam satuan gram
	(multislot URT)
	(slot purin (default rendah))
	(slot lemak (default nul))
	(slot serat (default nul))
	(multislot tidak-dianjurkan (default nul)))

(deftemplate sayuran-A
	(slot nama (type STRING))
	(slot serat (default rendah)))

(deftemplate solusi-menu
	(slot nama (type STRING))
	(slot golongan)
	(slot waktu)
	(slot berat (default 0)) ; berat dalam satuan gram
	(multislot URT)
	(slot lemak))

(deftemplate standar-diet
	(slot kalori)
	(multislot pagi)
	(multislot snack-pagi)
	(multislot siang)
	(multislot snack-sore)
	(multislot malam))
