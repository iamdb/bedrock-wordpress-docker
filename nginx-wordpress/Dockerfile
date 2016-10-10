FROM nginx:1.10-alpine

RUN addgroup -g 82 www-data && adduser -S -u 82 -G www-data www-data

RUN apk --update --no-cache add git 

# Install custom nginx config
RUN mv /etc/nginx /etc/nginx-og && \
    git clone https://github.com/iamdb/wordpress-nginx.git /etc/nginx && \
    sed -i "s|user www www;|user www-data www-data;|g" /etc/nginx/nginx.conf && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    mkdir -p /etc/nginx/logs/ /etc/nginx/sites-enabled/ && touch /etc/nginx/logs/error.log
COPY default.conf /etc/nginx/sites-available/default.conf
RUN ln -sf /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

# init script and CMD
COPY init.sh /opt/
RUN chmod +x /opt/init.sh
CMD /opt/init.sh && exec nginx -g "daemon off;"