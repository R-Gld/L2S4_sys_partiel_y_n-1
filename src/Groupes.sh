#! /bin/dash

find_groups() {
  echo ""
}


if [ ! -f '/etc/passwd' ]; then
  echo "/etc/passwd is not a regular file." 1>&2
  exit 1
fi

if [ ! -f '/etc/group' ]; then
  echo "/etc/group is not a regular file." 1>&2
  exit 1
fi

if [ $# != 1 ]; then
  echo "Usage: $0 USERNAME" 1>&2
  exit 1
fi
USERNAME=$1

echo -n "$USERNAME :"
USERNAME_COUNT=$(grep -c "^$USERNAME:" /etc/passwd)
if [ "$USERNAME_COUNT" -eq 0 ]; then
  echo "Username $USERNAME does not exists." 1>&2
  exit 1
fi


awk  < '/etc/group'