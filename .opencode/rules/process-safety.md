# Rule: Process & Credential Safety

- **Process Protection**: Never kill or restart parent orchestrator sessions, background terminals, or the active SGLang backend (`ornith-30000.service`).
- **Credential Protection**: Never print, leak, or commit `HF_TOKEN`, API keys, or credentials. Read environment files only from `%h/.config/opencode-backends/env`.
- **Portability**: Never hardcode host-specific mount paths (network mounts, absolute user home directories). Resolve paths via `$HOME` or XDG variables.
