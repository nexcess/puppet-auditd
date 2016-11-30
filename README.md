# auditd

#### Table of Contents

1. [Module Description ](#module-description)
2. [Usage - Configuration options and additional functionality](#usage)
3. [Reference ](#reference)
4. [Limitations](#limitations)
5. [Copyright](#copyright)

## Module Description

This module installs, and configures the auditd service and ruleset.  The currently supported platforms are:

  - RHEL 6/7
  - CentOS 6/7
  - Ubuntu 16.04

By default, the only rules that are applied are the buffer size, and action to take on failure.

## Usage

### Installing and starting

~~~puppet
include ::auditd
~~~

### Specifying Rules

Rules can be specified via four parameters:

1. auditd::base_rules
2. auditd::main_rules
3. auditd::server_rules
4. auditd::finalize_rules

Each location takes a yaml list of rules like so:

~~~yaml
auditd::main_rules:
  - '-a always,exit -F path=/etc/passwd -F perm=wa -F key=accounts'
  - '-a always,exit -F path=/etc/gshadow -F perm=wa -F key=accounts'
~~~

The purpose of each location is as follows:

  - auditd::base_rules is loaded *before* any other rules are processed
  - auditd::main_rules is the primary set of rules to use
  - auditd::server_rules are any rules specific to a given node, that should load *after* the primary rules
  - auditd::finalize_rules are any rules that should load after all other rules. The common use for this is to lock the rules from changing without a reboot.

### Note about `augenrules`

Currently, this module depends on the `auditctl` and `augenrules` binaries to load rules.  While there is a parameter to not use `augenrules`, there currently isn't any alternative that is tried.

### Note about service restarts

Due to some implementations of auditd not being able to be fully restarted, configuration changes for the service its self trigger a service reload.  Because Puppet doesn't provide an easy way to trigger service reloads instead of restarts, this is handled by a case statement and exec.  Currently, the following service providers *should* work when sepecified:

  - redhat
  - systemd

Additional service providers may be added in the future.

## Reference

### Classes

#### Public Classes

* auditd: Main class, includes all other classes.

#### Private Classes

* auditd::install: Handles package installation.
* auditd::config: Handles auditd configuration.
* auditd::rules: Handles auditd rules.
* auditd::service: Handles auditd service and rule loading.

### Parameters

The below parameters are available in the `::auditd` class.  The man page for auditd.conf can be referenced for more detailed description of each option.

#### `auditd::conf`

The fullpath of the main auditd configuration file. Valid options: string containing fullpath. Default value: '/etc/audit/auditd.conf'

#### `auditd::log_file`

The file to use for audit logging. Valid options: string containing fullpath. Default value: '/var/log/audit/audit.log'

#### `auditd::log_format`

The log format describes how the information should be stored on disk. Valid options: string containing log format. Default value: 'RAW'

#### `auditd::log_group`

The group that is applied to the log file's permissions. Valid options: string containing group. Default value: 'root'

#### `auditd::priority_boost`

Tells the audit daemon how much of a priority boost it should take. Valid options: 0 or positive integer. Default value: 4

#### `auditd::flush`

Tells the audit daemon how to handle flushing audit records to disk. Valid options: string containing flush method. Default value: 'INCREMENTAL'

#### `auditd::freq`

Configures how often an explicit flush to disk is issued. Valid options: positive ingeger. Default value: 20

#### `auditd::num_logs`

The number of log files to keep if rotate is given as the max_log_file_action. Valid options: integer between 0 and 99. Default value: 5

#### `auditd::disp_qos`

Controls whether you want blocking/lossless or non-blocking/lossy communication between the audit daemon and the dispatcher. Valid options: string containing communication type. Default value: 'lossy'

#### `auditd::dispatcher`

Application that all events are passed to. Valid options: string containing the path to a program. Default value: '/sbin/audispd'

#### `auditd::name_format`

How node names are inserted into event stream. Valid options: string containing the node name format. Default value: 'NONE'

#### `auditd::admin_name`

Machine name if `auditd::name_format` is set to `user`. Valid options: string containing the machine name. Default value: undef

#### `auditd::max_log_file`

Maximum log file size in MB. Valid options: positive numeric. Default value: 6

#### `auditd::max_log_file_action`

Action to take when `auditd::max_log_file` size is reached. Valid options: string containing action to take. Default value: 'ROTATE'

#### `auditd::space_left`

When the machine reaches `auditd::space_left` diskspace (in MB) remaining, take an action. Valid options: positive numeric. Default value: 75

#### `auditd::space_left_action`

Action to take when the auditd daemon detects low disk space. Valid options: string containing the action to take. Default value: 'SYSLOG'

#### `auditd::action_mail_acct`

Email alert is sent to when `auditd::space_left_action` is set to 'email'. Valid options: string containing email. Default value: 'root'

#### `auditd::admin_space_left`

'Last chance' threshold in MB to take action when machine is low on disk space. Valid options: positive numeric. Default value: 50

#### `auditd::admin_space_left_action`

See `auditd::space_left_action`.

#### `auditd::disk_full_action`

Action to take when partition used for logs is full. Valid options: string containing action. Default value: 'SUSPEND'

#### `auditd::disk_error_action`

Action to take when disk error is occured when writing or rotating logs. Valid options: string containing action. Default value: 'SUSPEND'

#### `auditd::tcp_listen_port`

TCP port to listen for events from other machines on. Valid options: integer between 1 and 65535. Default value: undef

#### `auditd::tcp_listen_queue`

How many pending connections to allow. Valid options: positive integer. Default value: 5

#### `auditd::tcp_max_per_addr`

How many connections per-host are allowed. Valid options: integer between 1 and 1024. Default value: 1

#### `auditd::use_libwrap`

Whether or not to use tcp_wrappers to restrict connections. Valid options: boolean. Default value: true

#### `auditd::tcp_client_ports`

Specifies which incoming ports are allowed for client connections. Valid options: integer between 1 and 65535, or two integers seperated with a '-'. Default value: undef

#### `auditd::tcp_client_max_idle`

Number of seconds a client is allowed to remain idle. Valid options: positive integer. Default value: 0

#### `auditd::enable_krb5`

If enabled, Kerberos 5 will be used for authentication. Valid options: boolean. Default value: false

#### `auditd::krb5_principal`

The principal for the server. Valid options: string containing the principal. Default value: 'auditd'

#### `auditd::krb5_key_file`

The key for the server's principal. Valid options: string containing path to key. Default value: undef

#### `auditd::service_manage`

Whether to manage the service with this module. Valid options: boolean. Default value: true

#### `auditd::service_enable`

Whether to enable the the service on system start. Valid options: boolean. Default value: true

#### `auditd::service_name`

The name of the auditd serivce. Valid options: string containing the service name. Default value: 'auditd'

#### `auditd::service_provider`

The service provider that would normally be used with the service type. Valid options: string containing the service provider. Default value: 'systemd'

Note that this is normally determined automatically by Puppet. Due to how service reloads are managed, we have to manually specify it to trigger a service reload instead of a restart.

#### `auditd::manage_package`

Whether to manage the package with this module. Valid options: boolean. Default value: true

#### `auditd::package_name`

Name of the auditd package. Valid options: string containing package name. Default value: 'audit'

#### `auditd::package_state`

State to use for package type. Valid options: string containing package state. Default value: 'present'

#### `auditd::use_augenrules`

Whether to use `augenrules` format for rule creation (i.g. 'rules.d' format; not monolithic file). Valid options: boolean. Default value: true

Note, that currently if set to `false`, then no rules will be applied or loaded by the module.

#### `auditd::rulesd_dir`

Directory to use for 'rules.d' format. Valid options: string containing path to directory. Default value: '/etc/audit/rules.d'

#### `auditd::purge_rules`

Whether to remove any files Puppet doesn't manage from the directory specified by `auditd::rulesd_dir`. Valid options: boolean. Default value: true

#### `auditd::rules_buffer_size`


#### `auditd::rules_failure_mode`


#### `auditd::base_rules`

Rules to load before any other, after the buffer and failure options. Valid options: list containing strings of rules. Default value: undef

#### `auditd::main_rules`

Rules to be loaded as the 'core' set. Valid options: list containing strings of rules. Default value: undef

#### `auditd::server_rules`

Rules to be loaded after the main rules, to be used for node-specific configuration. Valid options: list containing strings of rules. Default value: undef

#### `auditd::finalize_rules`

Rules to be loaded after any other rule specified. Mainly used if you wanted to lock rules from changing without a reboot. Valid options: list containing strings of rules. Default value: undef

## Limitations

Currently the module is only really useful on systems that have `augenrules` and use the rules.d directory.  While the option is there to disable augenrules, there currently isn't any alternative method implemented.

The module currently does not control `audispd` and it's configuration. This is planned for a future release.

## Copyright

~~~
   Copyright 2016 Nexcess.net

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
~~~

