#!/py36env/bin/python3.6

import mysql.connector
from tabulate import tabulate
import os


DB_SETUP_FILE = os.path.join(os.path.dirname(os.path.realpath(__file__)),
                             'sql_scripts', 'Premier.Script.sql')
ASSIGNMENT_SCRIPT = os.path.join(os.path.dirname(os.path.realpath(__file__)),
                                 'sql_scripts', 'SQL_assignment_1_script.sql')
OUTPUT_FILE = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'txt2pdf',
                           os.path.basename(ASSIGNMENT_SCRIPT).replace('.sql', '') + '_output.txt')
OUTPUT_FILE_HEADER = 'Author: Stephen Wagstaff\n' \
                     'License: Apache-2.0\n' \
                     'Version: 1.0\n' \
                     'Creation Date: Aug 09, 2018'


def __setup_db(initialization_file_path):
    try:
        _db_connect = mysql.connector.connect(host="mysql",
                                              user='wagstaff',
                                              password='mypass',
                                              database='wagstaff_INFOST_410',
                                              auth_plugin='mysql_native_password')
        input_file = open(initialization_file_path, 'r')
        query = " ".join(input_file.readlines())

        _context = _db_connect.cursor()
        _context.execute(query)
        _db_connect.close()
    except mysql.connector.Error as err:
        print(f"Database has already been setup: {err}")
    else:
        _db_connect.close()


def __execute_query_script(script_file_path):
    try:
        _db_connect = mysql.connector.connect(host="mysql",
                                              user='wagstaff',
                                              password='mypass',
                                              database='wagstaff_INFOST_410',
                                              auth_plugin='mysql_native_password')
        input_file = open(script_file_path, 'r')
        output_file = open(OUTPUT_FILE, 'w')
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

        output_file.close()
        _db_connect.close()
    except mysql.connector.Error as error:
        print(f"CONNECTION ERROR: {error}")
    else:
        output_file.close()
        _db_connect.close()


# TODO: Prompt for the assignment, determine the assignment script and output name based on an enum?
# TODO: Somehow call the txt2pdf directly from this script
input("What Assignment?")

__setup_db(DB_SETUP_FILE)

__execute_query_script(ASSIGNMENT_SCRIPT)
