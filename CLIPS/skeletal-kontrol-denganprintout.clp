(deftemplate plan
	(slot name)
	(slot relation)
	(multislot subplan)
	(multislot goal)
	(multislot aksi)
)

(defrule proses-simpul-aksi
	?cnode <- (queue ?name $?rest)
	?plan <- (plan (name ?name) (relation ?rel) (goal ?goal) (subplan $?sp) (aksi ?r1 $?rn))
	=>
	(assert (aksi ?r1))
	(modify ?plan (aksi $?rn))
	;(if (member$ nul $?sp) then
	;	(printout t "Simpul " ?name " - " ?goal " sedang diproses" crlf)
	;else
	;	(printout t "Pemilihan anak simpul " ?name " - " ?goal " : " $?sp crlf))
)

(defrule kontrol-proses-simpul-daun
	?cnode <- (queue ?name $?rest)
	?plan <- (plan (name ?name) (relation nul) (goal ?goal) (subplan nul) (aksi))
	=>
	(retract ?cnode)
	(assert (queue $?rest))
	;(printout t "Simpul " ?name " - " ?goal " telah diproses" crlf "Node antrian sekarang : [" $?rest "]" crlf)
)

(defrule kontrol-proses-simpul-AND
	?cnode <- (queue ?name $?rest)
	?plan <- (plan (name ?name) (relation AND) (goal ?goal) (subplan ?sub1 $?child) (aksi))
	=>
	(retract ?cnode)
	(assert (queue ?sub1 $?child $?rest))
	;(printout t "Node antrian sekarang : [" ?sub1 " " ?child " " $?rest "]" crlf)
)

(defrule kontrol-proses-simpul-OR
	?cnode <- (queue ?name $?rest)
	?sgoal <- (goal ?goal)
	?subplan <- (plan (name ?child) (goal ?goal))
	?parent <- (plan (name ?name) (subplan $?children&:(member$ ?child $?children)))
	=>
	(retract ?sgoal)
	(retract ?cnode)
	(assert (queue ?child $?rest))
	;(printout t "Node antrian sekarang : [" ?child " " $?rest "]" crlf)
)
