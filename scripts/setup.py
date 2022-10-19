import json
import os
from pathlib import Path
from pywebio import start_server
from pywebio.input import *
from pywebio.output import *
from pywebio.session import set_env, info as session_info

def main():
    """OpenShift Installer

    Install Optionshift 
    """
    set_env(auto_scroll_bottom=True)
    cwd = os.getcwd()
    hostname = os.uname()
    home = str(Path.home())

    put_markdown(("""# Kvm GitOps Repository
    
    You can deploy OpenShift Via the Assisted Installer using the methods below 
    
    * [Offical Website](https://console.redhat.com/openshift)
      * [How to use the OpenShift Assisted Installer](https://cloud.redhat.com/blog/how-to-use-the-openshift-assisted-installer)
    * [BILLI/Agent-based Installer early access](https://github.com/tosin2013/openshift-4-deployment-notes/tree/master/billi)
      * [ZTP for OpenShift Alpha Clusters](https://cloudcult-dev.cdn.ampproject.org/c/s/cloudcult.dev/openshift-feature-prebuilt-iso-deployments/amp/)
    * [Using the Assisted Installer Scripts manually](https://github.com/tosin2013/openshift-4-deployment-notes/tree/master/assisted-installer)
    * [OpenShift Assisted Installer Service, Universal Deployer](https://github.com/kenmoini/ocp4-ai-svc-universal)
    * [Deploy with podman](https://github.com/openshift/assisted-service/tree/master/deploy/podman)
    * Continuing with the steps below.

    """))

    config_location = select('Where would you like to store the configuration?', ['dev', 'qa', 'staging','production'])
    put_markdown("`config_location = %r`" % config_location)

    path_to_file = home+'/.ssh/id_rsa.pub'
    path = Path(path_to_file)

    if path.is_file():
        print(f'The file {path_to_file} exists')
    else:
        print(f'The file {path_to_file} does not exist')
        popup('The file '+str(path_to_file)+' does not exist',  [
        put_markdown("""
        Ensure there is an SSH Public Key at ~/.ssh/id_rsa.pub
        ```
        ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
        ```
        """),
        put_buttons(['close'], onclick=lambda _: close_popup())
        ])

    path_to_file = home+'rh-api-offline-token'
    path = Path(path_to_file)

    if path.is_file():
        print(f'The file {path_to_file} exists')
    else:
        put_markdown("""
        ##  Get offline token 
        [Getting started with Red Hat APIs](https://access.redhat.com/articles/3626371)
        Generating an access token — An offline token never expires as long as it is used at least once every 30 days and is used to create access tokens.
        [Red Hat API Tokens](https://access.redhat.com/management/api)
        """)
        text = textarea('Get offline token', rows=8, placeholder="Paste the token here")
        offline_token = open(home+"rh-api-offline-token", "w")
        offline_token.write(str(text))
        offline_token.close()

    path_to_file = home+'ocp-pull-secret'
    path = Path(path_to_file)

    if path.is_file():
        print(f'The file {path_to_file} exists')
    else:
        put_markdown("""
        ## Get OpenShift Pull Secret
        The pull secret is used to identify that an account exists and only permits downloading of images.
        [Install OpenShift on Bare Metal](https://console.redhat.com/openshift/install/metal/installer-provisioned)
        """)
        text = textarea('Get OpenShift Pull Secret', rows=25, placeholder='Paste the secret here')
        pull_secret = open(home+"ocp-pull-secret", "w")
        pull_secret.write(str(text))
        pull_secret.close()

    deployment_type = select('Select Deployment Type?', ['sno', 'converged', 'full'])
    put_markdown("`deployment_type = %r`" % deployment_type)


    with open(cwd+'/inventories/example/'+deployment_type+'-cluster-vars.sh') as f:
        contents = f.read()
        print(contents)

    code = textarea('Update Cluster Vars for Deployment', code={
        'mode': "python", 
        'theme': 'darcula', 
    }, value=contents, rows=100)

    put_markdown("Review:\n```python\n%s\n```" % code)
    bytes_code = bytes(code, 'utf-8')
    put_file(deployment_type+'-cluster-vars.sh', bytes_code)
    cluster_vars = open(cwd+'/inventories/'+config_location+'/'+deployment_type+'-cluster-vars.sh', "w")
    cluster_vars.write(str(code))
    cluster_vars.close()

    put_markdown("""
    ## Start OpenShift installation
    [https://console.redhat.com/openshift](https://console.redhat.com/openshift)
    login to the terminal ans run the following commands:
    3. Run the bootstrap script to create the cluster, configure it, and download the ISO
    > the bootstrap-create.sh script may also be used. 
    ```
    ./bootstrap.sh
    ./hack/create-kvm-vms.sh # Change the CPU and Memory to match your requirements then run this script
    ./bootstrap-install.sh # you may have to login to console.redhat.com and hit install 

    ./hack/watch-and-reboot-kvm-vms.sh

    ./bootstrap-post-install.sh
    ```
    """)

    put_markdown("Your configuration has been stored under:\n```"+cwd+'/inventories/'+config_location+'/```')
    
if __name__ == '__main__':
    start_server(main, debug=True, port=8081)