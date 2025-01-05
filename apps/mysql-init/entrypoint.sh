#!/usr/bin/env bash

# This is most commonly set to the user 'root'
export INIT_MYSQL_SUPER_USER=${INIT_MYSQL_SUPER_USER:-root}
export INIT_MYSQL_PORT=${INIT_MYSQL_PORT:-3306}

if [[ -z "${INIT_MYSQL_HOST}"       ||
      -z "${INIT_MYSQL_SUPER_PASS}" ||
      -z "${INIT_MYSQL_USER}"       ||
      -z "${INIT_MYSQL_PASS}"       ||
      -z "${INIT_MYSQL_DBNAME}"
]]; then
    printf "\e[1;32m%-6s\e[m\n" "Invalid configuration - missing a required environment variable"
    [[ -z "${INIT_MYSQL_HOST}" ]]       && printf "\e[1;32m%-6s\e[m\n" "INIT_MYSQL_HOST: unset"
    [[ -z "${INIT_MYSQL_SUPER_PASS}" ]] && printf "\e[1;32m%-6s\e[m\n" "INIT_MYSQL_SUPER_PASS: unset"
    [[ -z "${INIT_MYSQL_USER}" ]]       && printf "\e[1;32m%-6s\e[m\n" "INIT_MYSQL_USER: unset"
    [[ -z "${INIT_MYSQL_PASS}" ]]       && printf "\e[1;32m%-6s\e[m\n" "INIT_MYSQL_PASS: unset"
    [[ -z "${INIT_MYSQL_DBNAME}" ]]     && printf "\e[1;32m%-6s\e[m\n" "INIT_MYSQL_DBNAME: unset"
    exit 1
fi

# These env are for the mysql CLI
export PGHOST="${INIT_MYSQL_HOST}"
export PGUSER="${INIT_MYSQL_SUPER_USER}"
export PGPASSWORD="${INIT_MYSQL_SUPER_PASS}"
export PGPORT="${INIT_MYSQL_PORT}"


until mysqladmin ping -h"${INIT_MYSQL_HOST}" -u"${INIT_MYSQL_SUPER_USER}" --silent; do
    echo 'Waiting for MariaDB to be ready...'
    sleep 1
done

user_exists=$(mysql -h"${INIT_MYSQL_HOST}" -u"${INIT_MYSQL_SUPER_USER}" -s -N -e "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '${INIT_MYSQL_USER}')")

if [[ "${user_exists}" == "0" ]]; then
    printf "\e[1;32m%-6s\e[m\n" "Create User ${INIT_MYSQL_USER} ..."
    mysql -h"${INIT_MYSQL_HOST}" -u"${INIT_MYSQL_SUPER_USER}" -e "CREATE USER '${INIT_MYSQL_USER}'@'%' ${INIT_MYSQL_USER_FLAGS}"
fi

printf "\e[1;32m%-6s\e[m\n" "Update password for user ${INIT_MYSQL_USER} ..."
mysql -h"${INIT_MYSQL_HOST}" -u"${INIT_MYSQL_SUPER_USER}" -e "ALTER USER '${INIT_MYSQL_USER}'@'%' IDENTIFIED BY '${INIT_MYSQL_PASS}'"

database_exists=$(mysql -h"${INIT_MYSQL_HOST}" -u"${INIT_MYSQL_SUPER_USER}" -sN -e "SELECT EXISTS(SELECT 1 FROM information_schema.schemata WHERE schema_name = '${INIT_MYSQL_DBNAME}')")

if [[ "${database_exists}" == "0" ]]; then
    printf "\e[1;32m%-6s\e[m\n" "Create Database ${INIT_MYSQL_DBNAME} ..."
    mysql -h"${INIT_MYSQL_HOST}" -u"${INIT_MYSQL_SUPER_USER}" -e "CREATE DATABASE ${INIT_MYSQL_DBNAME}"

    database_init_file="/initdb/${INIT_MYSQL_DBNAME}.sql"
    if [[ -f "${database_init_file}" ]]; then
        printf "\e[1;32m%-6s\e[m\n" "Initialize Database ..."
        mysql -h"${INIT_MYSQL_HOST}" -u"${INIT_MYSQL_SUPER_USER}" "${INIT_MYSQL_DBNAME}" < "${database_init_file}"
    fi
fi

printf "\e[1;32m%-6s\e[m\n" "Update User Privileges on Database ..."
mysql -h"${INIT_MYSQL_HOST}" -u"${INIT_MYSQL_SUPER_USER}" -e "GRANT ALL PRIVILEGES ON ${INIT_MYSQL_DBNAME}.* TO '${INIT_MYSQL_USER}'@'%'"
mysql -h"${INIT_MYSQL_HOST}" -u"${INIT_MYSQL_SUPER_USER}" -e "FLUSH PRIVILEGES"

echo "MariaDB initialization completed."
