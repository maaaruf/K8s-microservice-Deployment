# Use a lightweight web server image
FROM nginx:alpine

# Copy the HTML and CSS files to the default Nginx public directory
COPY . /usr/share/nginx/html


# Expose port 80
EXPOSE 80

# Command to start Nginx
CMD ["nginx", "-g", "daemon off;"]
