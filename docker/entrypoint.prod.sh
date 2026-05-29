#!/bin/sh
set -e

echo "DATABASE_URL value: $DATABASE_URL"
echo "🔧 Setting up environment variables..."

rm -f /app/.env /app/env/.env
touch /app/env/.env
ln -sf /app/env/.env /app/.env

echo "✅ Applying 'prisma db push'..."
DOTENV_KEY="" DATABASE_URL="$DATABASE_URL" npx prisma db push --schema prisma/schema.prisma

echo "📦 Running data and file migrations..."
DATABASE_URL="$DATABASE_URL" node /app/migration-scripts/migrate.js

echo "🚀 Starting application..."
exec npm run serve
