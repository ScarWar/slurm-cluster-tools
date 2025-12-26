# Cluster management aliases for bash/zsh
# Source this file in your .bashrc/.zshrc or run: source cluster_aliases.sh
# 
# To add permanently, add this line to your ~/.bashrc or ~/.zshrc:
#   source $HOME/workdir/cluster_aliases.sh
#
# You can override the workdir by setting CLUSTER_WORKDIR before sourcing:
#   export CLUSTER_WORKDIR=/path/to/workdir
#   source $CLUSTER_WORKDIR/cluster_aliases.sh

# Set cluster script directory (defaults to $HOME/workdir)
if [ -z "$CLUSTER_WORKDIR" ]; then
    export CLUSTER_WORKDIR="$HOME/workdir"
fi
CLUSTER_DIR="$CLUSTER_WORKDIR"

# Base command
alias c="$CLUSTER_DIR/cluster.sh"

# Submit jobs
alias cs="$CLUSTER_DIR/cluster.sh submit"

# View logs
alias cl="$CLUSTER_DIR/cluster.sh logs"

# List jobs
alias cls="$CLUSTER_DIR/cluster.sh list"

# Running jobs
alias cr="$CLUSTER_DIR/cluster.sh running"

# Pending jobs (renamed from 'cp' to avoid conflict with copy command)
alias cpd="$CLUSTER_DIR/cluster.sh pending"

# Kill job
alias ck="$CLUSTER_DIR/cluster.sh kill"

# Kill all jobs
alias cka="$CLUSTER_DIR/cluster.sh killall"

# Tail logs
alias ct="$CLUSTER_DIR/cluster.sh tail"

# Job info
alias ci="$CLUSTER_DIR/cluster.sh info"

# Status summary
alias cst="$CLUSTER_DIR/cluster.sh status"

# History
alias ch="$CLUSTER_DIR/cluster.sh history"

# Find jobs
alias cf="$CLUSTER_DIR/cluster.sh find"

# Clean logs (renamed from 'cc' to avoid conflict with C compiler)
alias ccl="$CLUSTER_DIR/cluster.sh clean"

# Load bash completion if available
if [ -f "$CLUSTER_DIR/cluster-completion.bash" ]; then
    source "$CLUSTER_DIR/cluster-completion.bash"
fi

