############################
# 1️⃣ Builder stage
############################
FROM node:24.12.0-alpine AS builder

ENV APP_DIR="/app"

WORKDIR ${APP_DIR}

# Copy dependency files first
COPY package*.json ./

# Install production deps
RUN npm ci --production

# Copy source code
COPY . .

############################
# 2️⃣ Runtime stage
############################
FROM node:24.12.0-alpine

ENV APP_DIR="/app" \
    APP_USER="appuser"

# Create non-root user
RUN addgroup -S ${APP_USER} \
 && adduser -S ${APP_USER} -G ${APP_USER}

WORKDIR ${APP_DIR}

# Copy app from builder
COPY --from=builder ${APP_DIR} ${APP_DIR}

# Fix permissions
RUN chown -R ${APP_USER}:${APP_USER} ${APP_DIR}

# Switch user
USER ${APP_USER}

EXPOSE 3000

CMD ["node", "index.js"]
