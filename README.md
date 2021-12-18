# james.hu

## Deployment

Using the Sublime Text SFTP plugin, it should sync all files in `nomad/` to `/srv/james-hu/nomad` on [Subspace](axsuul/subspace). Then on the server, run each Nomad task.

```shell
nomad run /srv/james-hu/nomad/jobs/web.hcl
```
