#! /bin/bash
cwd=`pwd`
if [ "$EUID" -ne 0 ]
	then echo "Please run as root"
	exit
fi

apt-get update
apt-get install wget git build-essential autoconf libtool automake bison python-dev swig -y

cd /root
git clone https://github.com/cmusphinx/sphinxbase.git

cd /root/sphinxbase
./autogen.sh
make
make install

cd /root
rm -r /root/sphinxbase

git clone https://github.com/cmusphinx/pocketsphinx.git

cd /root/pocketsphinx
./autogen.sh
make
make install

cd $cwd

wget --output-document vlc.py "http://git.videolan.org/?p=vlc/bindings/python.git;a=blob_plain;f=generated/vlc.py;hb=HEAD"
apt-get install libasound2-dev memcached python-pip python-alsaaudio vlc -y
pip install -r requirements.txt
cp initd_alexa.sh /etc/init.d/AlexaPi
update-rc.d AlexaPi defaults
touch /var/log/alexa.log

cd $cwd

echo "Enter your Device Type ID:"
read productid
echo ProductID = \"$productid\" >> creds.py

echo "Enter your Security Profile Description:"
read spd
echo Security_Profile_Description = \"$spd\" >> creds.py

echo "Enter your Security Profile ID:"
read spid
echo Security_Profile_ID = \"$spid\" >> creds.py

echo "Enter your Client ID:"
read cid
echo Client_ID = \"$cid\" >> creds.py

echo "Enter your Client Secret:"
read secret
echo Client_Secret = \"$secret\" >> creds.py

python ./auth_web.py 
