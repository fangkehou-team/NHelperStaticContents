#!/bin/bash

BASE_DIR=$(dirname $0)

cd $BASE_DIR

rm -rf *.zip

for i in "aarch64" "arm" "i686" "x86_64"
do
    echo "-------------------------------------"
    echo "generate the nginx package for ${i}..."

    mkdir -p $i
    cd ./$i
    
    rm -rf *
    
    echo "-------------------------------------"
    echo "extract files..."
    
    unzip ../downloads/debs-$i-*.zip -d ./debs
    
    tar -xvf ./debs/debs-$i-*.tar 
    
    for file in $(ls ./debs | grep .deb)
    do
        file_name=$(basename $file .deb)
        
        mkdir ./debs/$file_name
        
        ar -x ./debs/$file --output=./debs/$file_name
        
        tar -Jxvf ./debs/$file_name/data.tar.xz     
    done

    rm -rf ./data/data/org.eu.fangkehou.nhelper2/files/usr/share/nginx/html/*.html
    cp ../files/*.html ./data/data/org.eu.fangkehou.nhelper2/files/usr/share/nginx/html/

    mkdir -p ./data/data/org.eu.fangkehou.nhelper2/files/usr/etc/nginx/ca
    cp ../files/pixiv.net.* ./data/data/org.eu.fangkehou.nhelper2/files/usr/etc/nginx/ca/

    rm -rf ./data/data/org.eu.fangkehou.nhelper2/files/usr/etc/nginx/nginx.conf
    cp ../files/nginx.conf ./data/data/org.eu.fangkehou.nhelper2/files/usr/etc/nginx/nginx.conf

    
    echo "-------------------------------------"
    echo "generate nginx_${i}.zip..."
    
    	mkdir ./data/data/org.eu.fangkehou.nhelper2/files/usr/tmp
        
        (cd "./data/data/org.eu.fangkehou.nhelper2/files"
		    # Do not store symlinks in bootstrap archive.
		    # Instead, put all information to SYMLINKS.txt
		    while read -r -d '' link; do
			    echo "$(readlink "$link")←${link}" >> SYMLINKS.txt
			    rm -f "$link"
		    done < <(find . -type l -print0)

		    zip -r9 "./nginx_${i}.zip" ./*
	    )
	    
	    mv ./data/data/org.eu.fangkehou.nhelper2/files/nginx_${i}.zip ../
	    
	    echo "generate for ${i} conpleted"
    
    cd ..
done

echo "all completed!"

