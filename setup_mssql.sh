#!/bin/bash

BASE=/tmp/setup

# Create the base temporary directory
mkdir $BASE
cd $BASE

# Download unixODBC
if ! wget ftp://ftp.unixodbc.org/pub/unixODBC/unixODBC-2.3.2.tar.gz; then
    echo 'Failed to download unixODBC!' 1>&2
    exit 1
fi

# Extract the files to a folder
tar -xvf unixODBC-2.3.2.tar.gz
cd unixODBC-2.3.2

# Build unixODBC to /usr/lib64
CPPFLAGS="-DSIZEOF_LONG_INT=8"
export CPPFLAGS

./configure --prefix=/usr --libdir=/usr/lib64 --sysconfdir=/etc --enable-gui=no --enable-drivers=no --enable-iconv --with-iconv-char-enc=UTF8
make
make install

if [ $? -ne 0 ]; then
    echo 'Failed to build unixODBC!' 1>&2
    exit 1
fi

# Create symbolic links so that MSSQL ODBC driver can find unixODBC
ln -s /usr/lib64/libodbcinst.so.2.0.0 /usr/lib64/libodbcinst.so.1
ln -s /usr/lib64/libodbc.so.2.0.0 /usr/lib64/libodbc.so.1

cd $BASE

# Download the MS SQL ODBC Driver for Linux from Microsoft
if ! wget http://download.microsoft.com/download/B/C/D/BCDD264C-7517-4B7D-8159-C99FC5535680/RedHat6/msodbcsql-11.0.2270.0.tar.gz; then
    echo 'Failed to download MS SQL ODBC driver' 1>&2
    exit 1
fi

# Extract the MS SQL ODBC Driver
mkdir mssql
tar -xvf msodbcsql-11.0.2270.0.tar.gz
cd msodbcsql-11.0.2270.0

# Modify the install script to work with unixODBC 2.3.2
sed -i -e 's/req_dm_ver="2.3.0";/req_dm_ver="2.3.2";/' install.sh


# Install the MS SQL ODBC driver
if ! ./install.sh install --accept-license; then
    echo 'Failed to install MS SQL ODBC driver' 1>&2
    exit 1
fi

# Cleanup by wiping the temp directory
cd /
rm /tmp/* -rf


