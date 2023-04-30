#!/bin/bash
# This is the file that prints the programs in the console.
# author: Srilakshmi Sravani, Vamsi Krishna Somepalli
# version 1.0
# date 04-29-2023
#!/bin/bash
echo "Compiling programs..."
first_prog=$(python3 file_extract.py ../data/code1.albi)
two_prog=$(python3 file_extract.py ../data/code2.albi)
three_prog=$(python3 file_extract.py ../data/code3.albi)
four_prog=$(python3 file_extract.py ../data/code4.albi)
five_prog=$(python3 file_extract.py ../data/code5.albi)
six_prog=$(python3 file_extract.py ../data/code6.albi)
seven_prog=$(python3 file_extract.py ../data/code7.albi)
echo "Compilation done successfully"
echo "interpreting the programs"
echo "-------------------------------------------------------"
echo "code 1 program"
echo "-------------------------------------------------------"
swipl -s evalFile.pl -g "run_program($first_prog), halt."
echo "-------------------------------------------------------"
echo "code 2 Program"
echo "-------------------------------------------------------"
swipl -s evalFile.pl -g "run_program($two_prog), halt."
echo "-------------------------------------------------------"
echo "code 3 Program"
echo "-------------------------------------------------------"
swipl -s evalFile.pl -g "run_program($three_prog), halt."
echo "-------------------------------------------------------"
echo "code 4 Program"
echo "-------------------------------------------------------"
swipl -s evalFile.pl -g "run_program($four_prog), halt."
echo "-------------------------------------------------------"
echo "code 5 Program"
echo "-------------------------------------------------------"
swipl -s evalFile.pl -g "run_program($five_prog), halt."
echo "-------------------------------------------------------"
echo "code 6 Program"
echo "-------------------------------------------------------"
swipl -s evalFile.pl -g "run_program($six_prog), halt."
echo "-------------------------------------------------------"
echo "code 7 Program"
echo "-------------------------------------------------------"
swipl -s evalFile.pl -g "run_program($seven_prog), halt."
echo "-------------------------------------------------------"
echo "Done!"