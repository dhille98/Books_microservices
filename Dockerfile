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

# Stage 2: Serve the app with a lightweight environment
FROM node:18-alpine AS production

# Install a simple HTTP server to serve static content
RUN npm install -g serve

# Set the working directory
WORKDIR /app

# Copy the build output from the build stage
COPY --from=build /app/build ./build

# Expose port 3000 to the outside world
EXPOSE 3000

# Start the HTTP server to serve the static files
CMD ["serve", "-s", "build", "-l", "3000"]
