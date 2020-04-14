# vision-bareos

[![Build Status](https://travis-ci.org/vision-it/vision-bareos.svg?branch=production)](https://travis-ci.org/vision-it/vision-bareos)

## Usage

Include in the *Puppetfile*:

```
mod vision_bareos:
    :git => 'https://github.com/vision-it/vision-bareos.git,
    :ref => 'production'
```

Include in a role/profile:

```puppet
contain ::vision_bareos
```

Example Vagrant Configuration:

```yaml

---
role: 'bareos_director'
generic::serverdescription: 'Vagrant Bareos Director'

vision_bareos::director::sql_port: 3306
vision_bareos::director::sql_host: "%{facts.ipaddress_eth1}"
vision_bareos::director::admin_mail: root@localhost

vision_bareos::director::sql_backup_password: bareos
vision_bareos::director::sql_db_name: bareos
vision_bareos::director::sql_root_password: bareos
vision_bareos::director::sql_user_name: root
vision_bareos::director::sql_user_password: bareos
vision_bareos::director::director_version: mysql

vision_bareos::storage_hostname: "%{facts.ipaddress_eth1}"

vision_firewall::system_rules:
  '101 allow bareos access':
    dport: '9101'
    proto: 'tcp'
    action: 'accept'
  '102 allow bareos access':
    dport: '9102'
    proto: 'tcp'
    action: 'accept'
  '103 allow bareos access':
    dport: '9103'
    proto: 'tcp'
    action: 'accept'
  '104 allow mysql access':
    dport: '3306'
    proto: 'tcp'
    action: 'accept'

```
