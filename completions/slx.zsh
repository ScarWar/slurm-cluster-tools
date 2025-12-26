# Zsh completion for slx (SLurm eXtended)
# Add to your ~/.zshrc:
#   source ~/.local/share/slx/completions/slx.zsh

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

compdef _slx slx

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

compdef _slx_submit cs
compdef _slx_job_id cl ct ck ci
compdef _slx_find cf
compdef _slx_project_submit cps

