# Hook test
# Multi-stage Dockerfile example for testing docker-langserver and hadolint
# This file demonstrates best practices and common patterns

# Build stage
FROM node:20-alpine AS builder

LABEL maintainer="claude@anthropic.com" \
      version="1.0.0" \
      description="Sample multi-stage build"

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies with specific version
RUN npm ci --only=production && \
    npm cache clean --force

# Copy application code
COPY . .

# Build application
RUN npm run build

# Production stage
FROM node:20-alpine AS production

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

WORKDIR /app

# Copy built artifacts from builder
COPY --from=builder --chown=nodejs:nodejs /app/dist ./dist
COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=nodejs:nodejs /app/package*.json ./

# Switch to non-root user
USER nodejs

# Expose application port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node healthcheck.js || exit 1

# Use JSON notation for ENTRYPOINT
ENTRYPOINT ["node"]

# Default command
CMD ["dist/index.js"]
