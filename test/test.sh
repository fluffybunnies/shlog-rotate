#!/bin/bash

rm -fr ./~test
mkdir ./~test

echo "wef1" > ./~test/test1.log1.log
echo "wef2" > ./~test/test1.log2.log
./index.sh 1 ./~test/test1.log1.log ./~test/test1.log2.log


echo "wef1" > ./~test/test2.log1.log
echo "wef2" > ./~test/test2.log2.log
echo "echo \"Saving \$1 from deletion\"; cp \$1 \$1.bak" > ./~test/doit.sh && chmod +x ./~test/doit.sh
./index.sh 1 -h ./~test/doit.sh ./~test/test2.log1.log ./~test/test2.log2.log
./index.sh 1 -h ./~test/doit.sh ./~test/test2.log1.log ./~test/test2.log2.log


echo "wef1" > ./~test/test3.log1.log
echo "wef2" > ./~test/test3.log2.log
echo "echo \"Saving \$1 from deletion\"; cp \$1 \$1.bak" > ./~test/doit.sh && chmod +x ./~test/doit.sh
./index.sh 1 ./~test/test3.log1.log -h ./~test/doit.sh ./~test/test3.log2.log
./index.sh 1 ./~test/test3.log1.log -h ./~test/doit.sh ./~test/test3.log2.log


ls ./~test
rm -fr ./~test

