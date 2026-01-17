FROM nginx:alpine

RUN rm /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY index.html /usr/share/nginx/html/SaasLandingPage/
COPY /styles /usr/share/nginx/html/SaasLandingPage/styles/
COPY /images /usr/share/nginx/html/SaasLandingPage/images/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
