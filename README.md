# Naive usage may result in letsencrypt ban. You've been warned.

Start with minimal set of domains (`primary` + `www.primary`) and make sure they are configured and resolvable *BEFORE* applying the playbook

# Ansible variables to set up

* `nginx_le_account` -- email
* `nginx_le_primary_domain` -- configure it (and `www.` subdomain) before deploying role
* `nginx_le_mode` -- is `staging` by default, switch to `prod` when needed
* `nginx_le_install_dir` -- defaults to `/opt/nginx-letsencrypted`

# Files location:

* `{{ nginx_le_install_dir }}/data/configs` -- configuration files 
* `{{ nginx_le_install_dir }}/data/storage/static` -- static files as configured in default config

# Configuration

See [./templates/default.conf](./templates/default.conf)
