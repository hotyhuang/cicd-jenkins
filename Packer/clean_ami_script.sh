#!/bin/sh

AWS_ACCESS_KEY=
AWS_ACCESS_SECRET=
PROJECT_NAME=

if [ "$1" == "--aws_key" ]
then
	AWS_ACCESS_KEY="$2"
fi

if [ "$3" = "--aws_secret" ]
then
    AWS_ACCESS_SECRET="$4"
fi


if [ -z AWS_ACCESS_KEY ] || [ -z AWS_ACCESS_SECRET ] || [ -z $5 ]
then
	printf "Usage: clean_ami_script --aws_key <your aws key> --aws_secret <your secret> <Project Name>\n"
    printf "e.g.:\n clean_ami_script --aws_key abc --aws_secret xxx \"My App\"\n"
    printf "This script will erase the images and snapshots created within Jenkins for the same project name.\n"
    exit 1
fi

PROJECT_NAME="$5"

region="us-east-1"
query="Images[*].{ID:ImageId,SnapshotIds:BlockDeviceMappings[*].Ebs.SnapshotId}"
filter="Name=name,Values=ami-${PROJECT_NAME}-*"

imageIds=()
snapshotIds=()
inSnapshot=

while IFS='' read line
do
	if [ $inSnapshot ] && [[ ! $line =~ "[" ]] && [[ ! $line =~ "]" ]]
	then
		_snapshotId=${line//\"/}
		_snapshotId=${_snapshotId/\,/}
		printf "**** found snapshot-id %s.\n" "${_snapshotId}"
		snapshotIds=("${snapshotIds[@]}" "$_snapshotId")
		_snapshotId=
	fi

	case $line in
		*\"ID\"*)
			_imageId=${line#*ID\": \"}
		    _imageId=${_imageId%\",*}
		    printf "**** found image-id %s.\n" "${_imageId}"
		    imageIds=("${imageIds[@]}" "$_imageId")
		    _imageId=
		;;
		*\"SnapshotIds\"*)
			inSnapshot="true"
		;;
		*\]*)
			if [ inSnapshot ]
			then
				inSnapshot=
			fi
		;;
		*)
		;;
	esac
done <<< "$(AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY \
AWS_SECRET_ACCESS_KEY=$AWS_ACCESS_SECRET \
aws --region $region ec2 describe-images --filters "$filter" --query "$query")"


for _id in "${imageIds[@]}"
do
	printf "** going to deregister image\: %s.\n" "${_id}"
	AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY \
	AWS_SECRET_ACCESS_KEY=$AWS_ACCESS_SECRET \
	aws ec2 deregister-image --image-id $_id
done

for _subid in "${snapshotIds[@]}"
do
	printf "** going to delete snapshot\: %s.\n" "${_subid}"
	AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY \
	AWS_SECRET_ACCESS_KEY=$AWS_ACCESS_SECRET \
	aws ec2 delete-snapshot --snapshot-id $_subid
done

