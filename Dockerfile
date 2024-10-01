# Stage 1: Build the React application
FROM node:18 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Serve the app with Nginx and a non-root user
FROM nginx:alpine3.18 AS production

# Add a non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Create a directory for the app and set it as the working directory
WORKDIR /app

# Change the ownership of the Nginx html directory to the non-root user
RUN chown -R appuser:appgroup /usr/share/nginx/html

# Switch to the new non-root user
USER appuser

# Copy the build output from the build stage to Nginx's HTML folder
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]

