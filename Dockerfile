FROM goldsteinq/pepel:latest AS build
COPY . /blog
WORKDIR /blog
RUN ["zola", "build"]

FROM node:15-alpine3.13 AS beautify
RUN npm install -g js-beautify
COPY --from=build /blog/public /blog
RUN find /blog -name '*.html' -type f -exec \
	js-beautify -f '{}' -r --type html --no-preserve-newlines --wrap-line-length 100 \;

FROM nginx:1.19.7
COPY --from=beautify /blog /blog
COPY nginx.conf /etc/nginx/nginx.conf
