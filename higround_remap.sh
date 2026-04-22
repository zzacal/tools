#!/bin/bash
# Re-apply key remapping for Higround Base 65 Performance keyboard.
# Run after replugging the keyboard, or any time the mapping drops.
#
# Mapping:
#   Escape        -> Grave/tilde (` and ~)
#   Caps Lock     -> Escape
#   Left Command  -> Left Option
#   Left Option   -> Left Command
#   Right Option  -> Right Command

set -euo pipefail

VENDOR_ID=0x35AB
PRODUCT_ID=0x3

hidutil property \
    --matching "{\"VendorID\":${VENDOR_ID},\"ProductID\":${PRODUCT_ID}}" \
    --set '{"UserKeyMapping":[
        {"HIDKeyboardModifierMappingSrc":0x700000029,"HIDKeyboardModifierMappingDst":0x700000035},
        {"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x700000029},
        {"HIDKeyboardModifierMappingSrc":0x7000000E3,"HIDKeyboardModifierMappingDst":0x7000000E2},
        {"HIDKeyboardModifierMappingSrc":0x7000000E2,"HIDKeyboardModifierMappingDst":0x7000000E3},
        {"HIDKeyboardModifierMappingSrc":0x7000000E6,"HIDKeyboardModifierMappingDst":0x7000000E7}
    ]}' >/dev/null

if ioreg -p IOUSB -l -w 0 | grep -q "Higround Base 65 Performance"; then
    echo "Higround remap applied."
else
    echo "Warning: Higround keyboard not detected. Mapping set but will take effect when plugged in." >&2
fi
