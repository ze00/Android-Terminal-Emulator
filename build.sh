#!/usr/bin/env bash
#File   : build.sh
#Project:
#Author : ze00
#Email  : zerozakiGeek@gmail.com
#Date   : 2018-04-10
set -e
cd pvz ; git pull
make release
cp libpvz_server.so ../na/lib/armeabi
cd ..
cp -r pvz/pvz_client term/src/main/assets
./gradlew assembleDebug
v=$(cat v)
papk=$(printf "PVZ_CHEATER_V%03d.apk" $v)
pnaapk=$(printf "com.popcap.pvz_na_V%03d.apk" $v)
v=$(($v + 1))
apk=$(printf "PVZ_CHEATER_V%03d.apk" $v)
naapk=$(printf "com.popcap.pvz_na_V%03d.apk" $v)
rm -f $papk $pnaapk
mv term/build/outputs/apk/term-debug.apk $apk
ANDROID="~/work/lg15.1"
ANDROID_SECURITY="$ANDROID/build/target/product/security"
apktool b na -o temp.apk
signapk $ANDROID_SECURITY/testkey.x509.pem $ANDROID_SECURITY/testkey.pk8 temp.apk $naapk

BDS="~/bin/baiduyun-script/bdupload.sh"
$BDS $apk
$BDS $naapk

echo $v > v
