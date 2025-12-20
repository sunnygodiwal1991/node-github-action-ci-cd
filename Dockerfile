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

ARG APP_DIR=/app
ARG APP_USER=appuser

ENV APP_DIR=${APP_DIR}
ENV APP_USER=${APP_USER}
ENV NODE_ENV=production

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
