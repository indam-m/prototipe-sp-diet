(deftemplate plan
	(slot name (default NONE))
	(slot relation (default nul))
	(multislot subplan (default nul))
	(multislot goal)
	(multislot aksi))

(defrule proses-simpul-aksi
	?cnode <- (queue ?name $?rest)
	?plan <- (plan (name ?name) (relation ?rel) (goal ?goal) (subplan $?sp) (aksi ?r1 $?rn))
	=>
	(assert (aksi ?r1))
	(modify ?plan (aksi $?rn)))

(defrule kontrol-proses-simpul-daun
	?cnode <- (queue ?name $?rest)
	?plan <- (plan (name ?name) (relation nul) (goal ?goal) (subplan nul) (aksi))
	=>
	(retract ?cnode)
	(assert (queue $?rest)))

(defrule kontrol-proses-simpul-AND
	?cnode <- (queue ?name $?rest)
	?plan <- (plan (name ?name) (relation AND) (goal ?goal) (subplan ?sub1 $?child) (aksi))
	=>
	(retract ?cnode)
	(assert (queue ?sub1 $?child $?rest)))

(defrule kontrol-proses-simpul-OR
	?cnode <- (queue ?name $?rest)
	?sgoal <- (goal ?goal)
	?subplan <- (plan (name ?child) (goal ?goal))
	?parent <- (plan (name ?name) (subplan $?children&:(member$ ?child $?children)))
	=>
	(retract ?sgoal)
	(retract ?cnode)
	(assert (queue ?child $?rest)))
