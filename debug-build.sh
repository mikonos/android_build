#!/bin/sh

baiduid_release=Your_ID_OF_BD_
baiduid_debug=YOUR_ID_OF_BD_DEBUG
gaid_release=YOUR_GA_ID
gaid_debug=YOUR_GA_ID_DEBUG

#edit the statistics id info of baidu and ga
sed -i "s/\(<meta-data android:name=\"BaiduMobAd_STAT_ID\"\)\( android:value=\)\"\(.*\)\"/\1\2\"$baiduid_debug\"/g" AndroidManifest.xml
sed -i "s/\(<string name=\"ga_trackingId\">\)\(.*\)\(<\/string>\)/\1$gaid_debug\3/g" ./res/values/analytics.xml

svn --username=YOUR_USER_NAME --password=YOUR_PASSWORD update
version=`svn info |grep Revision: |awk '{print $2}'`
echo packageing app for version $version
sed -i "s/\(android:versionCode=\)\"\(.*\)\"/\1\"$version\"/g" AndroidManifest.xml
sed -i "s/\(android:versionName=\"1\.2\.\)\(.*\)\(\.4\"\)/\1$version\3/g" AndroidManifest.xml

market=Testing
sed -i "s/\(<meta-data android:name=\"BaiduMobAd_CHANNEL\"\)\( android:value=\)\"\(.*\)\"/\1\2\"$market\"/g" AndroidManifest.xml
ant clean
ant debug -Dapk-version=$version -Dapk-market=$market

svn info
