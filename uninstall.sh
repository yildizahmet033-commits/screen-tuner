#!/system/bin/sh
DIR=/data/adb/screen-tuner
[ -d "$DIR" ] || exit 0
(
    until [ "$(getprop sys.boot_completed)" = "1" ]; do sleep 2; done
    sleep 5
    if [ -f "$DIR/saturation" ]; then
        setprop persist.sys.sf.color_saturation 1.0
        service call SurfaceFlinger 1022 f 1.0
    fi
    if [ -f "$DIR/original" ]; then
        read -r s d < "$DIR/original"
        if [ "$s" = "-" ]; then wm size reset; else wm size "$s"; fi
        if [ "$d" = "-" ]; then wm density reset; else wm density "$d"; fi
    fi
    rm -f "$DIR/saturation" "$DIR/pending" "$DIR/original"
    rmdir "$DIR"
) >/dev/null 2>&1 &
