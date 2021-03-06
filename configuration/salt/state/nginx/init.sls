nginx:
  pkg:
    - installed
  service.running:
    - watch:
      - pkg: nginx
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/sites-available/default

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://nginx/config/nginx.conf
    - user: root
    - group: root
    - mode: 640
    
/etc/nginx/sites-available/default:
  file.managed:
    - source: salt://nginx/config/default.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 640
    - makedirs: True 
    
/etc/nginx/sites-enabled/default:
  file.symlink:
    - target: /etc/nginx/sites-available/default
    - require:
      - file: /etc/nginx/sites-available/default
    - makedirs: True 
      
/usr/share/nginx/html/index.html:
  file.managed:
    - source: salt://nginx/config/index.html.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644