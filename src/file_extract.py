"""
    @author: Rohith Reddy, Sathwik Reddy
    @version: 1.0
    @date: 04-22-2023
    @comment: takes file name/path from command line and calls the parser and prints the generated parse tree
"""
import parser_py
import sys

def extract_file():
    x = sys.argv[1]
    f = open(x,'r')
    file_ex = f.read()
    parsed = parser_py.progaram_parser(file_ex)
    parsed = parsed.replace('Tree', 'tree')
    parsed = parsed.replace('Token', 'token')
    print(parsed)

extract_file()