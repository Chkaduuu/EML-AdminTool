#!/bin/sh
set -e

echo "🔧 Setting up environment variables..."
if [ -f /app/env/.env ]; then
  echo ".env file found."
else
  echo ".env file not found, creating a new one."
  cp /app/env/.env.default /app/env/.env
fi

if [ ! -L /app/.env ]; then
  echo "Creating symlink to .env file..."
  ln -s /app/env/.env /app/.env
else
  echo "Symlink to .env file already exists."
fi

echo "✅ Applying 'prisma db push'..."
DATABASE_URL="$DATABASE_URL" npx prisma db push

echo "📦 Running data and file migrations..."
DATABASE_URL="$DATABASE_URL" node /app/migration-scripts/migrate.js

echo "🚀 Starting application..."
exec npm run serve