# Tentris Paper Benchmarks

## Usage

### Ansible

[Ansible](https://www.ansible.com/overview/how-ansible-works) is an automation that uses plain SSH connections to configure systems according to a so called playbook.  
A playbook defines a target statefor a system and Ansible takes steps to transform the current state into the desired state.  
Ansible is executed on a so called control node (For example your PC, laptop, workstation, ...) and connects to one or more managed nodes (For example a server, VM, remote PC, ...).

### Preperation

Install Ansible on your control node using the official install guide: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

This playbook was tested with `Jinja2==3.0.3` and `ansible==5.7.0`. 

Prepare your Ansible inventory.  
Ansible usues a so called inventory to know which managed nodes to connect to and apply some settings to hosts.  
A inventory template can be found in `inventory.yaml.example`.

#### graphdb_local_zip_path

GraphDB is a commercial product and requires a license to download.  
You can get a free license here: https://www.ontotext.com/products/graphdb/graphdb-free/  
After filling out the form, you will receive an e-mail containing a download link.
Use it to download the file and store it somewhere on your machine.
Then set graphdb_local_zip_path to the path to the file you just downloaded.

#### hypertrie_local_dir and tentris_local_dir

During development the required features for removal were not yet included in the public
releases of tentris or hypertrie. They are instead located in the private repositories.
So clone a version of hypertrie and tentris that support entry removal to your
local machine and set the corresponding paths.


#### swdf_queries_file and dbpedia2015_queries_file

The query files are quite large and are thus not stored in this repo
instead you can download them from my [google drive](https://drive.google.com/drive/folders/17_K3CN2kyWPEdlwUbezpZvMowtSWMa3A?usp=sharing).
Then set the corresponding paths to the paths of the zip files.



### Playbook execution

If you have prepared the inventory you can execute the playbook.  
To do this use the `ansible-playbook -kKi inventory.yaml playbook.yaml` command.  
It will ask you for your SSH password and your become (sudo) password.  
After you have entered your password the execution will start.

## Dataset and Queris

Links to the datasets and queries can be found in:
- [roles/dataset_swdf](./roles/dataset_swdf)
- [roles/dataset_dbpedia2015](./roles/dataset_dbpedia2015)
- [roles/dataset_watdiv](./roles/dataset_watdiv)
- [roles/dataset_wikidata-20201111](./roles/dataset_wikidata-20201111) 
