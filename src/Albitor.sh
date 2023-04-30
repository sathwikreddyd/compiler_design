# This is the runtime script that takes the program file as 1st argument.
# author: Rohith Reddy
# version 1.0
# date 04-29-2023
echo "Compiling the program..."
compile=$(python3 file_extract.py $1)
echo "Compilation done succesfully"
echo "Executing the Program"
swipl -s evalFile.pl -g "run_program($compile), halt."
echo "Succesfully Executed!"
