listening() {
    if [ $# -eq 0 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P
    elif [ $# -eq 1 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
    else
        echo "Usage: listening [pattern]"
    fi
}

# Convert Base36 to Decimal
alias base36="echo $((36#$1))"

python=/usr/local/bin/python3
# alias ansible_playbook="/Users/stevenrhodes/Documents/Projects/docker-containers/ansible_2.7/run"
# alias c7n="custodian run --output-dir=/tmp "

export EDITOR=vim

# File search functions
function f() { find . -iname "*$1*" ${@:2} }
function r() { grep "$1" ${@:2} -R . }

# Create a folder and move into it in one command
function mkcd() { mkdir -p "$@" && cd "$_"; }

# function run_in_container {
#   ${HOME}/projects/diag-useful-scripts/azure-tf-dev-container/run.sh
# }

function kctl() {
  case $1 in
    "all") k="get all --all-namespaces";;
    "desc") k="describe"
  esac
  kubectl $k
}

alias k="kubectl"
alias tfi="terraform init"
alias tfp="terraform plan"
alias tfs="terraform show"
alias tfa="terraform apply"
alias tfd="terraform destroy"
alias tfaa="terraform apply -auto-approve"
alias tfda="terraform destroy -auto-approve"
alias tfdebug="export TF_LOG=DEBUG; export TF_LOG_PATH=."
alias tfclean="rm -rf .terraform terraform.tfstate*"

#######
# Azure Kubernetes Service
######
function aksgc() {
	if [ -z $1 ] || [ -z $2 ];
	then
		aksls table
		echo "
  Usage:
	aksgc < Cluster Name > < Resource Group Name >
		"
	fi

  az aks get-credentials --name $1 --resource-group $2
}

function aksls() {
  if [ -z $1 ];
  then
  	fmt=table
  	echo "
  	aksls table | yaml[c] | json[c] 
  	"
  else
        fmt=$1
  fi
  az aks list --output $fmt
}

function azshow() {
  az account show --output yaml
}

function azset() {
	case $1 in
		diag-lab) S="Lab";;
		mgt-prd) S="Mgmt-Prod";;
		# Add more here as needed. Replace above examples to suite your environment.
		*) 
		echo "
		$1​ is not a valid subscription
		Please use the following format
		< Abbreviation >-< Environment >
		Example: mgt-prd 

		Environments: dev, stg, prd

		Abbreviation: diag, mgt"
	esac

	export SUBSCRIPTION="<Azure Sub Name base>-${S}"
	az account set -s $SUBSCRIPTION --verbose
	echo -e "Subscription set to \e[30;48;5;82m${SUBSCRIPTION}\e[0m"
}
[[ /usr/local/bin/kubectl ]] && source <(kubectl completion zsh)


autoload bashcompinit && bashcompinit
source /usr/local/etc/bash_completion.d/az

export PATH="$HOME/.tfenv/bin:$PATH"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
autoload -U compinit; compinit
