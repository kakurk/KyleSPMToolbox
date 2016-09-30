#!/bin/bash

# Transfer imaging data for subject X. Takes the name of the study folder and the subject's ID as input.
# First removes existing files called "batch_transfer.txt"
# Then creates a temporary file called "batch_transfer.txt" in the pwd 
# Then sends this temporal file to sftp function and excutes the trasnfer

# Remove batch_transfer.txt

rm -f ./batch_transfer.txt


# Write out sftp commands to "batch_transfer.txt"

echo "lmkdir ./$1/Anat/$2" >> batch_transfer.txt

echo "lmkdir ./$1/Func/task1" >> batch_transfer.txt
echo "lmkdir ./$1/Func/task1/$2" >> batch_transfer.txt
echo "lmkdir ./$1/Func/task1/$2/run1" >> batch_transfer.txt
echo "lmkdir ./$1/Func/task1/$2/run2" >> batch_transfer.txt

echo "lmkdir ./$1/Func/task2" >> batch_transfer.txt
echo "lmkdir ./$1/Func/task2/$2" >> batch_transfer.txt
echo "lmkdir ./$1/Func/task2/$2/run1" >> batch_transfer.txt
echo "lmkdir ./$1/Func/task2/$2/run2" >> batch_transfer.txt

echo "get /path/to/imaging/data/on/HOTH/$2/nii/*anatwildcard*.nii ./$1/Anat/$2" >> batch_transfer.txt 
echo "get /path/to/imaging/data/on/HOTH/$2/*task1run1wildcard*.nii ./$1/Func/task1/$2/run1" >> batch_transfer.txt 
echo "get /path/to/imaging/data/on/HOTH/$2/*task1run2wildcard*.nii ./$1/Func/task1/$2/run2" >> batch_transfer.txt  
echo "get /path/to/imaging/data/on/HOTH/$2/nii/*task2run1wildcard*.nii ./$1/Func/task2/$2/run1" >> batch_transfer.txt 
echo "get /path/to/imaging/data/on/HOTH/$2/nii/*task2run2wildcard*.nii ./$1/Func/task2/$2/run2" >> batch_transfer.txt 

echo "bye" >> batch_transfer.txt

# Change the read/write/execute permissions of this newly created text file

chmod 777 batch_transfer.txt

# Launch sftp in batch mode, inputting the commands from the text file

sftp -b batch_transfer.txt PSUID@linux.imaging.psu.edu
