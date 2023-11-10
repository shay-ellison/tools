#!/bin/sh
COMMAND="$1"

# Refile, which is basically hard reset of a single file
if [[ "$COMMAND" == "refile" ]]; then
  FILENAME="$2"
  if [[ -f "$FILENAME" ]]; then
    git checkout @ -- $FILENAME
    echo "Hard reset: ${FILENAME}"
  fi

# Create ignore file if none, add to ignore file
elif [[ "$COMMAND" == "ignore" ]]; then
  THING="$2"
  if [[ -e .gitignore ]]; then
    echo "Already exists: .gitignore"
  else
    touch .gitignore
    echo "Created: .gitignore"
  fi

  if [[ "$(grep -x $THING .gitignore)" == "" ]]; then
    echo $THING >> .gitignore
    echo "Ignored: ${THING}"
  else
    echo "Already ignored: ${THING}"
  fi

# Default, display some options, just show the status if repo
elif [[ "$COMMAND" == "" ]]; then
  echo "Options: -h for help"
  echo
  git status
  git branch

# Help
elif [[ "$COMMAND" == "-h" ]]; then
  echo "Commands: refile FILE | ignore THING | keygen EMAIL | pubkey"

# Generate a key using ssh-keygen
elif [[ "$COMMAND" == "keygen" ]]; then
  EMAIL="$2"
  if [[ "$EMAIL" == "" ]]; then
    echo "Need: email address"
  else
    ssh-keygen -t ed25519 -C "${EMAIL}"
  fi

# Print out your public keys in .ssh folder
elif [[ "$COMMAND" == "pubkey" ]]; then
  cat ~/.ssh/*.pub
fi

