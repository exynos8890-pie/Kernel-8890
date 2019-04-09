#!/system/bin/sh
# 
# Init ArianoxxKernel
#

ARIANOXX_DIR="/data/.arianoxxkernel"
LOG="$ARIANOXX_DIR/arianoxxkernel.log"

rm -f $LOG

BB="/sbin/busybox"
RESETPROP="/sbin/resetprop -v -n"


# Mount
$BB mount -t rootfs -o remount,rw rootfs;
$BB mount -o remount,rw /system;
$BB mount -o remount,rw /data;
$BB mount -o remount,rw /;

# Create morokernel folder
if [ ! -d $ARIANOXX_DIR ]; then
	mkdir -p $ARIANOXX_DIR;
fi


(
	echo $(date) "arianoxx-Kernel LOG" >> $LOG
	echo " " >> $LOG

	
	# Stop secure_storage service
	su -c "stop secure_storage"

	# Google play services wakelock fix
	echo "## -- GooglePlay wakelock fix" >> $LOG
	su -c "pm enable com.google.android.gms/.update.SystemUpdateActivity"
	su -c "pm enable com.google.android.gms/.update.SystemUpdateService"
	su -c "pm enable com.google.android.gms/.update.SystemUpdateService$ActiveReceiver"
	su -c "pm enable com.google.android.gms/.update.SystemUpdateService$Receiver"
	su -c "pm enable com.google.android.gms/.update.SystemUpdateService$SecretCodeReceiver"
	echo " " >> $LOG

	
	# Fix personalist.xml
	if [ ! -f /data/system/users/0/personalist.xml ]; then
		touch /data/system/users/0/personalist.xml
		chmod 600 /data/system/users/0/personalist.xml
		chown system:system /data/system/users/0/personalist.xml
	fi


) 2>&1 | tee -a ./$LOG

chmod 777 $LOG

# Unmount
$BB mount -t rootfs -o remount,ro rootfs;
$BB mount -o remount,ro /system;
$BB mount -o remount,rw /data;
$BB mount -o remount,ro /;

