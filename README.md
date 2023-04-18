# P-String Assembly implementation
This repository contains a complete implementation of a P-String structure, written entirely from scratch in assembly language.
The project contains the following files :
- main.c
- run_main.s
- func_select.s
- pstring.h
- pstring.s
- makefile  
# About P-String
The P-String structure provides a good example of how to implement a string data type in assembly, and demonstrates the trade-offs and challenges associated with writing code in this low-level language.
# How to compile and run the project
1. Download to your computer all the files  and put them in the same directory.
2. Open the terminal in the path of the directory you inserted all the files.
3. Use the following compile line : make 
4. use the following run line: ./a.out
# Example of running the program
5<br>
hello<br>
5<br>
world<br>
31<br>
first pstring length: 5, second pstring length: 5
#
5<br>
hello<br>
3<br>
bye<br>
32<br>
e z<br>
old char: e, new char: z, first string: hzllo, second string: byz
#
5<br>
hello<br>
3<br>
bye<br>
33<br>
z a<br>
old char: z, new char: a, first string: hello, second string: bye
#
5<br>
hello<br>
5<br>
world<br>
35<br>
1<br>
4<br>
length: 5, string: horld<br>
length: 5, string: world<br>
#
5<br>
He@lo<br>
5<br>
WORLD<br>
36<br>
length: 5, string: hE@LO<br>
length: 5, string: world<br>
#
5<br>
hello<br>
5<br>
world<br>
37<br>
1<br>
10<br>
invalid input!<br>
compare result: -2<br>
#
5<br>
hello<br>
5<br>
world<br>
99<br>
invalid option!
