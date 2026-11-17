set shell := ["bash", "-euo", "pipefail", "-c"]

# Lists the source and security commands.
default:
    @just --list

# Prepares CI tooling and qualifies requirement installation on an execution host.
setup: setup-source install-check

# Prepares only the existing pinned Ruff tool without building packages or downloading Python.
[group('source')]
setup-source:
    UV_PYTHON_DOWNLOADS=never uvx --no-build --constraints .github/ci-requirements.txt ruff --version

# Runs offline source/workflow/history checks without importing the processor.
check: check-python check-workflows

# Preserves the existing Ruff source check with its exact declared constraint.
[group('checks')]
check-python:
    UV_PYTHON_DOWNLOADS=never uvx --offline --no-build --constraints .github/ci-requirements.txt ruff check .

# Checks command formatting, workflow safety and the complete source history.
[group('checks')]
check-workflows:
    just --fmt --check
    actionlint
    zizmor --offline --no-progress .github
    GIT_NO_LAZY_FETCH=1 gitleaks git --no-banner --redact --log-opts=--all .

# Applies the source linter's automatic fixes and command formatting.
fix:
    uvx --offline --no-build --constraints .github/ci-requirements.txt ruff check --fix .
    just --fmt

# Preserves actual requirement installation in a disposable CI environment, without running the app.
[group('qualification')]
install-check:
    uv venv --python "$(command -v python)" --clear .venv-ci-install
    uv pip install --python .venv-ci-install/bin/python -r requirements.txt

# Preserves mandatory remote-rule Semgrep scanning with its exact existing version and metrics off.
[group('security')]
scan:
    uvx --constraints .github/ci-requirements.txt semgrep scan --error --metrics off --config p/ci

# Runs the complete existing source/install/security scope; there is no declared app test suite.
verify: check install-check scan
