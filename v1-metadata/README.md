## Bulk V1 metadata republishing
Republishing the V1 metadata means taking the V1 metadata stored in the native store, wrapping it in an FT message and putting it on the kafka queue, on the topic on which the V1 metadata publish event enter our system.

### To do a republish: 

1. `fleetctl ssh up-queue-sender-v1-metadata@1.service`
2. `` export SENDER_PORT=`docker ps | grep up-queue-sender | awk '{print $1}' | xargs docker port | cut -d":" -f2` ``
3. `export MESSAGES_PER_SECOND=20`
4. ` docker run coco/up-restutil /up-restutil dump-resources --throttle=$MESSAGES_PER_SECOND http://$HOSTNAME:8080/__nativerw/v1-metadata/ |  docker run -i coco/up-restutil /up-restutil put-resources uuid http://$HOSTNAME:$SENDER_PORT/message`

### Do a cross-cluster republish
Points 1,2,3 are the same as above, done on the destination cluster.
The throttling is approximate with this method, you get `$MESSAGES_PER_SECOND` messages, then a 1 second (configurable) pause.
Point 4 is as follows:

 `./readData.sh $MESSAGES_PER_SECOND 1 sourceCluster user:pw nativerw v1-metadata | docker run -i coco/up-restutil /up-restutil put-resources uuid http://$HOSTNAME:$SENDER_PORT/message`

### See 

* [up-restutil](https://github.com/Financial-Times/up-restutil)
* [nativerw](https://github.com/Financial-Times/nativerw)
* [up-queue-sender](https://github.com/Financial-Times/up-queue-sender)
