# Ceph RPM

Builds Ceph v9.2.0 (Infernalis) RPMs for RHEL 6-based systems.

## Usage

To build, run:

    make

The resulting artifacts will be in the, you guessed it, `artifacts` directory.

## Troubleshooting

To get an interactive shell, run:

    make shell


## Build Requirements

Building requires the following (not including system resources):

- CPU: The more the merrier
- Memory: ~6 GB
- Disk: 20 GB

This is bigger than the default `boot2docker` VM.

If you still want to do this on your Mac, create a new VM with:

```
docker-machine create -d virtualbox --virtualbox-disk-size "30000" --virtualbox-memory "12288" build
eval "$(docker-machine env build)"
```

