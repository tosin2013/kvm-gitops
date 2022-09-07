GitOps Catalog
==========================================
The `GitOps Catalog <https://github.com/redhat-cop/gitops-catalog>`_ includes kustomize bases and overlays for a number of OpenShift operators and applications


clone gitops-catalog from your repo::

    git clone  http://your-git-server:3000/svc-gitea/gitops-catalog.git 


Deploy ArgoCD
-------------
Deploy ArgoCD using the ArgoCD Operator::

    cd openshift-gitops-operator/
    oc apply -k overlays/gitops-1.6

Deploy ArgoCD insatance::

    cat >/tmp/argoinstance.yaml<<EOF
    apiVersion: argoproj.io/v1alpha1
    kind: ArgoCD
    metadata:
    name: argocd
    namespace: openshift-operators
    spec:
    server:
        resources:
        limits:
            cpu: 500m
            memory: 256Mi
        requests:
            cpu: 125m
            memory: 128Mi
        route:
        enabled: true
    sso:
        dex:
        resources:
            limits:
            cpu: 500m
            memory: 256Mi
            requests:
            cpu: 250m
            memory: 128Mi
        openShiftOAuth: true
        provider: dex
    rbac:
        defaultPolicy: ''
        policy: |
        g, system:cluster-admins, role:admin
        scopes: '[groups]'
    repo:
        resources:
        limits:
            cpu: 1000m
            memory: 1024Mi
        requests:
            cpu: 250m
            memory: 256Mi
    ha:
        resources:
        limits:
            cpu: 500m
            memory: 256Mi
        requests:
            cpu: 250m
            memory: 128Mi
        enabled: false
    redis:
        resources:
        limits:
            cpu: 500m
            memory: 256Mi
        requests:
            cpu: 250m
            memory: 128Mi
    controller:
        resources:
        limits:
            cpu: 2000m
            memory: 2048Mi
        requests:
            cpu: 250m
            memory: 1024Mi
    resourceExclusions: |
        - apiGroups:
        - tekton.dev
        clusters:
        - '*'
        kinds:
        - TaskRun
        - PipelineRun        
    EOF

    $ oc create -f /tmp/argoinstance.yaml