FROM alpine

EXPOSE 80

ENV NPM_CONFIG_REFISTRY https://registry.npm.taobao.org

ADD ./deploy/nginx-default.conf /etc/nginx/conf.d/default.conf

COPY . /src

WORKDIR /

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories && \
    apk update && \
    apk add nginx && \
    mkdir /run/nginx && \
    apk add nodejs && \
    apk add npm && \
    cd /src && \
    npm install && \
    npm run build && \
    apk del nodejs && \
    apk del npm && \
    mv /src/build /app && \
    cd / && \
    rm -rf /src;

CMD ["/bin/sh", "-c", "exec nginx -g 'daemon off;';"]
