docker build    -t talevin2000/multi-client:latest \
                -t talevin2000/multi-client:$GIT_SHA \
                -f ./client/Dockerfile ./client

docker build    -t talevin2000/multi-server:latest \
                -t talevin2000/multi-server:$GIT_SHA \
                -f ./server/Dockerfile ./server

docker build    -t talevin2000/multi-worker:latest \
                -t talevin2000/multi-worker:$GIT_SHA \
                -f ./worker/Dockerfile ./worker

docker push talevin2000/multi-client:latest
docker push talevin2000/multi-server:latest
docker push talevin2000/multi-worker:latest

docker push talevin2000/multi-client:$GIT_SHA
docker push talevin2000/multi-server:$GIT_SHA
docker push talevin2000/multi-worker:$GIT_SHA

kubectl apply -f k8s

kubectl set image \
    deployments/client-deployment \
    client=talevin2000/multi-client:$GIT_SHA

kubectl set image \
    deployments/server-deployment \
    server=talevin2000/multi-server:$GIT_SHA

kubectl set image \
    deployments/worker-deployment \
    worker=talevin2000/multi-worker:$GIT_SHA

helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace