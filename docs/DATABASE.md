# Klimt Database Setup 🎨

## 🐘 Development PostgreSQL

```zsh
# Start database
docker compose up -d

# Stop database
docker compose down
```

## 🧪 Connection Verification

```zsh
# Verify database connection
bundle exec rspec spec/db_connection_spec.rb
```

## 📋 Connection Details for Adminer

| Parameter | Value |
|-----------|-------|
| System    | PostgreSQL |
| Server    | db |
| Username  | DB_USER |
| Password  | DB_PASSWORD |
| Database  | DB_NAME |

## 📐 Database Schema

_Coming soon. Schema details will be added as the project progresses._