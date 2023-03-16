# Base Image 
FROM httpd:2.4


#Copy the index.html file /usr/local/apache2/htdocs/
COPY index.html styles.css /usr/local/apache2/htdocs/

#Expose Apache Port
EXPOSE 80