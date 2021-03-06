logstash_consul_config:
  file.managed:
    - name: /etc/opt/consul.d/elasticsearch_consul.json
    - source: salt://elastic/search/config/elasticsearch_consul.json
    - user: root
    - group: root
    - mode: 644 
    - makedirs: True 
    
elasticsearch_repo:
  pkgrepo.managed:
    - humanname: Logstash YUM Repo
    - baseurl: http://packages.elasticsearch.org/elasticsearch/2.x/centos
    - gpgkey: http://packages.elasticsearch.org/GPG-KEY-elasticsearch

install_elasticsearch:
  pkg.installed:
    - name: elasticsearch

/etc/elasticsearch/elasticsearch.yml:
  file.managed:
    - source: salt://elastic/search/config/elasticsearch.yml
    - user: root
    - group: elasticsearch
    - mode: 750
    - makedirs: True

enable_on_boot_elasticsearch:
  service.enabled:
    - name: elasticsearch

install_license_plugin:
  cmd.run:
    - name: /usr/share/elasticsearch/bin/plugin install license

install_marvel_agent_plugin:
  cmd.run:
    - name: /usr/share/elasticsearch/bin/plugin install marvel-agent

start_elasticsearch:    
  service.running:
    - name: elasticsearch

/tmp/filebeat.template.json:
  file.managed:
    - source: salt://elastic/search/config/filebeat.template.json
    - user: root
    - group: root
    - mode: 600
    - makedirs: True

load_filebeat_template:
  cmd.run:
    - name: curl -XPUT 'http://elasticsearch.service.consul:9200/_template/filebeat?pretty' -d@/tmp/filebeat.template.json  --noproxy elasticsearch.service.consul

/tmp/packetbeat.template.json:
  file.managed:
    - source: salt://elastic/search/config/packetbeat.template.json
    - user: root
    - group: root
    - mode: 600
    - makedirs: True

load_packetbeat_template:
  cmd.run:
    - name: curl -XPUT 'http://elasticsearch.service.consul:9200/_template/packetbeat' -d@/tmp/packetbeat.template.json --noproxy elasticsearch.service.consul

