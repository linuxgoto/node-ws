FROM node:20-alpine3.20

WORKDIR /tmp

COPY index.js index.html package.json ./

EXPOSE 7860

RUN apk update && apk add --no-cache bash openssl curl wget libc6-compat &&\
    wget -O /usr/local/bin/cloudflared \
      https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 &&\
    chmod +x /usr/local/bin/cloudflared index.js &&\
    npm install

CMD if [ -n "$ARGO_TOKEN" ]; then \
      cloudflared tunnel --no-autoupdate --protocol http2 run --token "$ARGO_TOKEN" & \
    fi; \
    node index.js
