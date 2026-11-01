#!/usr/bin/env python3
"""Set or check the Large Address Aware (LAA) flag on a 32-bit Windows .exe.

Brothers in Arms: Hell's Highway ships a 32-bit executable, so by default it
can only use about 2 GB of address space. With HD texture packs installed it
runs out of address space and crashes. Setting the LAA flag raises the limit
to 4 GB on 64-bit Windows (and inside a Proton/Wine prefix on Linux).

Usage:
    python3 patch-laa.py "path/to/BIAHH.exe"          # check and set
    python3 patch-laa.py "path/to/BIAHH.exe" --check  # check only

A backup (BIAHH.exe.bak) is written next to the file before any change.
Works on Windows, Linux and macOS with Python 3, no dependencies.
"""
import shutil
import struct
import sys

LAA_BIT = 0x0020  # IMAGE_FILE_LARGE_ADDRESS_AWARE


def main() -> int:
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    check_only = "--check" in sys.argv
    if len(args) != 1:
        print(__doc__)
        return 2
    path = args[0]

    with open(path, "rb") as f:
        data = bytearray(f.read())

    if data[0:2] != b"MZ":
        print(f"{path}: not a Windows executable (no MZ header)")
        return 1
    pe_off = struct.unpack_from("<I", data, 0x3C)[0]
    if data[pe_off:pe_off + 4] != b"PE\x00\x00":
        print(f"{path}: no PE header found")
        return 1

    coff_off = pe_off + 4
    machine = struct.unpack_from("<H", data, coff_off)[0]
    if machine != 0x014C:
        print(f"{path}: not a 32-bit x86 executable (machine 0x{machine:04X}), nothing to do")
        return 1

    char_off = coff_off + 18  # Characteristics field of the COFF header
    chars = struct.unpack_from("<H", data, char_off)[0]
    if chars & LAA_BIT:
        print(f"{path}: Large Address Aware is already set. Nothing to do.")
        return 0

    if check_only:
        print(f"{path}: Large Address Aware is NOT set.")
        return 3

    backup = path + ".bak"
    shutil.copy2(path, backup)
    struct.pack_into("<H", data, char_off, chars | LAA_BIT)
    with open(path, "wb") as f:
        f.write(data)
    print(f"{path}: Large Address Aware set. Backup saved as {backup}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
