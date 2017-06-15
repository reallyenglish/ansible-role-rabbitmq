# ansible-role-rabbitmq

Manages `rabbitmq` server.

# Requirements

None

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `rabbitmq_user` | user of the service | `rabbitmq` |
| `rabbitmq_group` | group of the service | `rabbitmq` |
| `rabbitmq_log_dir` | path to log directory | `/var/log/rabbitmq` |
| `rabbitmq_db_dir` | path to DB directory | `{{ __rabbitmq_db_dir }}` |
| `rabbitmq_service` | service name | `{{ __rabbitmq_service }}` |
| `rabbitmq_conf_dir` | path to config directory | `{{ __rabbitmq_conf_dir }}` |
| `rabbitmq_conf` | path to `rabbitmq.config` | `{{ rabbitmq_conf_dir }}/rabbitmq.config` |
| `rabbitmq_flags` | dict of settings of startup script. see below | `{}` |
| `rabbitmq_flags_default` | dict of default settings of startup script | `{{ __rabbitmq_flags_default }}` |
| `rabbitmq_extra_startup_command` | list of extra commands, such as `ulimit` in startup script. Implemented only in Ubuntu | `{{ __rabbitmq_extra_startup_command }}` |
| `rabbitmq_env_conf` | path to `rabbitmq-env.conf` | `{{ rabbitmq_conf_dir }}/rabbitmq-env.conf` |
| `rabbitmq_env` | dict of environment variables in `rabbitmq-env.conf` | `{}` |
| `rabbitmq_cookie_file` | path to `.erlang.cookie` | `{{ rabbitmq_db_dir }}/.erlang.cookie` |
| `rabbitmq_cookie` | content of `.erlang.cookie` | `""` |
| `rabbitmq_config` | raw contents of `rabbitmq.config` | "" |
| `rabbitmq_plugins_local_src_dir` | path to _local_ directory in which additional plug-in files are kept. the directory is copied to `plugins_dir` on _remote_. the plug-ins in the directory can be installed by `rabbitmq_plugins` | `""` |
| `rabbitmq_plugins` | list of dict of plug-ins. see below | `[]` |
| `rabbitmq_users` | list of users in `rabbitmq` | `[]` |
| `rabbitmq_vhosts` | list of `vhosts` in `rabbitmq` | `[]` |

## `rabbitmq_flags`

This is a dict of key-value pair in `/etc/default/rabbitmq`, or
`/etc/rc.conf.d/rabbitmq`. The following example:

```yaml
rabbitmq_flags:
  FOO: bar
```
will generate:

```sh
FOO="bar"
```

## `rabbitmq_plugins`

This is a list of dict of plug-ins. Each element consists of a dict.

| Key | Value |
|-----|-------|
| `name` | name of plug-in |
| `state` | either `enabled` or `disabled` |

An example:

```yaml
rabbitmq_plugins:
  - name: rabbitmq_management
    state: enabled
```

This will enable `rabbitmq_management` plug-in. Note that plug-in files must be
kept in `plugin_dir`. To install non-default plug-ins to `plugins_dir`, use
`rabbitmq_plugins_local_src_dir`. Files under the directory will be copied and
can be installed by `rabbitmq_plugins`.

## Debian

| Variable | Default |
|----------|---------|
| `__rabbitmq_service` | `rabbitmq-server` |
| `__rabbitmq_db_dir` | `/var/lib/rabbitmq` |
| `__rabbitmq_conf_dir` | `/etc/rabbitmq` |
| `__rabbitmq_flags_default` | `{}` |
| `__rabbitmq_extra_startup_command` | `[]` |

## FreeBSD

| Variable | Default |
|----------|---------|
| `__rabbitmq_conf_dir` | `/usr/local/etc/rabbitmq` |
| `__rabbitmq_service` | `rabbitmq` |
| `__rabbitmq_db_dir` | `/var/db/rabbitmq` |
| `__rabbitmq_flags_default` | `{"rabbitmq_user"=>"{{ rabbitmq_user }}", "RABBITMQ_LOG_BASE"=>"{{ rabbitmq_log_dir }}"}` |


# Dependencies

None

# Example Playbook

```yaml
- hosts: localhost
  roles:
    - ansible-role-rabbitmq
  vars:
    rabbitmq_cookie: "ABCDEFGHIJK"
    rabbitmq_env:
      foo: 1
      BAR: 2
      USE_LONGNAME: 1
    rabbitmq_plugins:
      - name: rabbitmq_management
        state: enabled
    rabbitmq_flags:
      FOO: bar
    rabbitmq_config: |
      [
        {rabbit,
         [
          {tcp_listeners, [5672] },
          {log_levels, [{connection, info}]},
          {vm_memory_high_watermark, 0.4},
          {vm_memory_high_watermark_paging_ratio, 0.5},
          {disk_free_limit, "50MB"}
         ]
        }
      ].
```

# License

```
Copyright (c) 2017 Tomoyuki Sakurai <tomoyukis@reallyenglish.com>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```

# Author Information

Tomoyuki Sakurai <tomoyukis@reallyenglish.com>

This README was created by [qansible](https://github.com/trombik/qansible)
