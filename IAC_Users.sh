#!/bin/bash

echo "Creating directories..."
for dir in /public /administrative /sales /secretary; do
  mkdir -p "$dir"
done

echo "Creating user groups..."
for group in GRP_ADM GRP_SALES GRP_SEC; do
  groupadd "$group"
done

echo "Creating users..."
declare -A USERS_GROUPS=(
  [alberto]=GRP_ADM [bruno]=GRP_ADM [caio]=GRP_ADM
  [debora]=GRP_SALES [eduardo]=GRP_SALES [fabio]=GRP_SALES
  [gabriela]=GRP_SEC [henrique]=GRP_SEC [ilma]=GRP_SEC
)

for user in "${!USERS_GROUPS[@]}"; do
  useradd "$user" -m -s /bin/bash -p "$(openssl passwd -crypt Senha123)" -G "${USERS_GROUPS[$user]}"
done

echo "Specifying directory permissions..."
declare -A DIR_PERMISSIONS=(
  [/administrative]=GRP_ADM
  [/sales]=GRP_SALES
  [/secretary]=GRP_SEC
)

for dir in "${!DIR_PERMISSIONS[@]}"; do
  chown root:"${DIR_PERMISSIONS[$dir]}" "$dir"
  chmod 770 "$dir"
done

chmod 777 /public

echo "Script completed successfully."
