server {
    # SSL configuration
    listen 443 ssl;
    server_name api.linguakit.com;
    
    ssl_certificate /etc/letsencrypt/live/api.linguakit.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/api.linguakit.com/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    
    
    location / {
            proxy_pass http://localhost:3000;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_cache_bypass $http_upgrade;
         }
}
