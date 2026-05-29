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

if [ ! -z "$DATABASE_URL" ]; then
  echo "Injecting DATABASE_URL..."
  sed -i "s|DATABASE_URL=.*|DATABASE_URL=$DATABASE_URL|" /app/env/.env
fi

echo "✅ Database available. Applying 'prisma db push'..."
npx dotenv -e /app/.env -- npx prisma db push

echo "📦 Running data and file migrations..."
npx dotenv -e /app/.env -- node /app/migration-scripts/migrate.js

echo "🚀 Starting application..."
exec npm run serve