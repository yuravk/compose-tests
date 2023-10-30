# Quick Start

On Centos Stream 9 as `root`:


```sh
tmt -vvv -c distro=centos-stream-9 run --all provision --how=local
```

# Directory Structure

## `plans`

TMT plans.

* `external/`: Plans that import remote tmt tests (e.g., from gitlab.com/redhat/centos-stream/rpms)
* `ng.fmf`: The plan that runs the new generation of tests in `tests/` that fully leverage `tmt`, excluding the ones in `tests/legacy`
* `legacy.fmf`: The plan that runs the `t_functional` tests in `tests/legacy/`


## `tests`

Tests will be organized in one directory per packages and one directory per integration test comprising multiple packages.
The `legacy` contains the tests imported from `t_functional`.

# Adding a Test

Create a folder inside `tests/` named after the package you want to test, e.g., `httpd`. It could also be named after some integration test involving multiple packages (e.g., `httpd-php-postgresql`).

Organize your tests inside the folder by features you are testing. Feel free to leverage `tmt` and `beakerlib` to design them. You can follow the `podman` test as an example.

* `tmt` documentation: https://tmt.readthedocs.io
* `beakerlib` documentation: https://beakerlib.readthedocs.io/en/latest/manual.html#

When finished, ensure the tests pass the linting `tmt lint`.

You should be able to run your tests by simply cd'ing into them and running the shell scripts. Example:

```sh
cd tests/podman/image/ls
./test.sh
```

You can also run them using the `tmt` tool. Example of how to run `podman/image/ls` with `tmt` directly on your machine.

```sh
tmt -vv -c distro=centos-stream-9 run -a provision --how=local test --name /podman/image/ls
```

Test outputs will be in the default temp `tmt` folder, e.g. `/var/tmp/tmt`. If you pass `-vv` to the command as in the example above, you will get the full path to the output of each test. For example:

```yaml
    report
        how: display
            pass /tests/podman/image/ls
                output.txt: /var/tmp/tmt/run-1/plans/execute/data/guest/default-0/tests/podman/image/ls-1/output.txt
                journal.txt: /var/tmp/tmt/run-1/plans/execute/data/guest/default-0/tests/podman/image/ls-1/journal.txt
        summary: 1 test passed
```

# Adding an External Test

Create a `.fmf` file within `plans/external/` named after the package, and follow the `tmt` documentation how to import tmt tests from git (see the `discover` step [Example](https://tmt.readthedocs.io/en/stable/examples.html#plans), and [Specs](https://tmt.readthedocs.io/en/stable/spec/plans.html#spec-plans-discover) ). You can follow the `plans/external/podman.fmf` example.

# Enabling/Disabling Tests

You can enable or disable test based on the distro in the `fmf` file. Example:

```yaml
enabled: true # default
adjust: # change "enabled" value when condition is true
  when: distro == centos-7
  enabled: false
```

You can also disable a test all together with the same `enabled: false` flag on the test `fmf` file. Example:

```yaml
summary: tests podman pull
description: It tests podman pull with different options
enabled: false # disabling for now until issue #99999 is resolved
```

# Tiers

TODO: define the tiers and what tiers a test should go into.
