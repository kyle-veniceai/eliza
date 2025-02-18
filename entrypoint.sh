#!/bin/sh
set -e

# Process the character file
envsubst < ./characters/user.character.json > ./characters/user.character.json.tmp
mv ./characters/user.character.json.tmp ./characters/user.character.json

# Start both services
pnpm start --characters=./characters/user.character.json &
CLIENT_PID=$!
pnpm start:client &
SERVER_PID=$!

# Handle shutdown
# trap 'kill $CLIENT_PID $SERVER_PID' SIGTERM

# Wait for either process to exit
# wait $CLIENT_PID $SERVER_PID
