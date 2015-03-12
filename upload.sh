#!/bin/bash

#自动上传百度云脚本
#功能1：上传备份好的mysql文件
#功能2：将超过一个月以上的备份文件删除，节省空间
#by RMine at 2015-03-12


#upload file with bypy
function upload_file(){
        folder="/opt/mysql_backup/dumps"
        filename="my_database_`date +%Y%m%d`.dump"
        filePath=$folder/$filename
        if [ ! -x "$folder" ]; then
                echo "[ERROR]["`date +%Y-%m-%d' '%H:%M:%S`"] $folder is not exist."
                mkdir $folder
        fi


        if [ ! -f $filePath ]; then
                echo "[ERROR]["`date +%Y-%m-%d' '%H:%M:%S`"] $folder/$filename not found."
        else
                echo "[INFO]["`date +%Y-%m-%d' '%H:%M:%S`"] $folder/$filename has been found. Start uploading ......"
                /opt/bypy/bypy.py upload "$filePath" "mysql_backup/$filename"
                echo "[INFO]["`date +%Y-%m-%d' '%H:%M:%S`"] Uploading end."
        fi

}

#delete file for more than a month to save my poor space:(
function delete_before_month(){
        folder="/opt/mysql_backup/dumps"
        beforeAMonth=$(date -d "-1 month" +%Y%m%d)

        if [ ! -d $folder ]; then
                echo "[INFO]["`date +%Y-%m-%d' '%H:%M:%S`"] Folder not found. Nothing to do."
        else
                echo "[INFO]["`date +%Y-%m-%d' '%H:%M:%S`"] Iteration is beginning ......"
                for file in $folder/*
                do
                        if [ -f $file  ]; then
                                extension=${file##*.}
                                if [ "dump" = $extension ]; then
                                        baseName=$(basename $file .dump)
                                        timeStr=${baseName##*_}
                                        if (( $timeStr <= $beforeAMonth )); then
                                                rm -rf $file
                                                echo "[INFO]["`date +%Y-%m-%d' '%H:%M:%S`"] Delete file $file."
                                        fi
                                else
                                        echo $file" is not a dump file."
                                fi
                        else
                                        echo $file" is not a file."
                        fi
                done


                echo "[INFO]["`date +%Y-%m-%d' '%H:%M:%S`"] Iteration end ......"
        fi

}

upload_file;
delete_before_month;
