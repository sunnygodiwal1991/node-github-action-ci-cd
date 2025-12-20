############################
# 1️⃣ Builder stage
############################
FROM node:24.12.0-alpine AS builder

WORKDIR /app

# Copy only dependency files first (better cache)
COPY package*.json ./

# Install only production deps
RUN npm ci --production

# Copy app source
COPY . .

############################
# 2️⃣ Runtime stage
############################
FROM node:24.12.0-alpine

# Create non-root user (SECURITY 🔐)
RUN addgroup -S nodeapp && adduser -S nodeapp -G nodeapp

WORKDIR /app

# Copy only required files from builder
COPY --from=builder /app /app

# Fix ownership
RUN chown -R nodeapp:nodeapp /app

# Switch to non-root user
USER nodeapp

EXPOSE 3000

CMD ["node", "index.js"]