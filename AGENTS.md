# Source maintenance

Use `just setup-source` for the exact declared Ruff tool, then `just check` for
offline source/workflow/history checks. Source history must have every required
blob before scanning; check-time Git lazy fetch is disabled.

`just setup`, `just install-check`, `just scan` and `just verify` belong on execution
hosts: they retain requirement installation and the mandatory metrics-off scanner
rules. The installation fixture is disposable CI state, separate from product
launchers. No formal behavior suite is declared here; these commands do not run
the processor or generate PDFs.

Preserve ignored exports, environments, credentials and generated personal data.
Source verification never opens real Telegram exports or runs launchers/installers.
The existing product entry points and font/configuration behavior stay independent.
