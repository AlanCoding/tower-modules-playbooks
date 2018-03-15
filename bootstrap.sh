# this is a tower-cli script to add playbooks to Tower
# the playbooks it adds uses the tower modules inside Ansible
# the tower modules import tower-cli
# the Tower server runs these playbooks
# and thus, the circle of life is complete

tower-cli organization create --name=Default
tower-cli project create --name="tower module playbooks" --organization=Default --scm-type=git --scm-url="https://github.com/AlanCoding/tower-modules-playbooks.git" --wait
tower-cli inventory create --name="localhost" --organization=Default --variables="connection: local"
tower-cli host create --name="localhost" --inventory="localhost"
tower-cli job_template create --name="tower module JT" --project="tower module playbooks" --inventory="localhost" --playbook="create_users.yml" --limit="localhost"

# go full meta
tower-cli user create --is-superuser=true --username="admin_for_modules" --password="modules4lyfe" --email="asdf@asdf.com"
tower-cli credential create --name="self" --credential-type="Ansible Tower" --inputs="{'host': 'http://localhost:8013/', 'username': 'admin_for_modules', 'password': 'modules4lyfe'}" --organization=Default

tower-cli job_template associate_credential --credential="self" --job-template="tower module JT"

tower-cli job launch -J="tower module JT" --monitor
