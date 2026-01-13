FROM nginx:alpine

# Replace the default index page
COPY index.html /usr/share/nginx/html/index.html

# healthcheck
HEALTHCHECK --interval=10s --timeout=3s --retries=3 CMD wget -qO- http://127.0.0.1/ || exit 1
