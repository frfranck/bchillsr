# bchillsr
smart routing demo

# Preliminary
	see pip install instruction in srvrequirements.txt


# Start the server
	python coreservice.py

# Push an event to the server
	curl  --header "Content-Type:application/json" -X PUT -d '{"status": "done","delay": 0}' http://127.0.0.1:8080/api/event/cis1/dh1/airb1/a123/H/P2/success/0

	cis1: provider
	dh1: supplier
	airb1: final delivery
	a123: command id
	H: priority - L (low), M (medium) or H (high)
	P2: location - P1, P2, P3 or P4
	success: status - progress, blocked, success
	0: remaining delay in second for the command to be delivered

# Basic Single page test:
	open a web browser
	go to http://<ip><<<<:8080/

# Web Socket API endpoint:
	http://<ip>:8080/events

    message structure
    <producer>:<supplier>:<receiver>:<cmdid>:<priority>:<location>:<status>:<delay>

# Button / API call mapping
	P1:
		curl  --header "Content-Type:application/json" -X PUT -d '{"status": "progress"}' http://127.0.0.1:8080/api/event/cis1/dh1/airb1/a123/H/P1/progress/12000

	P2:
		curl  --header "Content-Type:application/json" -X PUT -d '{"status": "progress"}' http://127.0.0.1:8080/api/event/cis1/dh1/airb1/a123/H/P2/progress/6000

	P3:
		curl  --header "Content-Type:application/json" -X PUT -d '{"status": "progress"}' http://127.0.0.1:8080/api/event/cis1/dh2/airb1/a123/H/P3/progress/3000

	P4:
		curl  --header "Content-Type:application/json" -X PUT -d '{"status": "done"}' http://127.0.0.1:8080/api/event/cis1/dh2/airb1/a123/H/P4/success/0

# Raise an incident
	PBAD:
		curl  --header "Content-Type:application/json" -X PUT -d '{"status": "blocked"}' http://127.0.0.1:8080/api/event/cis1/dh1/airb1/a123/H/PBAD/blocked/240000

