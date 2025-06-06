until psql -h "$DB_HOST" -U postgres -d fruitsdb -c '\q'; do
  echo "Waiting for the database to become available..."
  sleep 5
done