1. User Kube-config

    1.1 Build user information for martin in the default kubeconfig file: 
        User = martin , 
        client-key =/root/martin.key and
        client-certificate =/root/martin.crt 
    ```
        kubectl config set-credentials martin \
        --username=martin  \
        --client-key=/root/martin.key \
        --client-certificate=/root/martin.crt 
    ```
    
    1.2 Create a new context called 'developer' in the default kubeconfig file: 
        'user = martin'
        'cluster = kubernetes'
   
    ```
        kubectl config set-context developer \
        --user=martin \
        --cluster=kubernetes \
        --namespace=development
    ```

2. Developer-role
    developer-role should have all(*) permissions :
    2.1  for services in development namespace
    2.2  for persistentvolumeclaims in development namespace
    2.3  for pods in development namespace

    ```
        kubectl -n development create role developer-role  \
        --resource=pods,services,pvc \
        --verb="*"   --dry-run=client -o yaml > role.yaml
    ```

3. Developer-rolebinding
    create rolebinding = developer-rolebinding, 
    role= 'developer-role', 
    namespace = development

    rolebinding = developer-rolebinding associated with user = 'martin'

    ```
        kubectl -n development create rolebinding developer-rolebinding  \
        --clusterrole=developer-role \
        --user=martin   --dry-run=client -o yaml > rolebinding.yaml
    ```
    Test
    ```
    kubectl config get-contexts
    kubectl config use-context developer

    kubectl auth can-i create pods --all-namespaces

    kubectl auth can-i --list --namespace=development
    kubectl auth can-i create pods --namespace=development

    kubectl auth can-i '*' '*'

    ```


4. Kube-config
    set context 'developer' with user = 'martin' and cluster = 'kubernetes' as the current context.

    ```
        kubectl config use-context developer  
    ```

5. Service jeykyll

    Service 'jekyll' uses : 
    targetPort: '4000', namespace: 'development'
    Port: '8080', namespace: 'development'
    NodePort: '30097', namespace: 'development'

    ```
        kubectl -n development create service nodeport jekyll-node-service \        
        --nodeport=30097 --tcp=8080:4000 --dry-run=client -o yaml > jekyll-service.yaml
    ```

6. Pod jeykill

    pod: 'jekyll' has an initContainer, 
    name: 'copy-jekyll-site', 

    initContainer: 'copy-jekyll-site', 
    image: 'kodekloud/jekyll'
    command: [ "jekyll", "new", "/site" ]  
    mountPath = '/site'
    volume name = 'site'

    pod: 'jekyll', container: 'jekyll', 
    volume name = 'site'
    mountPath = '/site'
    image = 'kodekloud/jekyll-serve'

    pod: 'jekyll', 
    uses volume called  'site' with pvc = 'jekyll-site'
    label 'run=jekyll'

    ```
        kubectl -n development run jekyll \
        --image=kodekloud/jekyll-serve \ 
        --dry-run=client -o yaml > jekyll-pod.yaml
    ```



   