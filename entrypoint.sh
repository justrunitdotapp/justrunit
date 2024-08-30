#!/bin/bash

set -e

# Run migrations
echo "Running migrations..."
mix ecto.migrate

# Populate the database
echo "Populating PostgreSQL..."
mix run priv/repo/seeds.exs

mix phx.server