upstream ambari {
        server 192.168.250.3:8080;
}
upstream repos {
        server 192.168.250.3:33080;
}
upstream redash {
        server 127.0.0.1:9001;
}
server {
       listen         80;
       server_name    esse.io www.esse.io *.esse.io;
       return         301 https://$host$request_uri;
}

server {
    # the port your site will be served on
    listen      443 ssl;
    server_name esse.io www.esse.io;
    access_log /var/log/nginx/esse-io.access.log;
    error_log  /var/log/nginx/esse-io.error.log;
    ssl_certificate         /etc/nginx/ssl/esse-io.crt;
    ssl_certificate_key     /etc/nginx/ssl/esse-io.key;
    charset     utf-8;

    #Max upload size
    client_max_body_size 75M;   # adjust to taste

    # esse.io web
    location / {
        index index.html;  
        root  /var/www/website;
    }
}

server {
    # repos
    server_name    repo.esse.io;
    listen      33080;
    access_log /var/log/nginx/esse-repo.access.log;
    error_log  /var/log/nginx/esse-repo.error.log;
    charset     utf-8;
    location / {
            proxy_pass http://repos;
            proxy_redirect     off;
            proxy_set_header   Host $host;
            proxy_set_header   X-Forwarded-Host $server_name;
            proxy_set_header   X-Forwarded-Proto $scheme;
        }
}



