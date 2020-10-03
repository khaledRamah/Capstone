FROM nginx:latest

WORKDIR /app

COPY ./project/ /app/

COPY nginx/default.conf /etc/nginx/conf.d/default.conf

RUN nginx

EXPOSE 80
