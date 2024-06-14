#!/bin/bash

ACCOUNT='mail@example.com'
BW_OBJ_ID=''
SESSION_ID=$BW_SESSION
BW_STATUS=''

if [[ -z "$SESSION_ID" ]]; then
   BW_STATUS=$(bw status | jq '.status' -r)
   if [[ "$BW_STATUS" == "unauthenticated" ]]; then
     SESSION_ID=$(bw login --raw $ACCOUNT)
   elif [[ "$BW_STATUS" == "locked" ]]; then
     SESSION_ID=$(bw unlock --raw)
   fi
   # Exporta las variables solo si es necesario.
   if [[ -n "$SESSION_ID" ]]; then
     export BW_SESSION=$SESSION_ID
     export VAULT_PASSWORD=$(bw get password $BW_OBJ_ID)
   fi
fi
