#!/bin/bash

# =======================================================
#                   COPYRIGHT INFORMATION
# =======================================================
#
# Author: Ade Febrian
# Github: https://github.com/Adefebrian
# Youtube: https://www.youtube.com/AdeFebrian
# Tiktok: https://www.tiktok.com/@airdropsultan.id
# Telegram Channel: https://www.t.me/@airdropsultanindonesia
# Telegram Group: https://www.t.me/@airdropsultanid
#
# All rights reserved. No part of this document may be reproduced, distributed, or transmitted in any form or by any means,
# including photocopying, recording, or other electronic or mechanical methods, without the prior written permission of the author,
# except in the case of brief quotations embodied in critical reviews and certain other noncommercial uses permitted by copyright law.
#
# For permission requests, please contact the author via the provided channels.
#
# =======================================================

read -p "Masukkan nama validator: " validatorname
read -p "Masukkan IP VPS: " myip

docker run -d \
 --name creditcoin-validator \
 -p 30333:30333 \
 -v airdropsultan:/creditcoin-node/data  \
 gluwa/creditcoin:2.222.2-testnet \
 --name "$validatorname" \
 --telemetry-url "wss://telemetry.creditcoin.network/submit/ 0" \
 --public-addr "/dns4/$myip/tcp/30333" \
 --chain test \
 --bootnodes "/dns4/testnet-bootnode.creditcoin.network/tcp/30333/p2p/12D3KooWG3eEuYxo37LvU1g6SSESu4i9TQ8FrZmJcjvdys7eA3cH" "/dns4/testnet-bootnode2.creditcoin.network/tcp/30333/p2p/12D3KooWLq7wCMQS3qVMCNJ2Zm6rYuYh74cM99i9Tm8PMdqJPDzb" "/dns4/testnet-bootnode3.creditcoin.network/tcp/30333/p2p/12D3KooWAKUrvmchoLomoouoN1sKfF9kq8dYtCVFvtPuvqp7wFBS" \
 --validator \
 --base-path /creditcoin-node/data \
 --port 30333 \
 >/dev/null 2>&1 &
 
output1=$(docker exec -it creditcoin-validator creditcoin-cli new | grep -oP '(?<=Seed phrase: ).*'); echo $output1; address1=$(docker exec -i creditcoin-validator creditcoin-cli show-address <<< $output1 | awk '/Account address:/ {print $NF}'); echo $address1; output2=$(docker exec -it creditcoin-validator creditcoin-cli new | grep -oP '(?<=Seed phrase: ).*'); echo $output2; address2=$(docker exec -i creditcoin-validator creditcoin-cli show-address <<< $output2 | awk '/Account address:/ {print $NF}'); echo $address2;

read -p "Silakan untuk mentransfer ke dua alamat di atas dengan CTC minimal 1500 token. Jika sudah ditransfer, ketik Y: " transfer_confirmation

if [[ $transfer_confirmation == "Y" ]]; then
 expect -c "
spawn docker exec -i creditcoin-validator creditcoin-cli wizard -a 1000
expect \"Input pertama:\"
send \"$output1\n\"
expect \"Input kedua:\"
send \"$output2\n\"
interact
"
fi

docker exec -it creditcoin-validator creditcoin-cli status -a $address1
