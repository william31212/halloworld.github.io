#!/bin/bash

# modify the root password
# sudo -i
# passwd
sudo useradd -m nisra
echo -e "nisra9012\nnisra9012" | passwd nisra
echo NISRA{y0u_4r3_4_600d_h4ck3r_l4} > /home/nisra/flag.txt
echo NISRA{YOU_FIND~~~} > /var/www/game
