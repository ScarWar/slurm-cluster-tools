# Zsh completion for slx (SLurm eXtended)
# Add to your ~/.zshrc (after compinit):
#   source ~/.local/share/slx/completions/slx.zsh

# Ensure compdef is available (requires compinit to be loaded first)
if ! type compdef &>/dev/null; then
    # If compinit hasn't been run yet, autoload it
    autoload -Uz compinit
    # Don't run compinit here - just make sure compdef is available
    # by setting up the function to be deferred
    _slx_setup_completions() {
        compdef _slx slx
        compdef _slx_submit cs
        compdef _slx_job_id cl ct ck ci
        compdef _slx_find cf
        compdef _slx_project_submit cps
    }
    # Register to run after compinit
    if [[ -z "$_comps" ]]; then
        # compinit hasn't run yet, hook into precmd to set up later
        autoload -Uz add-zsh-hook
        _slx_deferred_setup() {
            if type compdef &>/dev/null; then
                _slx_setup_completions
                add-zsh-hook -d precmd _slx_deferred_setup
                unfunction _slx_deferred_setup
            fi
        }
        add-zsh-hook precmd _slx_deferred_setup
    fi
fi

_slx() {
    local -a commands project_commands
    commands=(
        'init:Initialize slx configuration'
        'project:Project management commands'
        'submit:Submit a SLURM job script'
        'list:List all running/pending jobs'
        'running:List only running jobs'
        'pending:List only pending jobs'
        'kill:Cancel a specific job by ID'
        'killall:Cancel all jobs for current user'
        'logs:View logs for a specific job'
        'tail:Tail logs for a running job'
        'info:Show detailed information about a job'
        'status:Show summary of all user jobs'
        'history:Show job history'
        'find:Find jobs by name pattern'
        'clean:Clean old log files'
        'version:Show version information'
        'help:Show help message'
    )
    
    project_commands=(
        'new:Create a new project'
        'submit:Submit a project job'
        'list:List all projects'
        'help:Show project help'
    )
    
    _describe 'command' commands
    
    case $words[2] in
        project)
            _describe 'project command' project_commands
            case $words[3] in
                submit)
                    local workdir="${SLX_WORKDIR:-$HOME/workdir}"
                    if [ -d "$workdir/projects" ]; then
                        local projects=($(ls -1 "$workdir/projects" 2>/dev/null))
                        _describe 'project' projects
                    fi
                    ;;
            esac
            ;;
        submit)
            _files -g '*.sbatch'
            ;;
        logs|tail|kill)
            if command -v squeue &> /dev/null; then
                local job_ids=($(squeue -u $USER -h -o "%i" 2>/dev/null))
                _describe 'job-id' job_ids
            fi
            ;;
        info)
            if command -v squeue &> /dev/null; then
                local job_ids=($(squeue -u $USER -h -o "%i" 2>/dev/null))
                local options=('--nodes:Show only nodes' '-n:Show only nodes')
                _describe 'job-id' job_ids
                _describe 'option' options
            fi
            ;;
        list)
            _arguments '--user[Specify user]'
            ;;
        history)
            _arguments '--days[Number of days]'
            ;;
        find)
            if command -v squeue &> /dev/null; then
                local job_names=($(squeue -u $USER -h -o "%j" 2>/dev/null | sort -u))
                _describe 'job-name' job_names
            fi
            ;;
    esac
}

# Completion for aliases
_slx_submit() {
    _files -g '*.sbatch'
}

_slx_job_id() {
    if command -v squeue &> /dev/null; then
        local job_ids=($(squeue -u $USER -h -o "%i" 2>/dev/null))
        _describe 'job-id' job_ids
    fi
}

_slx_find() {
    if command -v squeue &> /dev/null; then
        local job_names=($(squeue -u $USER -h -o "%j" 2>/dev/null | sort -u))
        _describe 'job-name' job_names
    fi
}

_slx_project_submit() {
    local workdir="${SLX_WORKDIR:-$HOME/workdir}"
    if [ -d "$workdir/projects" ]; then
        local projects=($(ls -1 "$workdir/projects" 2>/dev/null))
        _describe 'project' projects
    fi
}

# Register completions if compdef is available
if type compdef &>/dev/null; then
    compdef _slx slx
    compdef _slx_submit cs
    compdef _slx_job_id cl ct ck ci
    compdef _slx_find cf
    compdef _slx_project_submit cps
fi
