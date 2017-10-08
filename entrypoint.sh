#!/bin/sh

if [[ "$EMPIRE_DB_LOCATION" ]]; then
  ln -s "$EMPIRE_DB_LOCATION" ./data/empire.db
else
  if [[ "$EMPIRE_IP_WHITELIST" ]]; then
    sed -i "s#IP_WHITELIST = ""#IP_WHITELIST = \"$EMPIRE_IP_WHITELIST\"#" \
      setup/setup_database.py
  fi

  if [[ "$EMPIRE_IP_BLACKLIST" ]]; then
    sed -i "s#IP_BLACKLIST = ""#IP_BLACKLIST = \"$EMPIRE_IP_BLACKLIST\"#" \
      setup/setup_database.py
  fi

  if [[ "$EMPIRE_API_USERNAME" ]]; then
    sed -i -E "s#^API_USERNAME.+#API_USERNAME = \"$EMPIRE_API_USERNAME\"#" \
      setup/setup_database.py
  fi

  if [[ "$EMPIRE_API_PASSWORD" ]]; then
    sed -i -E "s#^API_PASSWORD.+#API_PASSWORD = \"$EMPIRE_API_PASSWORD\"#" \
      setup/setup_database.py
  fi

  if [[ "$EMPIRE_API_PERMANENT_TOKEN" ]]; then
    sed -i -E "s#^API_PERMANENT_TOKEN.+#API_PERMANENT_TOKEN = \"$EMPIRE_API_PERMANENT_TOKEN\"#" \
      setup/setup_database.py
  fi

  cd setup \
    && python setup_database.py \
    && cd ..
fi

if [[ "$EMPIRE_CHAIN_LOCATION" && "$EMPIRE_PKEY_LOCATION" ]]; then
    ln -s "$EMPIRE_CHAIN_LOCATION" ./data/empire-chain.pem
    ln -s "$EMPIRE_PKEY_LOCATION" ./data/empire-priv.key
else
  cd setup \
    && ash cert.sh \
    && cd ..
fi

exec ./empire $@
