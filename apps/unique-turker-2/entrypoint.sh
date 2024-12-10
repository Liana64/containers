#!/usr/bin/env bash

ESCAPED_URL=$(printf '%s\n' "$EXPOSED_URL" | sed 's/[\/&]/\\&/g')
CONFIG_DB="/config/database.db"
APP_DB="/app/instance/database.db"

echo "───────────────────────────────────────"
create_symlink() {
    ln -s "$CONFIG_DB" "$APP_DB"
    if [ $? -eq 0 ]; then
        echo "Symbolic link created: $APP_DB -> $CONFIG_DB"
    else
        echo "Failed to create symbolic link."
        exit 1
    fi
}

# Check if /config/database.db exists
if [ ! -f "$CONFIG_DB" ]; then
    echo "$CONFIG_DB does not exist. Copying from $APP_DB."

    # Check if the source database exists before copying
    if [ -f "$APP_DB" ]; then
        cp "$APP_DB" "$CONFIG_DB"
        if [ $? -eq 0 ]; then
            echo "Copied $APP_DB to $CONFIG_DB."
        else
            echo "Failed to copy $APP_DB to $CONFIG_DB."
            exit 1
        fi
    else
        echo "Source database $APP_DB does not exist. Cannot copy."
        exit 1
    fi

    # Create symbolic link
    create_symlink
else
    echo "$CONFIG_DB already exists."
    echo $(du -h $CONFIG_DB)

    # Check if the application database exists before attempting to delete
    if [ -L "$APP_DB" ] || [ -f "$APP_DB" ]; then
        rm "$APP_DB"
        if [ $? -eq 0 ]; then
            echo "Deleted existing $APP_DB."
        else
            echo "Failed to delete $APP_DB."
            exit 1
        fi
    else
        echo "$APP_DB does not exist. No need to delete."
    fi

    # Create symbolic link
    create_symlink
fi
echo "Setting EXPOSED_URL to $ESCAPED_URL"
echo ""
sed "s@LINK-TO-YOUR-DATABASE\.COM@$ESCAPED_URL@g" /app/website/templates/output.html > /app/website/templates/output.html
echo "───────────────────────────────────────"

exec \
    /usr/local/bin/gunicorn \
    --bind 0.0.0.0:8080 main:app
