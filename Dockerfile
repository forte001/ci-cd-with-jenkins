# Base Image
FROM alpine:latest

# Install Apache
RUN apk add apache2

# Install git
RUN apk add git

# Clone repo
RUN git clone https://github.com/forte001/ci-cd-with-jenkins.git

# Copy the index.html and styles.css files
RUN cp /ci-cd-with-jenkins/* /var/www/localhost/htdocs

# Expose Apache Port
EXPOSE 80

CMD ["sh"]