#!/bin/bash
set -e

echo "Starting entrypoint script"
cd /app
echo "Changed to /app directory"

# Process the character file
echo "Processing character file..."
envsubst < ./characters/user.character.json > ./characters/user.character.json.tmp
mv ./characters/user.character.json.tmp ./characters/user.character.json
echo "File move completed"

# Start both services
echo "Starting services..."
pnpm start --characters=./characters/user.character.json &
CLIENT_PID=$!
echo "Client started with PID: $CLIENT_PID"
pnpm start:client &
SERVER_PID=$!
echo "Server started with PID: $SERVER_PID"

# Handle shutdown
trap 'kill $CLIENT_PID $SERVER_PID' SIGTERM

# Wait for ALL background processes
echo "Waiting for processes..."
wait

# Keep container running
tail -f /dev/null
