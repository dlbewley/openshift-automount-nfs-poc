#!/bin/bash

# git clone https://github.com/paxtonhare/demo-magic.git
source ~/src/demos/demo-magic/demo-magic.sh
TYPE_SPEED=100
PROMPT_TIMEOUT=2
#DEMO_PROMPT="${CYAN}\W${GREEN}➜ ${COLOR_RESET}"
DEMO_PROMPT="${CYAN}\W ${GREEN}$ ${COLOR_RESET}"
DEMO_COMMENT_COLOR=$GREEN
GIT_ROOT=$(git rev-parse --show-toplevel)
DEMO_ROOT=$GIT_ROOT

# https://archive.zhimingwang.org/blog/2015-09-21-zsh-51-and-bracketed-paste.html
#unset zle_bracketed_paste
clear

p "🎉 Ales Nosek rules!"
pei "git remote -v"
p

p "# 🔧 create namespace"
pei "oc apply -k $DEMO_ROOT/namespace"
p "# 🔧 create nfs server"
pei "oc apply -k $DEMO_ROOT/nfs-server"

p
p "# ⌛ wait for nfs-server to start"
pei "oc wait pod -l app=nfs-server --for=condition=Ready=true"
p "# 🔍 view pods"
pei "oc get pods -o wide"

p
p "# 🔍 get service clusterIP for automount opts"
pei "oc get -n automount-nfs-poc svc -o wide"
pei "SERVICE_IP=$(oc get -n automount-nfs-poc svc/nfs-server --output jsonpath='{.spec.clusterIP}')"
pei "echo $SERVICE_IP"
pei "echo '* -rw,soft,intr '${SERVICE_IP}':/exports/&' > automount/extra.nfs"

p
p "# 🔧 create automount daemonset"
pei "oc apply -k $DEMO_ROOT/automount"
p "# ⌛ wait for automount pods to start"
pei "oc wait pod -l app=automount --for=condition=Ready=true"

p
p "# 🔍 view pods"
pei "oc get pods -o wide"
p

p "# 🔧 create nfs mount consumer test pod"
pei "oc apply -k $DEMO_ROOT/test-pod"

p
p "# ⌛ wait for pod to start"
pei "oc wait pod -l app=test-pod --for=condition=Ready=true"
pei "POD=$(oc get pod -l app=test-pod -o name)"
p

p "# 💻 view mounts in test pod"
pei "oc rsh $POD df -h -t nfs"
pei "oc rsh $POD ls /mnt/automount/dallas"

exit