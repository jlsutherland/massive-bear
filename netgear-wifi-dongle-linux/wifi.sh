# install packages
sudo dpkg -i ndiswrapper_1.59-6_amd64.deb
sudo dpkg -i ndiswrapper-utils-1.9_1.59-6_all.deb
sudo dpkg -i ndisgtk_0.8.5-1ubuntu1_amd64.deb
sudo dpkg -i module-init-tools_22-1ubuntu4_all.deb
sudo dpkg -i dkms_2.2.0.3-1.1ubuntu5.14.04.5_all.deb
sudo dpkg -i ndiswrapper-dkms_1.59-6_all.deb

# this is the driver for 64 bit
sudo ndiswrapper -i ~/Desktop/bcmn43xx64.inf

# save config
sudo modprobe -v ndiswrapper
sudo ndiswrapper -ma
dmesg | grep ndis
lsmod
iwconfig
ndiswrapper -l
