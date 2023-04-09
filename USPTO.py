from parsers.parse_txt_file import *
from parsers.parse_xml_v2_file import *
from parsers.parse_xml_v4_file import *
from bs4 import BeautifulSoup
import pandas as pd
#import numpy as np
import time
import random
import requests, zipfile, io
import re



def read_and_parse_yearly_data(year, data_items):
    if type(year) == int and year >= 1976 and year <= 2020: 
        list_of_files = requests.get(f'https://bulkdata.uspto.gov/data/patent/grant/redbook/fulltext/{year}/')
        page_html_text = list_of_files.text
        html_parser = BeautifulSoup(page_html_text, 'html.parser')
        href_files_list = []
        for tr in html_parser.find_all('table')[1].find_all('a'):
            if tr['href'] != None: 
                href_files_list.append(tr['href'])
        if year == 2001:
            href_files_list = list(filter(lambda x: x.endswith('.zip') and 'aps' in x, href_files_list))
        else:
            href_files_list = list(filter(lambda x: x.endswith('.zip'), href_files_list))
        full_yearly_data = []
        print(f'{len(href_files_list)} files found')
        current_file_number = 0
        for file in href_files_list:
            current_file_number += 1
            url = f'https://bulkdata.uspto.gov/data/patent/grant/redbook/fulltext/{year}/{file}'
            print(f'Parsing file {current_file_number}/{len(href_files_list)} - {url}')
            if year <= 2001:
                patent_data = read_data_from_url_txt(url)
                for patent in patent_data:
                    full_yearly_data.append(parse_txt_patent_data(patent,source_url = url,data_items_list=data_items))
            elif year in [2002,2003,2004]:
                patent_data = read_data_from_url_xml_2(url)
                for patent in patent_data:
                    root_tree = ElementTree(fromstring(patent))
                    full_yearly_data.append(parse_patent_data_xml_2(root_tree,source_url = url,data_items_list=data_items))
            elif year > 2004:
                patent_data = read_data_from_url_xml_4(url)
                for patent in patent_data:
                    root_tree = ElementTree(fromstring(patent))
                    full_yearly_data.append(parse_patent_data_xml_4(root_tree,source_url = url,data_items_list=data_items))
            time.sleep(30 + random.choice(range(10)))
        return full_yearly_data
    else:
        print(f'ERROR: Invalid year argument "{year}". Year must be an integer number between 1975 and 2020')
        
def download_file_to_disk(url,target_path):
    request_data = requests.get(url)
    zipped_files = zipfile.ZipFile(io.BytesIO(request_data.content))
    zipped_files.extractall(target_path)
    
def get_patent_files_by_year(year):
        list_of_files = requests.get(f'https://bulkdata.uspto.gov/data/patent/grant/redbook/fulltext/{year}/')
        page_html_text = list_of_files.text
        html_parser = BeautifulSoup(page_html_text, 'html.parser')
        href_files_list = []
        for tr in html_parser.find_all('table')[1].find_all('a'):
            if tr['href'] != None: 
                href_files_list.append(tr['href'])
        if year == 2001:
            href_files_list = list(filter(lambda x: x.endswith('.zip') and 'aps' in x, href_files_list))
        else:
            href_files_list = list(filter(lambda x: x.endswith('.zip'), href_files_list))
        return href_files_list
    
def read_and_parse_from_url(url,data_items):
        m = re.search('(?<=fulltext/)\d+', url)
        year = int(m.group(0))
        full_yearly_data = []
        if year <= 2001:
            raw_patent_data = read_data_from_url_txt(url)
            for patent in raw_patent_data:
                if 'URL' in data_items:
                    full_yearly_data.append(parse_txt_patent_data(patent,source_url = url,data_items_list=data_items))
                else:
                    full_yearly_data.append(parse_txt_patent_data(patent,data_items_list=data_items))
        elif year in [2002,2003,2004]:
            raw_patent_data = read_data_from_url_xml_2(url)
            for patent in raw_patent_data:
                root_tree = ElementTree(fromstring(patent))
                if 'URL' in data_items:
                    full_yearly_data.append(parse_patent_data_xml_2(root_tree,source_url = url,data_items_list=data_items))
                else:
                    full_yearly_data.append(parse_patent_data_xml_2(root_tree,data_items_list=data_items))
        elif year > 2004:
            raw_patent_data = read_data_from_url_xml_4(url)
            for patent in raw_patent_data:
                root_tree = ElementTree(fromstring(patent))
                if 'URL' in data_items:
                    full_yearly_data.append(parse_patent_data_xml_4(root_tree,source_url = url,data_items_list=data_items))
                else:
                    full_yearly_data.append(parse_patent_data_xml_4(root_tree,data_items_list=data_items))
        return full_yearly_data
    
