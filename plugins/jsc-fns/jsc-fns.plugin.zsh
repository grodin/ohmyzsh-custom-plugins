# custom useful functions

# psgrep command to grep processes
#   supresses grep itself
function psgrep {
    ps aux | rg -v "grep $@" | grep "$@";
}

#function to find the first match for the first parameter in all parents of the current directory
function upfind() {
  local file="${1}"
  local curr_path="${2}"
  [[ -z "${curr_path}" ]] && curr_path="${PWD}"

  # Search recursively upwards for file.
  until [[ "${curr_path}" == "/" ]]; do
    if [[ -e "${curr_path}/${file}" ]]; then
      echo "${curr_path}/${file}"
      break
    else
      curr_path=$(dirname "${curr_path}")
    fi
  done
}

# Go up directory tree X number of directories
function up() {
    local counter="$@";
    # default $counter to 1 if it isn't already set
    if [[ -z $counter ]]; then
        counter=1
    fi
    # make sure $counter is a number
    if [ $counter -eq $counter 2> /dev/null ]; then
        local nwd="$(pwd)" # Set new working directory (nwd) to current directory
        # Loop $nwd up directory tree one at a time
        until [[ $counter -lt 1 ]]; do
            nwd="$(dirname $nwd)"
            let counter-=1
        done
        cd "$nwd" # change directories to the new working directory
    else
        # print usage and return error
        echo "usage: up [NUMBER]"
        return 1
    fi
}

function vcsroot() {
    if $(in_hg); then
        hg root
    elif git rev-parse --is-inside-work-tree &> /dev/null; then
        git rev-parse --show-toplevel
    fi
}
