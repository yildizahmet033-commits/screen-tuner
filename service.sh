#!/system/bin/sh
MODDIR=${0%/*}
until [ "$(getprop sys.boot_completed)" = "1" ]; do sleep 2; done
# A resolution change that was never confirmed must not survive a reboot
sh "$MODDIR/ctl.sh" revert
# The framework writes 1.0 while applying the color mode
for wait in 2 10 30; do
    sleep $wait
    sh "$MODDIR/ctl.sh" boot-sat
done
