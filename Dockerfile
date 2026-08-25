FROM node:24-bookworm-slim

WORKDIR /app

# Install production dependencies first so Docker can reuse this layer when only
# application code changes.
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

COPY . .

# SQLite files are written under /app/data.  The node user keeps the runtime
# container unprivileged while retaining write access to the mounted volume.
RUN mkdir -p /app/data && chown -R node:node /app
USER node

ENV NODE_ENV=production

CMD ["npm", "start"]
