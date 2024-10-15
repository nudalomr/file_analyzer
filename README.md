# file_analyzer
This repo contains a script for Scripting Class
Mark Nudalo

Description: 

I wanted to create a script that could be of use for CTF or forensics. The main job of this analyzer is to tackle a folder full of files (imagine 10,000+), divide them into images, video, and others (text files and any other filetype that are not images or video) and then create simple chain of custody. When I say simple, I'm talking about hashing of files and creating an evidence number for each copy. The evidence number is randomized and this was done mainly for accessibility reasons. 

Future work that could be added:
1. Ask user for their Identification to improve chain of custody.
2. Create a better report text file that includes the hash number of the original files being copied, not just the copied files.
3. Add functionalities like Automatically using the $ file linux command. This command, which is available on Linux terminal can determine whether a file name is really what they say they are. One can name another file with a .jpg extension even though it is not an image.

REQUIREMENTS:
  - This script was written for linux terminal in mind.
  - I have provided some test files inside the USB-Content folder. Please download all of them.
  - The following are checks that you can do to test the script.
      1. $./file_analyzer.sh 
            - no options
            - expect an error
    2. $./file_analyzer.sh -
            - incorrect options or just "-"
            - expect an error
    3. $./file_analyzer.sh -h 
            - no source directory
            - expect an error
    4. Wrong path for source directory
            - /homeee instead of /home for example 
            - should see an error message
    5. Using -v, -i, and -a option should work
    6. Using -s option should only work with another option
            - (-as, -vs, -s)
    7. -s option should work after or before other options
            - ( -s -a... or -a -s...)
    8. -s option by itelf shouldn't work.

NOTE: USE the randomize evidence number with the tab feature for easy and quick access to a file or folder/directory. 
