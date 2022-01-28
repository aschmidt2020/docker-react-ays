#******BUILD
#base image
FROM node:latest as build

#set workdir
WORKDIR /app

#add /app/node_modules/.bin to $PATH
# ENV PATH /app/node_modules/.bin:$PATH

#install app dependencies
COPY package.json ./
COPY package-lock.json ./
RUN npm ci
RUN npm install react-scripts@5.0.0 -g

#copy app
COPY ./ ./

#build prod code
RUN npm run build

#*****PRODUCTION
#copies from build env
FROM nginx:stable-alpine as prod
COPY --from=build /app/build /usr/shar/nginx/html

#allows react router to be used with nginx
# COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD [ "nginx", "-g", "daemon off;" ]