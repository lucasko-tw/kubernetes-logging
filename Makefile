deploy:
	kubectl create namespace logging || true
	helm install --debug --name elasticsearch stable/elasticsearch  -f  elasticsearch/values.yaml  --namespace logging

	sleep 300
	kubectl -n logging get pods,pvc

	kubectl apply -f fluent-bit/configmap.yaml

	helm install --debug --name fluent stable/fluent-bit  -f  fluent-bit/values.yaml  --namespace logging
	helm install --debug --name kibana stable/kibana      -f  kibana/values.yaml      --namespace logging
	kubectl apply -f kibana/ingress.yaml

	kubectl -n logging get pods

delete:
	kubectl delete -f kibana/ingress.yaml || true
	helm del --purge kibana || true
	helm del --purge fluent || true
	helm del --purge elasticsearch || true
	sleep 30
	kubectl -n logging get pods

