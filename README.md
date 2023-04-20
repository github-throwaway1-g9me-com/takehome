
# Takehome task

### Requirements

* Ansible installed.
* Terraform installed.
* Public/Private keys (ex: ssh-keygen) and update the keys in `terraform/create-instance.tf`:

```
...
  metadata = {
    ssh-keys = "root:${file("/path/to/public/key/id_rsa.pub")}"
  }
...
```

`ansible/hosts`
```
www ansible_host=www.terraform.takehome ansible_user=root ansible_port=22 ansible_ssh_private_key_file=/path/to/private/key/id_rsa
```

* Google Could with privileges to create roles and service accounts.
* Create a role (https://console.cloud.google.com/iam-admin/roles/create) for launching google instances with the following permissions:
```
compute.disks.create
compute.firewalls.create
compute.firewalls.delete
compute.firewalls.get
compute.instances.create
compute.instances.delete
compute.instances.get
compute.instances.list
compute.instances.setTags
compute.instances.setMetadata
compute.networks.updatePolicy
compute.subnetworks.use
compute.subnetworks.useExternalIp
compute.zones.get
```
* Create Service account (https://console.cloud.google.com/iam-admin/serviceaccounts). Assign the previously created role to it along with the existing "DNS Administrator" role.  Then generate a json key file and override the sample provided in  `terraform/credentials.json` .


### Installation Steps

* Setup.
```
cd terraform
terraform init
terraform apply -auto-approve
...

cd ../ansible/
ansible-playbook -i hosts takehome.yml
```

* Cleanup.
```
cd terraform
terraform destroy -auto-approve
```
