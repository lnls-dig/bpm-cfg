#!/usr/bin/env python3

from frugy.fru import Fru
import argparse
import pandas as pd
import numpy as np

parser = argparse.ArgumentParser(description="Corrects AFCv4 FRU records")
parser.add_argument("--csv-in", type=str,
                    help="CSV with informations of the AFCv4 boards", required=True)
parser.add_argument("--rack_number", type=int,
                    help="Number of the rack", required=True)
parser.add_argument("--bin-in", type=str,
                    help="Binary file from FRU read", required=True)
parser.add_argument("--bin-out", type=str,
                    help="Binary file for FRU write", required=True)

args = parser.parse_args()

component_list = pd.read_csv(args.csv_in)
i, c = np.where(component_list == args.rack_number)
fru = Fru()
fru.load_bin(args.bin_in)
yaml = fru.to_dict()
yaml['BoardInfo']['manufacturer'] = 'Creotech'
yaml['BoardInfo']['product_name'] = 'AFC:4.0.2'
yaml['BoardInfo']['serial_number'] = component_list['SerialNumber'][i[0]]
yaml['BoardInfo']['part_number'] = 'AFC'
yaml['BoardInfo']['fru_file_id'] = 'AFCFRU'
yaml['ProductInfo']['manufacturer'] = 'CNPEM'
yaml['ProductInfo']['product_name'] = 'AFC'
yaml['ProductInfo']['serial_number'] = component_list['Tag'][i[0]]
yaml['ProductInfo']['part_number'] = 'AFC'
yaml['ProductInfo']['version'] = '4.0.2'
yaml['ProductInfo']['asset_tag'] = 'No tag'
yaml['ProductInfo']['fru_file_id'] = 'AFCFRU'
yaml['MultirecordArea'][3]['identifier_type'] = 'CLASS_ID'
yaml['MultirecordArea'][3]['identifier_body'] = ['D1.3']

fru.update(yaml)
fru.save_bin(args.bin_out)
