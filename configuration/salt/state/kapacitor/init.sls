kapacitor:
  pkg.installed:
    - sources:
      - kapacitor: https://dl.influxdata.com/kapacitor/releases/kapacitor-1.3.1.x86_64.rpm
  service.running:
    - require:
      - pkg: kapacitor
    - watch:
      - file: /etc/kapacitor/kapacitor.conf
      
/etc/kapacitor/kapacitor.conf:
  file.managed:
    - source: salt://kapacitor/config/kapacitor.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja