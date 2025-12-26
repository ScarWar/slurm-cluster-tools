#!/bin/bash
# DEPRECATED: cluster.sh is now slx (SLurm eXtended)
# This wrapper exists for backward compatibility
# Please use 'slx' instead

echo "Note: cluster.sh is deprecated. Please use 'slx' instead." >&2
echo "" >&2

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Execute slx with all arguments
exec "$SCRIPT_DIR/slx" "$@"
