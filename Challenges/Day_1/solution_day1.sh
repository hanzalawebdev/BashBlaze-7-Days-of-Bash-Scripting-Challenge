# Task 1: Comments
<< comment
    This script demonstrates how to use comments in bash.
comment


# Task 2: Echo
echo "Hello World!"


# Task 3: Declaring Variables
text="Declare Variable"
echo "$text"


# Task 4: Using Variables to Perform Arithmetic
a=5
b=3
sum=$((a+b))
echo "The sum is $sum"


# Task 5: Using Built-in Variables
echo "Exit status of the last command: $?"
echo "Process ID of the current script: $$"
echo "Current working directory: $PWD"
echo "Home directory: $HOME"


# Task 6: Wildcards
echo "List all .sh files in the current directory:"
ls *.sh
