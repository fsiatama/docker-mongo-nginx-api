#!/bin/bash

set -e
set -u
# set -x	# Uncomment for debugging


# The replica set configuration document
#
# mongo0: Primary, since we initiate the replica set on monog0
# mongo1: Secondary
# mongo2: Arbiter, since we set the 'arbiterOnly' option to true
_config=\
'
{
	"_id": "dbrs",
	"members": [
		{ "_id": 0, "host": "mongodb1" },
		{ "_id": 1, "host": "mongodb2" },
		{ "_id": 2, "host": "mongodb3", arbiterOnly: true },
	]
}
'

sleep 5;



mongosh --quiet \
--host mongodb1 \
<<-EOF
	rs.initiate($_config);
EOF


#echo "Connected to replica set, switching to database '$MONGODB_DB'..."
#mongosh --quiet --eval "use $MONGODB_DB"

sleep 5;

mongosh --quiet \
--host mongodb1 \
<<-EOF
	rs.status();
EOF

echo "Creating user '$MONGODB_USER'..."
mongosh --quiet \
--host mongodb1 \
<<-EOF
  use $MONGODB_DB
  db.createUser({
    user: '$MONGODB_USER',
    pwd:  '$MONGODB_PASSWORD',
    roles: [{
      role: 'readWrite',
      db: '$MONGODB_DB'
    }]
  })
EOF

echo "User '$MONGODB_USER' created successfully."

exec "$@"