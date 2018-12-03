#!/bin/sh
echo $0 OLD-COMMITID NEW-COMMITD
OLD=$1
NEW=$2

find . -name Dockerfile -exec sed -i "s/$OLD/$NEW/g" {} \;
find . -name build.sh  -exec sed -i "s/$OLD/$NEW/g" {} \;

for i in "hdfs-datanode hdfs-namenode livy yarn-nm yarn-rm"; do  
   cd $i
   ./build.sh 
   cd -
done
