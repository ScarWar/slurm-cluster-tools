# SLX Open Source Project Task List

## Features

- [x] Compute Profile Management
  - [x] Allow creation of compute profiles (e.g., CPU job, large/small LLM jobs)
  - [x] Save scenarios as reusable profiles
  - [x] Enable profile selection when generating new `sbatch` files (e.g., when starting a new project)

- [x] Dialog Improvements
  - [x] Display additional details for each compute node (e.g., GPU type, CPU, memory)
  - [x] Provide more guidance and context to users during the machine selection process

- [ ] CLI Enhancements
  - [ ] Implement `slx run --profile profile [command]` option to run commands using a specified profile

<!--
- [ ] Automatic symlink creation for relevant files or directories
-->

