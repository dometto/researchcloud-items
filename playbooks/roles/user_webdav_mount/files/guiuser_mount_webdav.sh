#!/bin/bash
ZENITY=$(/usr/bin/which zenity)
EXPECT=$(/usr/bin/which expect)
MOUNT=$(/usr/bin/which mount)
GREP=$(/usr/bin/which grep)
WHOAMI=$(/usr/bin/which whoami)
MKDIR=$(/usr/bin/which mkdir)

USER=$(${WHOAMI})
MOUNT_DIR=$1
DRIVE_URL=$2
DRIVE_NAME="(${3-WebDAV})"

already_mounted() {
  ${MOUNT} | ${GREP} -q "$MOUNT_DIR"
}

if [[ -z $MOUNT_DIR || -z $DRIVE_URL ]]; then
  echo "Usage: guiser_mount_webdav.sh MOUNT_DIR DRIVE_URL [DRIVE_NAME]"
  exit 1
fi

if [[ -z $DISPLAY || -z $DRIVE_URL ]]; then
  echo "No display found. This script uses the GUI to prompt for WebDAV credentials. To mount $DRIVE_URL from the command line, try simply using 'mount.davfs $DRIVE_URL $MOUNT_DIR '."
  exit 1
fi

if ! ${MKDIR} -p "$MOUNT_DIR"; then
  echo "Cannot create $MOUNT_DIR"
  exit 1
fi

if already_mounted; then
  echo "Already mounted"
  exit 0
fi

CREDENTIALS=$(${ZENITY} --forms --title="Login to network share" --text="Please enter your credentials to login to $DRIVE_URL $DRIVE_NAME" --add-entry "Username" --add-password="Password" --separator "FIELDSEP" )

if [[ $CREDENTIALS =~ (.*)FIELDSEP(.*) ]]; then 
    USERNAME=${BASH_REMATCH[1]}
    PASSWORD=${BASH_REMATCH[2]}
fi

if [[ -z $USERNAME || -z $PASSWORD ]]; then
  echo "Failed to obtain username or password"
  exit 1
fi

${EXPECT} -f - <<-EOF
  set timeout 30
  log_user 1
  spawn -ignore HUP /sbin/mount.davfs $DRIVE_URL $MOUNT_DIR -o ro,uid=$USER
  expect "sername:"
  send -- "$USERNAME\r"
  expect "assword:"
  send -- "$PASSWORD\r"
  wait
  expect eof
EOF

if ! already_mounted; then
  ${ZENITY} --info --text="Failed to connect to $DRIVE_NAME $DRIVE_URL!"
  exit 1
fi

echo "Done"
