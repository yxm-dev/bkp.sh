#! /bin/bash

installdir=$HOME/.config/bkp.sh
source $installdir/data

function bkp(){
        topdir_name_2=$(echo "$2" | cut -d "/" -f2)
        topdir_name_3=$(echo "$3" | cut -d "/" -f2)
        if [[ "$1" == "cp" ]] || [[ "$1" == "copy" ]]; then
            for i in ${N[@]}; do
                if [[ "$topdir_name_2" == "${remote[$i]}" ]]; then
                    echo "copying $2 to $3..."
                    rclone copyto $topdir_name: $3 -P -L
                elif  [[ "$topdir_name_3" == "${remote[$i]}" ]]; then
                    echo "copying $2 to $3..."
                    rclone copyto $2 $topdir_name_3: -P -L
                fi
            done
        elif [[ "$1" == "mv" ]] || [[ "$1" == "move" ]]; then
            for i in ${N[@]}; do
                if [[ "$topdir_name_2" == "${remote[$i]}" ]]; then
                    echo "moving $2 to $3..."
                    rclone moveto $topdir_name: $3 -P -L
                elif  [[ "$topdir_name_3" == "${remote[$i]}" ]]; then
                    echo "moving $2 to $3..."
                    rclone moveto $2 $topdir_name_3: -P -L
                fi
            done
        elif [[ "$1" == "sync" ]]; then
            for i in ${N[@]}; do
                if [[ "$topdir_name_2" == "${remote[$i]}" ]]; then
                    echo "syncronizing $2 and $3..."
                    rclone sync $topdir_name: $3 -P -L
                elif  [[ "$topdir_name_3" == "${remote[$i]}" ]]; then
                    echo "syncronizing $2 to $3..."
                    rclone sync $2 $topdir_name_3: -P -L
                fi
            done
        elif [[ "$1" == "ls" ]] && [[ "$2" == "pcloud" ]]; then
            rclone ls $2:
        elif [[ "$1" == "ld" ]] && [[ "$2" == "pcloud" ]]; then
            rclone lsd $2:
        elif [[ -z "$1" ]] || [[ $main_direction == "push" ]]; then
            bkp $main_relation $main_dir $main_remote
        elif [[ -z "$1" ]] || [[ $main_direction == "pull" ]]; then
         bkp $main_relation $main_remote $main_dir
        else
            echo "options or remote note defined."
    fi
   }

## defining functions for the  main local dir and main remote
    function bkpc(){
        if [[ $main_direction == "push" ]]; then
            if [[ -z $1 ]]; then
                bkp cp $main_dir $main_remote
            else
                bkp cp $1 $main_remote
            fi
        else
            if [[ -z $1 ]]; then
                bkp cp $main_remote $main_dir
            else
                bkp cp $main_remote $1
            fi
        fi
    }

  function bkpm(){
        if [[ $main_direction == "push" ]]; then
            if [[ -z $1 ]]; then
                bkp mv $main_dir $main_remote
            else
                bkp mv $1 $main_remote
            fi
        else
            if [[ -z $1 ]]; then
                bkp mv $main_remote $main_dir
            else
                bkp mv $main_remote $1
            fi
        fi
    }
 
  function bkps(){
        if [[ $main_direction == "push" ]]; then
            if [[ -z $1 ]]; then
                bkp sync $main_dir $main_remote
            else
                bkp sync $1 $main_remote
            fi
        else
            if [[ -z $1 ]]; then
                bkp sync $main_remote $main_dir
            else
                bkp sync $main_remote $1
            fi
        fi
    }
 
