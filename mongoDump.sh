#!/bin/bash

MONGODUMP=`which mongodump`;
MONGORESTORE=`which mongorestore`;
MONGOCLIENT=`which mongo`
MDB=koredbm001;
TDB=koredbt001;


while [[ $# > 0 ]]
do
    key="$1"
    case $key in
        -h|--host)
            HOST="$2"
            shift
            ;;
        -p|--port)
            PORT="$2"
            shift
            ;;
        -r|--restore)
            RESTORE=YES
            ;;
        -a|--archive)
            ARCHIVE=YES
            ;;
        -d|--dropdbs)
            DROP=YES
            ;;
        --default)
            DEFAULT=YES
            ;;
        *)
            ;;
    esac
    shift 
done


if [ -z $HOST ] || [ -z $PORT ]; then
    echo " Execute script with proper --host and --port options";
    exit 1;
fi

if [ -z $MONGODUMP ] || [ -z $MONGORESTORE ]; then 
    echo "mongodump or mongorestore commands not in the path";
    exit 1;
else
    echo -e  "Found mongodump in \e[33m$MONGODUMP \e[0m\n";
    echo -e "Found mongorestore in \e[33m$MONGORESTORE \e[0m\n";
fi

create_folder(){
    FOLDERNAME=`pwd`/`date +"%h-%m-%Y-%H-%M-%S"`;
    mkdir $FOLDERNAME;
   
    if [ $? -ne 0 ]; then
        echo "Unable to create folder $FOLDERNAME";
        exit 1;
    fi
    
    echo -e "\nCreated folder $FOLDERNAME for backup\n";
}

backup_collection() {

    echo -e "Backing up \e[32m$2\e[0m";
    cd $FOLDERNAME;

    $MONGODUMP --quiet --host $HOST --port $PORT --db $1 --collection $2;
    if [ $? -ne 0 ]; then
        echo "Command $MONGODUMP exited with non zero response $?";
        exit 1;
    fi
}

restore_collection(){
    cd $FOLDERNAME;

    $MONGORESTORE --drop --quiet;

    if [ $? -ne 0 ]; then
        echo "Command $MONGORESTORE exited with non zero response $?";
        exit 1;
    fi

    echo -e "DONE";
}



archive_folder(){

    FILENAME=`basename $1`;
    echo -e "\n########### Archiving ########### \n";
    echo -e "Archiving contents of $1 to \e[32m$FILENAME.tgz\e[0m";
    cd $1;
    tar -zcf ../$FILENAME.tgz .
    if [ $? -ne 0 ]; then
        echo "Command tar exited with non zero response $?";
        exit 1;
    fi

    echo -e "\nDeleting folder \e[31m$1\e[0m";
    rm -rf $1;
}

create_folder;

mBTCollections=(btactions btactionversions btalerts btalertversions btfilters btparammaps btseeddatas btstreams idpconfigurations mpactions mpalerts mpcategories mpstreams mpuserorders licenses organizations idtoaccounts accounts accounttolicenses dbversions whitelisteddomains);
tBTCollections=(files users);


echo -e "##### Initiating Backup ##### \n \n";

for i in ${mBTCollections[@]} ; do 
    backup_collection $MDB $i ;
done

for i in ${tBTCollections[@]} ; do 
    backup_collection $TDB $i ;
done



if [ "$RESTORE" == "YES" ]; then
    if [ "$DROP" == "YES" ]; then
        echo -e "\n###### Dropping Databases $MDB $TDB ########\n";
        $MONGOCLIENT $MDB --eval "printjson(db.dropDatabase())";
        $MONGOCLIENT $TDB --eval "printjson(db.dropDatabase())";
    fi
    echo -e "\n###### Restoring Collections to local db #######\n";
    restore_collection;
fi

if [ "$ARCHIVE" == "YES" ]; then
    archive_folder $FOLDERNAME;
fi

echo -e "\nBye bye ...."
