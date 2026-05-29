#!/bin/sh
set -e

echo "🔧 Setting up environment variables..."
if [ ! -f /app/env/.env ]; then
  echo ".env file not found, creating a new one."
  cp /app/env/.env.default /app/env/.env
fi

if [ ! -L /app/.env ]; then
  echo "Creating symlink to .env file..."
  ln -s /app/env/.env /app/.env
fi

echo "✅ Applying 'prisma db push'..."
unset DATABASE_URL
export DATABASE_URL="$DATABASE_URL"
rm -f /app/.env /app/env/.env
echo "DATABASE_URL=\"$DATABASE_URL\"" > /app/env/.env
ln -sf /app/env/.env /app/.env

npx prisma db push

echo "📦 Running data and file migrations..."
node /app/migration-scripts/migrate.js

echo "🚀 Starting application..."
exec npm run serve