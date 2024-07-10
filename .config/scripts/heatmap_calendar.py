import pdb
import random
import datetime
import calendar
import argparse
from pprint import pprint


# TODO: this is awful code, please implement a proper calendar class

rgb_bg = lambda r,g,b: f'\033[48;2;{r};{g};{b}m'
reset = '\033[0m'
paint_green = lambda green_hue, string :f'{rgb_bg(0,green_hue,0)}{string}{reset}'  

if __name__ == '__main__':
    start_date = datetime.date(2024, 1, 1)
    end_date = datetime.date(2024, 12, 31)
    date_list = [start_date + datetime.timedelta(days=x) for x in range((end_date - start_date).days + 1)]
    year_heatmap = [[]]
    current_week = year_heatmap[0]
    for date in date_list:
        iso_year, week_of_year, iso_weekday = date.isocalendar()
        if iso_weekday % 7 == 0:
            year_heatmap.append([])
            current_week = year_heatmap[-1]
        current_week.append(date)

    year_heatmap = [[f'{rgb_bg(0,random.randrange(1,100),0)}{day.isoformat()}.md{reset}' for day in week] for week in year_heatmap]
    lines = [' '.join(week) for week in year_heatmap]
    lines[0] = lines[0].rjust(len(lines[1]),' ')
    print('\n'.join(lines))


# def read_properties(filepath,delimiter='---\n'):
#     properties = {}
#     cur_line = None
#     with open(filepath) as f:
#         assert f.readline() == delimiter, "Properties section delimiter wasn't found in the file's first line"
#         while True:
#             cur_line = f.readline()
#             if cur_line == delimiter:
#                 break
#             key,value = cur_line.replace('\n','').split(': ')
#             properties[key] = int(value)
#     return properties
# 
# 
# def paint_day(day,property_name,month,year,saturation):
#     path = f'/Users/user/Obsidian/marco_vault/001_journal/{year}-{month}-{day}.md'
# 
#     try: 
#         assert day != '00', "day is invalid"
#         properties = read_properties(path)
#     except AssertionError:
#         return paint_green(0,day)
#     except Exception as e:
#         raise e
# 
#     property_value = properties.get(property_name,0)
#     green_hue = min(property_value * saturation,255)
#     return paint_green(green_hue,day)
# 
# 
# parser = argparse.ArgumentParser()
# parser.add_argument('property_name', type=str, nargs='?', default='meditation')
# parser.add_argument('saturation', type=int, nargs='?', default=5)
# args = parser.parse_args()
# 
# current_date = datetime.date.today()
# calendar_array = calendar.TextCalendar().monthdayscalendar(current_date.year,current_date.month)
# calendar_array_as_string = [[str(day).zfill(2) for day in col] for col in calendar_array]
# calendar_array_as_string_painted = [[paint_day(day,args.property_name,str(current_date.month).zfill(2),current_date.year,args.saturation) for day in col] for col in calendar_array_as_string]
# 
# calendar_header = '\n'.join(calendar.month(current_date.year,current_date.month).split('\n')[:2])
# print(calendar_header)
# [print(' '.join(col)) for col in calendar_array_as_string_painted]
