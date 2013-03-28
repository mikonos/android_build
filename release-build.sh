#!/bin/sh
#define the name of markets
markets="Google Amazon"
baiduid_release=YOUR_BD_ID
baiduid_debug=YOUR_BD_ID_DEBUG
gaid_release=YOUR_GA_ID
gaid_debug=YOUR_GA_ID_DEBUG

#edit the statistics id info of baidu and ga
sed -i "s/\(<meta-data android:name=\"BaiduMobAd_STAT_ID\"\)\( android:value=\)\"\(.*\)\"/\1\2\"$baiduid_release\"/g" AndroidManifest.xml
sed -i "s/\(<string name=\"ga_trackingId\">\)\(.*\)\(<\/string>\)/\1$gaid_release\3/g" ./res/values/analytics.xml

svn --username=YOUR_USER_NAME --password=YOUR_PASSWORD update
#edit the version info
version=`svn info |grep Revision: |awk '{print $2}'`
	echo packageing app for version $version
	sed -i "s/\(android:versionCode=\)\"\(.*\)\"/\1\"$version\"/g" AndroidManifest.xml
	sed -i "s/\(android:versionName=\"1\.2\.\)\(.*\)\(\.4\"\)/\1$version\3/g" AndroidManifest.xml

for market in $markets
do
	echo packageing app for market $market..
	sed -i "s/\(<meta-data android:name=\"BaiduMobAd_CHANNEL\"\)\( android:value=\)\"\(.*\)\"/\1\2\"$market\"/g" AndroidManifest.xml
	ant clean
	ant release -Dapk-market=$market -Dapk-version=$version -Dkey.store.password=c0m0d0cms -Dkey.alias.password=c0m0d0cms -Dkey.store=../keys/android.keystore
done

