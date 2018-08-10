#! /usr/bin/env python3.6
import mysql.connector
from argparse import Namespace
from tabulate import tabulate
from txt2pdf.txt2pdf import PDFCreator, Margins
import os

AUTHOR = 'Stephen Wagstaff'
SUBJECT = 'INFOST 410 SQL Assignment'
TITLE = 'INFOST 410 SQL Assignment'
OUTPUT_FILE_HEADER = f'Author: {AUTHOR}\n' \
                     'License: Apache-2.0\n' \
                     'Version: 1.0\n' \
                     'Creation Date: Aug 09, 2018'

DB_AUTH_DICTIONARY = {'host': 'mysql',
                      'user': 'wagstaff',
                      'password': 'mypass',
                      'database': 'wagstaff_INFOST_410'}

FILE_DICTIONARY = {1: {'script_path': os.path.join(os.path.dirname(os.path.realpath(__file__)),
                                                   'sql_scripts', 'SQL_assignment_1_script.sql'),
                       'output_path': os.path.join(os.path.dirname(os.path.realpath(__file__)),
                                                   'output_files', 'SQL1.' + AUTHOR.replace(' ', '') + '.txt')},
                   2: {'script_path': os.path.join(os.path.dirname(os.path.realpath(__file__)),
                                                   'sql_scripts', 'SQL_assignment_2_script.sql'),
                       'output_path': os.path.join(os.path.dirname(os.path.realpath(__file__)),
                                                   'output_files', AUTHOR.replace(' ', '') + '.SQL.A2.txt')},
                   3: {'script_path': os.path.join(os.path.dirname(os.path.realpath(__file__)),
                                                   'sql_scripts', 'SQL_assignment_3_script.sql'),
                       'output_path': os.path.join(os.path.dirname(os.path.realpath(__file__)),
                                                   'output_files', AUTHOR.replace(' ', '') + '.SQL.A3.txt')}}

DB_SETUP_FILE = os.path.join(os.path.dirname(os.path.realpath(__file__)),
                             'sql_scripts', 'Premier.Script.sql')


def __setup_db(initialization_file_path):
    try:
        _db_connect = mysql.connector.connect(host=DB_AUTH_DICTIONARY['host'],
                                              user=DB_AUTH_DICTIONARY['user'],
                                              password=DB_AUTH_DICTIONARY['password'],
                                              database=DB_AUTH_DICTIONARY['database'],
                                              auth_plugin='mysql_native_password')
        input_file = open(initialization_file_path, 'r')
        query = " ".join(input_file.readlines())

        _context = _db_connect.cursor()
        _context.execute(query)
    except mysql.connector.Error as err:
        print(f"Database has already been setup: {err}")
        return False
    except Exception as err:
        print(f"Database has already been setup: {err}")
        return False
    else:
        _db_connect.close()
        return True


def __execute_sql_script(script_path, output_path):
    try:
        _db_connect = mysql.connector.connect(host=DB_AUTH_DICTIONARY['host'],
                                              user=DB_AUTH_DICTIONARY['user'],
                                              password=DB_AUTH_DICTIONARY['password'],
                                              database=DB_AUTH_DICTIONARY['database'],
                                              auth_plugin='mysql_native_password')
        input_file = open(script_path, 'r')
        output_file = open(output_path, 'w')
        output_file.write(OUTPUT_FILE_HEADER)
        query_set = " ".join(input_file.readlines())
        query_set = query_set.split('\n \n')
        _context = _db_connect.cursor()
        for query in query_set:
            query = query.replace('\n', ' ')
            query = query.replace('**/', '**/\n')
            output_file.write(f'\n\n{query}\n')
            _context.execute(query)
            try:
                output_file.write(tabulate(_context.fetchall(), headers=_context.column_names, tablefmt='psql'))
            except mysql.connector.Error:
                output_file.write('No Output')

    except mysql.connector.Error as error:
        print(f"CONNECTION ERROR: {error}")
        return False
    else:
        output_file.close()
        _db_connect.close()
        return True


def __create_pdf_output(txt_path, pdf_path):
    args = Namespace(filename=txt_path,
                     font='Courier',
                     font_size=10.0,
                     extra_vertical_space=0.0,
                     kerning=0.0,
                     media='A4',
                     minimum_page_length=10,
                     landscape=False,
                     margin_left=2.0,
                     margin_right=2.0,
                     margin_top=2.0,
                     margin_bottom=2.0,
                     output=pdf_path,
                     author=AUTHOR,
                     title=TITLE,
                     quiet=False,
                     subject=SUBJECT,
                     keywords='',
                     break_on_blanks=False,
                     encoding='utf8',
                     line_numbers='',
                     page_numbers='')

    PDFCreator(args, Margins(
        args.margin_right,
        args.margin_left,
        args.margin_top,
        args.margin_bottom)).generate()
    os.remove(txt_path)


def run_main():
    user_selection = 0
    while True:
        try:
            user_selection = int(input("\nWhat Assignment (1, 2, or 3)? "))
        except ValueError:
            print('Please enter a valid number value.')

        if 0 < user_selection < 4:
            break

    __setup_db(DB_SETUP_FILE)

    if __execute_sql_script(FILE_DICTIONARY[user_selection]['script_path'],
                            FILE_DICTIONARY[user_selection]['output_path']):

        __create_pdf_output(FILE_DICTIONARY[user_selection]['output_path'],
                            FILE_DICTIONARY[user_selection]['output_path'].replace('.txt', '.pdf'))


if __name__ == '__main__':
    run_main()
