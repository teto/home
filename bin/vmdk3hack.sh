#!/bin/bash

VMDK=$1
FULLSIZE=`stat -c%s "$VMDK"`
VMDKFOOTER=$[$FULLSIZE - 0x400]
VMDKFOOTERVER=$[$VMDKFOOTER + 4]

case "`xxd -ps -s $VMDKFOOTERVER -l 1 \"$VMDK\"`" in
  03)
    echo -e "$VMDK is VMDK3.\n Patching to VMDK2.\n Run this script again when you're done to patch it back."
    echo -en '\x02' | dd conv=notrunc status=none oflag=seek_bytes seek=$[VMDKFOOTERVER] of="$VMDK"
    ;;
  02)
    echo "File is VMDK2. Patching to VMDK3."
    echo -en '\x03' | dd conv=notrunc status=none oflag=seek_bytes seek=$[VMDKFOOTERVER] of="$VMDK"
    ;;
  default)
    echo "$VMDK is not VMDK3 or patched-VMDK3.\n"
  ;;
esac
