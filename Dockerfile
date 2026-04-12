# --- Stage 1: Build the app ---
FROM node:25-alpine AS builder

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the code and build the Nuxt app
COPY . .
RUN npm run build

# --- Stage 2: Run the app ---
FROM node:25-alpine

WORKDIR /app

# Copy only the compiled standalone server from the builder stage
COPY --from=builder /app/.output ./.output

# Set environment variables for Nuxt
ENV HOST=0.0.0.0
ENV PORT=3000
ENV NODE_ENV=production

# Expose the port
EXPOSE 3000

# Start the Nitro server
CMD ["node", ".output/server/index.mjs"]