#!/bin/sh
set -e

echo "DATABASE_URL value: $DATABASE_URL"
echo "🔧 Setting up environment variables..."

rm -f /app/.env /app/env/.env
cp /app/env/.env.default /app/env/.env
echo "DATABASE_URL=\"$DATABASE_URL\"" >> /app/env/.env
ln -sf /app/env/.env /app/.env

echo "✅ Applying 'prisma db push'..."
npx prisma db push

echo "📦 Running data and file migrations..."
node /app/migration-scripts/migrate.js

echo "🚀 Starting application..."
exec npm run serve