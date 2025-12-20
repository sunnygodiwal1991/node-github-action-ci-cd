############################
# 1️⃣ Builder stage
############################
FROM node:24.12.0-alpine AS builder

ENV APP_DIR="/app" \
    APP_USER="appuser"

WORKDIR ${APP_DIR}

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
RUN addgroup -S ${APP_USER} && adduser -S ${APP_USER} -G ${APP_USER}

WORKDIR ${APP_DIR}

# Copy only required files from builder
COPY --from=builder ${APP_DIR} ${APP_DIR}

# Fix ownership
RUN chown -R ${APP_USER}:${APP_USER} ${APP_DIR}

# Switch to non-root user
USER ${APP_USER}

EXPOSE 3000

CMD ["node", "index.js"]
