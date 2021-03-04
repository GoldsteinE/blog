FROM balthek/zola:0.13.0 AS build
COPY . /blog
WORKDIR /blog
RUN ["zola", "build"]

FROM nginx:1.19.7
COPY --from=build /blog/public /blog
COPY nginx.conf /etc/nginx/nginx.conf
