# Container recipe for Trollflow2

This recipe is automatically built on new version tags, and the image
is available from
https://quay.io/repository/fmi/weather-satellites-trollflow2

Trollflow2 is a Pytroll library for satellite data processing. This
recipe can be used to build a container image for use in OpenShift,
Kubernetes, Docker, Podman etc.

## Configuration

In the simplest case only composites built-in to Satpy are used. Then
all configuration files are places within `/config/` directory.

### `/config/env-variables`

The entrypoint will start by setting environment variables placed in
`/config/env-variables` file. There are two strictly required items:

```bash
# Set the Satpy configuration directory paths
export SATPY_CONFIG_PATH="/config/"
# Set the source of the incoming messages
export MESSAGE_SOURCE="tcp://<dns-name-of-publisher>:<port-number>"
```

If there are multiple message sources, they can be defined like this:

```bash
export MESSAGE_SOURCE="tcp://source1:40000 tcp://source2:40001 tcp://source3:40003"
```

This are then combined and passed to `satpy_launcher.py` with the `-a`
argument.

### Trollflow2 configuration

Two configuration files for Trollflow2 are required:
* `/config/trollflow2_log_config.yaml`
* `/config/trollflow2.yaml`

Refer to https://github.com/pytroll/trollflow2 on defining these.

### Additional composites and enhancements

The additional composite definitions should be placed in
`$SATPY_CONFIG_PATH/composites/<instrument>.yaml` and enhancements in
`$SATPY_CONFIG_PATH/enhancements/<instrument>.yaml`.

Note that as OpenShift ConfigMap objects don't support nested
directories, the composite and enhancement directories need to placed
directly under the root directory and additional item is needed for
Satpy config path:

```bash
export SATPY_CONFIG_PATH="/config/:/"
```

For Docker or Podman, the easiest way is to put all the configs in one
directory structure and use the more simple `SATPY_CONFIG_PATH` from
above.
