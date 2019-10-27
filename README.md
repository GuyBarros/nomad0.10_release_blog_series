# Nomad 0.10.0 - just the new bits

This repository contains examples of the following new features released in Nomad 0.10.0:

* Host mount volumes
* Advanced Networking
* Consul Connect sidecar injection
  * Consul Connect Gateways
* Spreading

To visualise the new features for Nomad 0.10.0 we will implement the following jobs:

* **MongoDB**(Docker,service job) database
* **Python**(raw_exec,batch job) job to add data to the mongo db

### Pre Requisites

* Nomad 0.10.0 cluster
* Consul cluster with connect enabled.
* CNI [plugins](https://github.com/containernetworking/plugins/releases/tag/v0.8.2) and installed in `/opt/cni/bin`
* Docker (Nomad launches a Consul Connect Envoy sidecar using the official Envoy [docker container](https://hub.docker.com/u/envoyproxy))

#### included enviroment

in the [terraform](./terraform/) directory there is code to spin up a Azure enviroment with Nomad preconfigured. this takes about 15 minutes to get up and running correctly, after that run the consul.nomad file and then the other nomad files.


---

## Host volumes

Host volumes are Nomad's current answer to mounted volumes, the idea behind them is you give a directory an identifier, then this identifier can be called from the jobspec and used to host the service's data. this way, as long as the identifier is the same and the data can be reached from different hosts, stateful applications will continue to have access to their data regardless of where they are allocated.

To set up mount volumes, we must first create the host volume identifier in the [Nomad node client](https://www.nomadproject.io/docs/configuration/client.html#host_volume-stanza) stanza config.

This can be achieved in two ways:

* Directly in the main **config.hcl** document located in `/etc/nomad.d/`
* Seperate document **some_document.hcl** in the same directory

```bash
host_volume "mongodb_mount" {
  path      = "/opt/mongodb/data/"
  read_only = false
}
```

and then we call this identifier from the jobspec:

```bash
group "db" {
 count = 1
 volume "mongodb_vol" {
 type = "host"
 source = "mongodb_mount"
 }

 task "mongodb" {
    driver = "docker"
    env {
      "MONGO_INITDB_ROOT_USERNAME" = "root"
      "MONGO_INITDB_ROOT_PASSWORD" = "example"
    }
     volume_mount {
      volume      = "mongodb_vol"
      destination = "/data/db"
    }
```

The directory you are using must exist beforehand and be accesible by the user/group Nomad is running under.

[Reference: Stateful Workloads with Nomad Host Volumes](https://www.nomadproject.io/guides/stateful-workloads/host-volumes.html)

### Limitations

* The consul binary must be in Nomad's $PATH to run the envoy proxy sidecars
* Consul Connect Native is not supported yet.
* Consul Connect HTTP and gRPC checks are not yet supported.
* Consul ACLs are not yet supported.
* Only the Docker, exec, and raw exec drivers support network namespaces and Connect.
* Variable interpolation for group services and checks are not yet supported.

---

## Advanced Networking

In previous versions of Nomad when you wanted to specify the networking necessities of your service, all you needed to put in was the port and the bandwidth requirements(in MBits).
Nomad 0.10.0 gives you a new configuration variable called **mode**. [from the documentation](https://www.nomadproject.io/docs/job-specification/network.html#network-parameters):

> **mode (string: "host")** - Mode of the network. The following modes are available:
>
> **“none”** - Task group will have an isolated network without any network interfaces.
> **“bridge”** - Task group will have an isolated network namespace with an interface that is bridged with the host. Note that bridge networking is only currently supported for the >docker, exec, raw_exec, and java task drivers.
> **“host”** - Each task will join the host network namespace and a shared network namespace is not created. This matches the current behavior in Nomad 0.9.

In our MongoDB job, we want all traffic to go through Consul Connect. To achieve this need to configure the job to use **bridged** networking. We will need to remove the current network stanza fromt he **task** and move it to thea and move the ne.work stanza to the **group** stanza.

```bash
group "db" {
    count = 1
    volume "mongodb_vol" {
      type = "host"
      source = "mongodb_mount"
    }
    network {
      mode = "bridge"
    }

    ...
```

Consul is HashiCorp's Service Mesh solution, as is known for its ease of use and cross datacenter capabilities. it allows services from one DC to talk to another DC seemlessly. you can read more about Consul [here](https://www.consul.io/mesh.html).

Nomad jobs can have an automatic consul connect proxy injected into it, this allows any job to become mesh enabled. in the service stanzas we add the consul sidecar proxy config:

##### Mongodb.nomad:

```bash
 service {
      name = "mongodb"
      tags = ["mongodb"]
      port = "27017"
      connect {
        sidecar_service {}
      }
    }
```

in our python job, we need to add the mongodb service as an upstream:

##### mongodb_data_importer.nomad:

```bash


```



---

## Spreading



