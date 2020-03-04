# bird-build-and-install
My script to Build and Install Bird dynamic routing on Debian and Ubuntu

Probably won't work for you!

See: https://bird.network.cz
It's really a great dynamic routing server
I use OSPF to help with my TINC mesh network (https://www.tinc-vpn.org), 

Using UFW
--OSPF uses multicast, so add these rules
sudo ufw allow to 224.0.0.5
sudo ufw allow to 224.0.0.6

March 2020

