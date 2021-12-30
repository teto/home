
curl --header 'Access-Token: $BULLET_API_TOKEN' \
     --header 'Content-Type: application/json' \
     --data-binary '{"body":"Space Elevator, Mars Hyperloop, Space Model S (Model Space?)","title":"Space Travel Ideas","type":"note"}' \
     --request POST \
     https://api.pushbullet.com/v2/pushes
