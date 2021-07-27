FROM alpine/git
WORKDIR /app
RUN git clone https://github.com/trekhleb/covid-19.git app

FROM nginx:latest
WORKDIR /usr/share/nginx/html
COPY --from=0 /app/app ./