def read_and_parse_file_from_disk(path_to_file,data_items,extension):
    if extension == 'txt':
        data = read_and_parse_txt_from_disk(path_to_file,data_items)
        return data
    elif extension == 'xml2':
        data = read_and_parse_xml2_from_disk(path_to_file,data_items)
        return data
    elif extension == 'xml4':
        data = read_and_parse_xml4_from_disk(path_to_file,data_items)
        return data
    
def download_yearly_data(year,data_items):
    if type(year) == int and year >= 1976: 
        list_of_files = requests.get(f'https://bulkdata.uspto.gov/data/patent/grant/redbook/fulltext/{year}/')
        page_html_text = list_of_files.text
        html_parser = BeautifulSoup(page_html_text, 'html.parser')
        href_files_list = []
        for tr in html_parser.find_all('table')[1].find_all('a'):
            if tr['href'] != None: 
                href_files_list.append(tr['href'])
        if year == 2001:
            href_files_list = list(filter(lambda x: x.endswith('.zip') and 'aps' in x, href_files_list))
        else:
            href_files_list = list(filter(lambda x: x.endswith('.zip'), href_files_list))
        full_yearly_data = []
        print(f'{len(href_files_list)} files found')
        current_file_number = 0
        for file in href_files_list:
            current_file_number += 1
            url = f'https://bulkdata.uspto.gov/data/patent/grant/redbook/fulltext/{year}/{file}'
            print(f'Parsing file {current_file_number}/{len(href_files_list)} - {url}')
            if year <= 2001:
                patent_data = read_data_from_url_txt(url)
                for patent in patent_data:
                    full_yearly_data.append(parse_txt_patent_data(patent,source_url = url,data_items_list=data_items))
            elif year in [2002,2003,2004]:
                patent_data = read_data_from_url_xml_2(url)
                for patent in patent_data:
                    root_tree = ElementTree(fromstring(patent))
                    full_yearly_data.append(parse_patent_data_xml_2(root_tree,source_url = url,data_items_list=data_items))
            elif year > 2004:
                patent_data = read_data_from_url_xml_4(url)
                for patent in patent_data:
                    root_tree = ElementTree(fromstring(patent))
                    full_yearly_data.append(parse_patent_data_xml_4(root_tree,source_url = url,data_items_list=data_items))
            time.sleep(30 + random.choice(range(10)))
        return full_yearly_data
    else:
        print(f'ERROR: Invalid year argument "{year}". Year must be an integer number greater than or equal 1976')


#for year in range(1950,1980):
for year in range(2017,1951,-1):
    print('PROCESSING YEAR: ', year)
    if (year==2017):
        file_list = ['ipg170704.zip', 'ipg170711.zip', 'ipg170718.zip', 'ipg170725.zip', 'ipg170801.zip', 'ipg170808.zip', 'ipg170815.zip', 'ipg170822.zip', 'ipg170829.zip', 'ipg170905.zip', 'ipg170912.zip', 'ipg170919.zip', 'ipg170926.zip', 'ipg171003.zip', 'ipg171010.zip', 'ipg171017.zip', 'ipg171024.zip', 'ipg171031.zip', 'ipg171107.zip', 'ipg171114.zip', 'ipg171121.zip', 'ipg171128.zip', 'ipg171205.zip', 'ipg171212.zip', 'ipg171219.zip', 'ipg171226.zip']
    else:
        file_list = get_patent_files_by_year(year)
    print(file_list)
    for file in file_list:
        url=rl = 'https://bulkdata.uspto.gov/data/patent/grant/redbook/fulltext/'+str(year)+'/'+file
        print('Processing file: ',file, ' at ',url)

        #items = ['INVT','ASSG']
        items = ['INVT']
        data = read_and_parse_from_url(url,items)
        
        jsonString = json.dumps(data)

        file_json = str(year)+file[:-4]+'.json'
        with io.open(file_json, 'w', encoding='utf8') as outfile:
            outfile.write(jsonString)
        
        #file_cvs = str(year)+file[:-4]+'.csv'
        #file_df = pd.read_json(jsonString)
        #file_df.to_csv(file_cvs, sep='\t', encoding='utf-8')


