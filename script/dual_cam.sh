#!/bin/sh

# K1-USB-Cam: Dual camera launcher with robust device detection
# Uses cascading detection strategies (most reliable first)
#
# Strategy 1: /dev/v4l/by-path (USB port path - stable across reboots)
# Strategy 2: /dev/v4l/by-id (device name symlinks)
# Strategy 3: v4l2-ctl output parsing (last resort, can segfault)
#
# If only one camera is found, falls back to single camera mode automatically.

sleep 2m

# Cleanup
killall mjpg_streamer 2>/dev/null || true
for i in $(seq 4 8); do fuser -k /dev/video$i 2>/dev/null; done

# Helper: resolve symlink to real device path
# BusyBox readlink resolves one level (no -f); sufficient for by-path/by-id
resolve_device() {
    local path="$1"
    if [ -L "$path" ]; then
        local target
        target=$(readlink "$path" 2>/dev/null) || return 1
        case "$target" in
            /*) echo "$target" ;;
            *)  echo "$(dirname "$path")/$target" ;;
        esac
    elif [ -e "$path" ]; then
        echo "$path"
    fi
}

# Helper: validate device exists and is a character device (V4L2)
is_valid_device() {
    local dev="$1"
    [ -n "$dev" ] && [ -c "$dev" ]
}

# Strategy 1: find camera by USB port path (most stable)
# K1 internal camera is always on USB port 1.3
# External USB camera is always on USB port 1.2
detect_by_usb_path() {
    local by_path="/dev/v4l/by-path"
    [ -d "$by_path" ] || return 1

    INTERNAL=""
    EXTERNAL=""

    for link in "$by_path"/*; do
        [ -L "$link" ] || continue
        local name
        name=$(basename "$link")
        local real
        real=$(resolve_device "$link")
        is_valid_device "$real" || continue

        case "$name" in
            *1.3*) [ -z "$INTERNAL" ] && INTERNAL="$real" ;;
            *1.2*) [ -z "$EXTERNAL" ] && EXTERNAL="$real" ;;
        esac
    done

    [ -n "$INTERNAL" ] && [ -n "$EXTERNAL" ] && [ "$INTERNAL" != "$EXTERNAL" ]
}

# Strategy 2: find camera by device ID/name symlinks
detect_by_device_id() {
    local by_id="/dev/v4l/by-id"
    [ -d "$by_id" ] || return 1

    INTERNAL=""
    EXTERNAL=""

    for link in "$by_id"/*; do
        [ -L "$link" ] || continue
        local name
        name=$(basename "$link")
        local real
        real=$(resolve_device "$link")
        is_valid_device "$real" || continue

        case "$name" in
            *CREALITY*|*CCX*|*main*)
                [ -z "$INTERNAL" ] && INTERNAL="$real"
                ;;
            *UVC*|*usb*|*Camera*|*camera*|*Webcam*|*webcam*|*Logitech*|*logitech*)
                [ -z "$EXTERNAL" ] && EXTERNAL="$real"
                ;;
        esac
    done

    [ -n "$INTERNAL" ] && [ -n "$EXTERNAL" ] && [ "$INTERNAL" != "$EXTERNAL" ]
}

# Strategy 3: fallback to v4l2-ctl with awk-based robust parsing
detect_by_v4l2ctl() {
    command -v v4l2-ctl >/dev/null 2>&1 || return 1

    # v4l2-ctl can segfault on some firmwares; capture output safely
    local output
    output=$(v4l2-ctl --list-devices 2>/dev/null) || return 1
    [ -n "$output" ] || return 1

    INTERNAL=""
    EXTERNAL=""

    # Parse output with awk: device name line followed by indented /dev/videoN
    # Write results to temp file to avoid subshell variable scoping
    local tmpfile="/tmp/k1cam_detect.$$"
    echo "$output" | awk '
        /^$/ { next }
        /^[[:space:]]*\/dev\/video/ {
            dev=$1
            gsub(/^[[:space:]]+/, "", dev)
            if (name ~ /CREALITY|CCX/) printf "INTERNAL=%s\n", dev
            else if (name ~ /usb|USB/) printf "EXTERNAL=%s\n", dev
            next
        }
        { name=$0 }
    ' > "$tmpfile" 2>/dev/null

    . "$tmpfile" 2>/dev/null
    rm -f "$tmpfile"

    [ -n "$INTERNAL" ] && [ -n "$EXTERNAL" ] && [ "$INTERNAL" != "$EXTERNAL" ]
}

# --- Main detection logic: cascade through strategies ---

CAM1=""
CAM2=""

if detect_by_usb_path; then
    CAM1="$INTERNAL"
    CAM2="$EXTERNAL"
    echo "[k1cam] Detected via USB path: internal=$CAM1 external=$CAM2"
elif detect_by_device_id; then
    CAM1="$INTERNAL"
    CAM2="$EXTERNAL"
    echo "[k1cam] Detected via device ID: internal=$CAM1 external=$CAM2"
elif detect_by_v4l2ctl; then
    CAM1="$INTERNAL"
    CAM2="$EXTERNAL"
    echo "[k1cam] Detected via v4l2-ctl: internal=$CAM1 external=$CAM2"
fi

# Validate results
if ! is_valid_device "$CAM1"; then
    echo "[k1cam] ERROR: Internal camera not found. Is the K1 camera connected?"
    echo "[k1cam] Searched /dev/v4l/by-path, /dev/v4l/by-id, and v4l2-ctl."
    echo "[k1cam] Try running 'v4l2-ctl --list-devices' via SSH to debug."
    exit 1
fi

if ! is_valid_device "$CAM2"; then
    echo "[k1cam] WARNING: External USB camera not found. Falling back to single camera mode."
    mjpg_streamer -b \
        -i "/usr/lib/mjpg-streamer/input_uvc.so -d $CAM1" \
        -o "/usr/lib/mjpg-streamer/output_http.so -p 8080"
    exit 0
fi

# Launch dual cameras
mjpg_streamer -b \
    -i "/usr/lib/mjpg-streamer/input_uvc.so -d $CAM1" \
    -i "/usr/lib/mjpg-streamer/input_uvc.so -d $CAM2" \
    -o "/usr/lib/mjpg-streamer/output_http.so -p 8080"
