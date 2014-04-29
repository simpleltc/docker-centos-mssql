#!/bin/bash

BASE=/tmp/setup

mkdir $BASE
cd $BASE

wget ftp://ftp.unixodbc.org/pub/unixODBC/unixODBC-2.3.2.tar.gz
tar -xvf unixODBC-2.3.2.tar.gz
cd unixODBC-2.3.2
./configure --libdir=/usr/lib64
make
make install
ln -s /usr/lib64/libodbcinst.so.2.0.0 /usr/lib64/libodbcinst.so.1
ln -s /usr/lib64/libodbc.so.2.0.0 /usr/lib64/libodbc.so.1
cd $BASE

wget http://download.microsoft.com/download/6/A/B/6AB27E13-46AE-4CE9-AFFD-406367CADC1D/Linux6/sqlncli-11.0.1790.0.tar.gz
mkdir mssql
tar -xvf sqlncli-11.0.1790.0.tar.gz
cd sqlncli-11.0.1790.0
sed -i -e 's/req_dm_ver="2.3.0";/req_dm_ver="2.3.2";/' install.sh
./install.sh install --accept-license

cd /
rm /tmp/* -rf


