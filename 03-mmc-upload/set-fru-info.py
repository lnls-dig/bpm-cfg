#!/usr/bin/env python3

import argparse
from frugy.fru import Fru

parser = argparse.ArgumentParser(description="Corrects AFC FRU records")
parser.add_argument("--bin-in", type=str,
                    help="Binary file from FRU read", required=True)
parser.add_argument("--bin-out", type=str,
                    help="Binary file for FRU write", required=True)

subparsers = parser.add_subparsers(dest="section", help="Sections to update")

# BoardInfo subparser
boardinfo_parser = subparsers.add_parser(
    "boardinfo", help="BoardInfo section fields")
boardinfo_parser.add_argument("--mfg-date-time", type=str)
boardinfo_parser.add_argument("--manufacturer", type=str)
boardinfo_parser.add_argument("--product-name", type=str)
boardinfo_parser.add_argument("--serial-number", type=str)
boardinfo_parser.add_argument("--part-number", type=str)
boardinfo_parser.add_argument("--fru-file-id", type=str)

# ProductInfo subparser
productinfo_parser = subparsers.add_parser(
    "productinfo", help="ProductInfo section fields")
productinfo_parser.add_argument("--manufacturer", type=str)
productinfo_parser.add_argument("--product-name", type=str)
productinfo_parser.add_argument("--part-number", type=str)
productinfo_parser.add_argument("--version", type=str)
productinfo_parser.add_argument("--serial-number", type=str)
productinfo_parser.add_argument("--asset-tag", type=str)
productinfo_parser.add_argument("--fru-file-id", type=str)

# MultirecordArea subparser
multirecordarea_parser = subparsers.add_parser(
    "multirecordarea", help="MultirecordArea section fields")
multirecordarea_parser.add_argument(
    "--current-draw", type=float)
multirecordarea_parser.add_argument(
    "--identifier-type", type=str)
multirecordarea_parser.add_argument(
    "--identifier-body", type=str, nargs="+")

args = parser.parse_args()

# Load FRU file
fru = Fru()
fru.load_bin(args.bin_in)
yaml = fru.to_dict()

# Update fields based on the selected section
if args.section == "boardinfo":
    if args.manufacturer:
        yaml['BoardInfo']['manufacturer'] = args.manufacturer
    if args.product_name:
        yaml['BoardInfo']['product_name'] = args.product_name
    if args.serial_number:
        yaml['BoardInfo']['serial_number'] = args.serial_number
    if args.part_number:
        yaml['BoardInfo']['part_number'] = args.part_number
    if args.fru_file_id:
        yaml['BoardInfo']['fru_file_id'] = args.fru_file_id

elif args.section == "productinfo":
    if args.manufacturer:
        yaml['ProductInfo']['manufacturer'] = args.manufacturer
    if args.product_name:
        yaml['ProductInfo']['product_name'] = args.product_name
    if args.part_number:
        yaml['ProductInfo']['part_number'] = args.part_number
    if args.version:
        yaml['ProductInfo']['version'] = args.version
    if args.serial_number:
        yaml['ProductInfo']['serial_number'] = args.serial_number
    if args.asset_tag:
        yaml['ProductInfo']['asset_tag'] = args.asset_tag
    if args.fru_file_id:
        yaml['ProductInfo']['fru_file_id'] = args.fru_file_id

elif args.section == "multirecordarea":
    if args.current_draw:
        yaml['MultirecordArea'][0]['current_draw'] = args.current_draw
    if args.identifier_type:
        yaml['MultirecordArea'][3]['identifier_type'] = args.identifier_type
    if args.identifier_body:
        yaml['MultirecordArea'][3]['identifier_body'] = args.identifier_body

# Update and save FRU
fru.update(yaml)
fru.save_bin(args.bin_out)
