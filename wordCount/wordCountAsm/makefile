# make clean - removes all .o and executable files
# Select Compiler
CC = gcc

# compiler flags:
CFLAGS = -g -Wall

# All the source Files
SRCS = mywc.s

# ALL object source files from SRCS
OBJS = $(SRCS:.c=.o)

# dependencies from objs
-include $(OBJS:.o=.d)

# command makes makefile ignore any 
# files named clean 
.PHONY: clean

# executable file
EXEC = mywc

ALL: $(EXEC)
#link files
$(EXEC): $(OBJS)
		$(CC) $(CFLAGS) -o $(EXEC) $(OBJS)
#Compile Files
.c.o:
		$(CC) $(CFLAGS) -c $< -o $@
		$(CC) -MM $(CFLAGS) *.c > $*.d
#Delete .o and exec files
clean:
		$(RM) *.o *~ $(EXEC)
