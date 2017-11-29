#ifndef _MAX_HEAP_H
#define _MAX_HEAP_H

#include "array.h"
#include <stdint.h>

typedef int (*compare)(const void *, const void *);
typedef void *(*copy)(void *, const void *);
typedef void (*swap)(void *, void *);

typedef struct maxheap_t {
    uint32_t    len;        /* length of maxheap, might be less than the actual size of array. */
    struct array_t     *array;     /* dynamic array for storing the elements of maxheap */
    compare     comp;       /* customized comparator */
    copy        cpy;        /* customized copy operator */
    swap        swp;        /* customized swap operator */
} maxheap_t;

struct maxheap_t *maxheap_create(uint32_t, size_t, compare, copy, swap);
void maxheap_free(maxheap_t*);
int maxheap_push(maxheap_t*, const void *);
void *maxheap_pop(maxheap_t*);
void *maxheap_min(maxheap_t*);

#endif
