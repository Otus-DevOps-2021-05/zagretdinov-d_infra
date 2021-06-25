yc compute instance create \
	--name red-app \
	--hostname red-app \
	--memory=2 \
	--create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
	--network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
	--metadata serial-port-enable=1 \
  --metadata-from-file user-data=id-app.yaml
