# Makefile of libmaxheap.so
#

CC = gcc
CFLAGS = -Wall -fPIC -O2 -m64
OBJS = array.o maxheap.o
TARGET_LIB = libmaxheap.so

all: libmaxheap test_heap test_array

libmaxheap:$(OBJS)
	$(CC) -shared -fPIC $(CFLAGS) -o $(TARGET_LIB) $(OBJS)

test_heap:$(TARGET_LIB) test_heap.o
	$(CC) -o $@ $(CFLAGS) test_heap.c $(TARGET_LIB)

test_array:$(TARGET_LIB) test_array.o
	$(CC) -o $@ $(CFLAGS) test_array.c $(TARGET_LIB)

%.o:%.c
	$(CC) -c $(CFLAGS) $<

install: $(TARGET_LIB)
	cp $< /usr/local/lib

.PHONY:clean
clean:
	rm -f *.o $(TARGET_LIB) test_array test_heap
