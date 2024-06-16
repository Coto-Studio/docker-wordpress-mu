---
services:
  mariadb:
    image: docker.io/bitnami/mariadb:latest
    container_name: {{ op://$APP_ENV/${APP_ACCOUNT}-db/Container Name }}
    volumes:
      - db:/bitnami/mariadb
    environment:
      - MARIADB_ROOT_PASSWORD={{ op://$APP_ENV/root-db/password }}
      - MARIADB_PASSWORD={{ op://$APP_ENV/${APP_ACCOUNT}-db/password }}
      - MARIADB_USER={{ op://$APP_ENV/${APP_ACCOUNT}-db/username }}
      - MARIADB_DATABASE={{ op://$APP_ENV/${APP_ACCOUNT}-db/database }}
    networks:
      - {{ op://$APP_ENV/${APP_ACCOUNT}-db/Container Name }}
  wordpress:
    image: docker.io/bitnami/wordpress
    container_name: {{ op://$APP_ENV/${APP_ACCOUNT}-wp/Container Name }}
    volumes:
      - wordpress:/bitnami/wordpress
    depends_on:
      - mariadb
    networks:
      - {{ op://$APP_ENV/${APP_ACCOUNT}-db/Container Name }}
      - traefik
    environment:
      - WORDPRESS_DATABASE_HOST=mariadb
      - WORDPRESS_DATABASE_PORT_NUMBER=3306
      - WORDPRESS_DATABASE_USER={{ op://$APP_ENV/${APP_ACCOUNT}-db/username }}
      - WORDPRESS_DATABASE_NAME={{ op://$APP_ENV/${APP_ACCOUNT}-db/database }}
      - WORDPRESS_DATABASE_PASSWORD={{ op://$APP_ENV/${APP_ACCOUNT}-db/password }}
      - WORDPRESS_USERNAME={{ op://$APP_ENV/${APP_ACCOUNT}-wp/username }}
      - WORDPRESS_PASSWORD={{ op://$APP_ENV/${APP_ACCOUNT}-wp/password }}
      - WORDPRESS_BLOG_NAME={{ op://$APP_ENV/${APP_ACCOUNT}-wp/Blog Name }}
      - WORDPRESS_EMAIL={{ op://$APP_ENV/${APP_ACCOUNT}-wp/email }}
      - WORDPRESS_FIRST_NAME={{ op://$APP_ENV/${APP_ACCOUNT}-wp/First Name }}
      - WORDPRESS_LAST_NAME={{ op://$APP_ENV/${APP_ACCOUNT}-wp/Last Name }}
      - WORDPRESS_ENABLE_MULTISITE=yes
      - WORDPRESS_MULTISITE_NETWORK_TYPE=subdomain
      - WORDPRESS_MULTISITE_HOST={{ op://$APP_ENV/${APP_ACCOUNT}-wp/website }}
      - WORDPRESS_MULTISITE_FILEUPLOAD_MAXK=128000
    labels:
      - "traefik.http.routers.{{ op://$APP_ENV/${APP_ACCOUNT}-wp/Container Name }}.tls=true"
      - "traefik.http.routers.{{ op://$APP_ENV/${APP_ACCOUNT}-wp/Container Name }}.rule=Host(`{{ op://$APP_ENV/${APP_ACCOUNT}-wp/website }}`)"
volumes:
  wordpress:
  db:

networks:
  {{ op://$APP_ENV/${APP_ACCOUNT}-db/Container Name }}: