FROM alpine

EXPOSE 80

ENV NPM_CONFIG_REFISTRY https://registry.npm.taobao.org

COPY . /src

WORKDIR /

# Install packages
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories && \
    apk update && \
    apk add nginx && \
    apk add nodejs && \
    apk add npm && \
    # Build app
    cd /src && \
    npm install && \
    npm run build && \
    # Remove build tools and source code, place resource files to the distination
    apk del nodejs && \
    apk del npm && \
    mv /src/build /app && \
    cd / && \
    rm -rf /src && \
    # Prepare for nginx
    mkdir /run/nginx && \
    echo "daemon off;" >> /etc/nginx/nginx.conf;

ADD ./deploy/nginx-default.conf /etc/nginx/conf.d/default.conf

CMD ["/bin/sh", "-c", "exec nginx;"]
