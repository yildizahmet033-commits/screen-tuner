#!/system/bin/sh
# Screen Tuner: every change goes through this script.
DIR=/data/adb/screen-tuner
CONF=$DIR/saturation
PENDING=$DIR/pending
ORIGINAL=$DIR/original
MODDIR=${0%/*}
mkdir -p "$DIR"

is_num() { case "$1" in ''|*[!0-9]*) return 1 ;; esac; [ ${#1} -le 5 ]; }
phys_size() { wm size | sed -n 's/^Physical size: //p'; }
over_size() { wm size | sed -n 's/^Override size: //p'; }
phys_dens() { wm density | sed -n 's/^Physical density: //p'; }
over_dens() { wm density | sed -n 's/^Override density: //p'; }
get_sat() { v=$(cat "$CONF" 2>/dev/null); is_num "$v" && echo "$v" || echo 100; }

apply_sat() {
    f="$(($1 / 100)).$(printf %02d $(($1 % 100)))"
    setprop persist.sys.sf.color_saturation "$f"
    service call SurfaceFlinger 1022 f "$f" | grep -q 'Parcel(NULL)'
}

# restore "<size|-> <density|->"
restore() {
    if [ "$1" = "-" ]; then wm size reset; else wm size "$1"; fi
    if [ "$2" = "-" ]; then wm density reset; else wm density "$2"; fi
}

case "$1" in
status)
    p=$(phys_size); o=$(over_size); pd=$(phys_dens); od=$(over_dens)
    echo "{\"sat\":$(get_sat),\"phys\":\"$p\",\"cur\":\"${o:-$p}\",\"physDens\":${pd:-0},\"curDens\":${od:-${pd:-0}},\"pending\":$([ -f "$PENDING" ] && echo true || echo false)}"
    ;;
sat)
    is_num "$2" && [ "$2" -ge 50 ] && [ "$2" -le 200 ] || { echo bad-value; exit 1; }
    apply_sat "$2" || { echo not-supported; exit 1; }
    echo "$2" > "$CONF"
    ;;
boot-sat)
    s=$(get_sat); [ "$s" = 100 ] || apply_sat "$s"
    ;;
res)
    is_num "$2" && is_num "$3" && is_num "$4" || { echo bad-value; exit 1; }
    [ "$2" -ge 480 ] && [ "$3" -ge 480 ] && [ "$4" -ge 100 ] && [ "$4" -le 900 ] || { echo bad-value; exit 1; }
    p=$(phys_size)
    [ "$2" -le "${p%x*}" ] && [ "$3" -le "${p#*x}" ] || { echo bad-value; exit 1; }
    [ -f "$PENDING" ] && { echo busy; exit 1; }
    os=$(over_size); od=$(over_dens)
    [ -f "$ORIGINAL" ] || echo "${os:--} ${od:--}" > "$ORIGINAL"
    token="$(date +%s)-$$"
    echo "${os:--} ${od:--} $token" > "$PENDING"
    # Revert on its own unless the user confirms, even if the WebUI is gone
    setsid sh "$MODDIR/ctl.sh" watch "$token" >/dev/null 2>&1 </dev/null &
    if ! { wm size "$2x$3" && wm density "$4"; }; then
        sh "$MODDIR/ctl.sh" revert
        exit 1
    fi
    ;;
watch)
    sleep 15
    read -r s d t < "$PENDING" 2>/dev/null || exit 0
    [ "$t" = "$2" ] && sh "$MODDIR/ctl.sh" revert
    ;;
confirm)
    rm -f "$PENDING"
    ;;
revert)
    [ -f "$PENDING" ] || exit 0
    read -r s d t < "$PENDING"
    rm -f "$PENDING"
    restore "$s" "$d"
    ;;
reset)
    rm -f "$PENDING"
    apply_sat 100
    rm -f "$CONF"
    if [ -f "$ORIGINAL" ]; then read -r s d < "$ORIGINAL"; rm -f "$ORIGINAL"; restore "$s" "$d"; fi
    ;;
*)
    echo "usage: status | sat <50-200> | res <w> <h> <density> | confirm | revert | reset"
    exit 1
    ;;
esac
