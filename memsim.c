#include <stdio.h>
#include <string.h>
#include <stdlib.h> 
#include <limits.h>
#include <time.h>

typedef struct {
        int pageNo;
        int modified;
} page;
enum repl { REPL_RAND, REPL_FIFO, REPL_LRU, REPL_CLOCK };
int     createMMU( int);
int     checkInMemory( int ) ;
int     allocateFrame( int ) ;
page    selectVictim( int, enum repl) ;
const   int pageoffset = 12;            /* Page size is fixed to 4 KB */
int     numFrames ;


typedef struct {
	int  pageNum;                		// resident page number
	int  loaded;                 		// 0/1: is a page loaded
    int  modified;              		// 0/1: dirty bit
    int  reference;                 	// REPL_CLOCK reference bit
    unsigned long long arrival_time;   	// for REPL_FIFO
    unsigned long long last_used; 		// for REPL_LRU
} frame;

static frame *frame_table = NULL;          	// frame table
static int    mmu_num_frames = 0;
static int    next_free   = 0;        	// index of next unused frame
static int    clock_h  = 0;        	// for REPL_CLOCK algorithm
static unsigned long long current_tick = 0; 	// counter (REPL_LRU/REPL_FIFO)

/* Creates the page table structure to record memory allocation */
int     createMMU (int frames)
{
	if (frame_table)
	{
		// If frame table already exists, free previous frame table for re-initiation.
		free(frame_table);
		frame_table = NULL;
	}

	frame_table = (frame *)calloc((size_t)frames, sizeof(frame));

	mmu_num_frames 	= frames;
    next_free      	= 0;
    clock_h    		= 0;
    current_tick	= 0;

    return 0;
}

/* Checks for residency: returns frame no or -1 if not found */
int     checkInMemory( int page_number)
{   
	for (int i = 0; i < mmu_num_frames; i++)
	{
		if (frame_table[i].loaded)
		{
			if (frame_table[i].pageNum == page_number)
			{
				// There has been a hit for frame_table[i];
				frame_table[i].last_used = ++current_tick;
				frame_table[i].reference = 1;
				return i;
			}
		}
	}
    return -1;
}

/* allocate page to the next free frame and record where it put it */
int     allocateFrame( int page_number)
{
    if (next_free >= mmu_num_frames) 
	{
		return -1; // no frames left
	}

	int unused_frame = next_free++;

	frame_table[unused_frame].loaded 		= 1;
	frame_table[unused_frame].pageNum       = page_number;
    frame_table[unused_frame].modified      = 0;
    frame_table[unused_frame].reference     = 1;
    frame_table[unused_frame].arrival_time  = ++current_tick;
    frame_table[unused_frame].last_used     = current_tick; 

    return unused_frame;
}

static int lru()
{
	int result = -1;

	for (int i = 0; i < mmu_num_frames; i++)
	{
		if (result == -1 || frame_table[i].last_used < frame_table[result].last_used)
		{
			result = i;
		}
	}
	return result;
}

static int fifo() 
{
	int oldest = 0;
	for (int i=1; i<mmu_num_frames; i++) {
		if (frame_table[i].arrival_time < frame_table[oldest].arrival_time) {
			oldest = i;
		}
	}
	return 0;
}

static int rando()
{
	// only get frames which are loaded
	int loadedFrames[mmu_num_frames];
	int count = 0;
	for (int i=0; i<mmu_num_frames; i++) {
		if (frame_table[i].loaded) {
			loadedFrames[count++] = i;
		}
	}

	if (count == 0) return 0; // no loaded frames

	int killIndex = rand() % count;
	return loadedFrames[killIndex];
}

static int _clock() // renamed from clock() to allow inclusion of time.h library
{
    if (mmu_num_frames == 0) return 0;

    for (;;) {
        // only consider loaded frames
        if (frame_table[clock_h].loaded) {
            if (frame_table[clock_h].reference == 0) {
                int victim = clock_h;
                clock_h = (clock_h + 1) % mmu_num_frames;
                return victim;
            }
            // give a second chance
            frame_table[clock_h].reference = 0;
        }
        clock_h = (clock_h + 1) % mmu_num_frames;
    }
}

/* Selects a victim for eviction/discard according to the replacement algorithm,  returns chosen frame_no  */
page selectVictim(int page_number, enum repl mode)
{
    page    victim;
	int		result;

	if (mode == REPL_LRU)
	{
		result = lru();
	} else if (mode == REPL_CLOCK)
	{
		result = _clock();
	} else if (mode == REPL_FIFO)
	{
		result = fifo();
	} else {
		result = rando();
	}
    
    victim.pageNo = frame_table[result].pageNum;
    victim.modified = frame_table[result].modified;

	frame_table[result].loaded       = 1;
    frame_table[result].pageNum      = page_number;
    frame_table[result].modified     = 0;
    frame_table[result].reference    = 1;
    frame_table[result].arrival_time = ++current_tick;
    frame_table[result].last_used    = current_tick;

    return (victim);
}

		
int main(int argc, char *argv[])
{
	srand(time(NULL));

	char	*tracename;
	int	page_number,frame_no, done ;
	int	do_line, i;
	int	no_events, disk_writes, disk_reads;
	int     debugmode;
 	enum	repl  replace;
	int	allocated=0; 
	int	victim_page;
        unsigned address;
    	char 	rw;
	page	Pvictim;
	FILE	*trace;


        if (argc < 5) {
             printf( "Usage: ./memsim inputfile numberframes replacementmode debugmode \n");
             exit ( -1);
	}
	else {
        tracename = argv[1];	
	trace = fopen( tracename, "r");
	if (trace == NULL ) {
             printf( "Cannot open trace file %s \n", tracename);
             exit ( -1);
	}
	numFrames = atoi(argv[2]);
        if (numFrames < 1) {
            printf( "Frame number must be at least 1\n");
            exit ( -1);
        }
        if (strcmp(argv[3], "REPL_LRU\0") == 0)
            replace = REPL_LRU;
	    else if (strcmp(argv[3], "rand\0") == 0)
	     replace = REPL_RAND;
	          else if (strcmp(argv[3], "REPL_CLOCK\0") == 0)
                       replace = REPL_CLOCK;		 
	               else if (strcmp(argv[3], "REPL_FIFO\0") == 0)
                             replace = REPL_FIFO;		 
        else 
	  {
             printf( "Replacement algorithm must be rand/REPL_FIFO/REPL_LRU/REPL_CLOCK  \n");
             exit ( -1);
	  }

        if (strcmp(argv[4], "quiet\0") == 0)
            debugmode = 0;
	else if (strcmp(argv[4], "debug\0") == 0)
            debugmode = 1;
        else 
	  {
             printf( "Replacement algorithm must be quiet/debug  \n");
             exit ( -1);
	  }
	}
	
	done = createMMU (numFrames);
	if ( done == -1 ) {
		 printf( "Cannot create MMU" ) ;
		 exit(-1);
        }
	no_events = 0 ;
	disk_writes = 0 ;
	disk_reads = 0 ;

        do_line = fscanf(trace,"%x %c",&address,&rw);
	while ( do_line == 2)
	{
		page_number =  address >> pageoffset;
		frame_no = checkInMemory( page_number) ;    /* ask for physical address */

		if ( frame_no == -1 )
		{
		  disk_reads++ ;			/* Page fault, need to load it into memory */
		  if (debugmode) 
		      printf( "Page fault %8d \n", page_number) ;
		  if (allocated < numFrames)  			/* allocate it to an empty frame */
		   {
                     frame_no = allocateFrame(page_number);
		     allocated++;
                   }
                   else{
		      Pvictim = selectVictim(page_number, replace) ;   /* returns page number of the victim  */
		      frame_no = checkInMemory( page_number) ;    /* find out the frame the new page is in */
		   if (Pvictim.modified)           /* need to know victim page and modified  */
	 	      {
                      disk_writes++;			    
                      if (debugmode) printf( "Disk write %8d \n", Pvictim.pageNo) ;
		      }
		   else
                      if (debugmode) printf( "Discard    %8d \n", Pvictim.pageNo) ;
		   }
		}
		if ( rw == 'R'){
		    if (debugmode) printf( "reading    %8d \n", page_number) ;
		}
		else if ( rw == 'W'){
		    // mark page in page table as written - modified  
		    if (debugmode) printf( "writting   %8d \n", page_number) ;
			int check = checkInMemory(page_number);
			if (check >= 0) {
				frame_table[check].modified = 1;
			}
		}
		 else {
		      printf( "Badly formatted file. Error on line %d\n", no_events+1); 
		      exit (-1);
		}

		no_events++;
        	do_line = fscanf(trace,"%x %c",&address,&rw);
	}

	printf( "total memory frames:  %d\n", numFrames);
	printf( "events in trace:      %d\n", no_events);
	printf( "total disk reads:     %d\n", disk_reads);
	printf( "total disk writes:    %d\n", disk_writes);
	printf( "page fault rate:      %.4f\n", (float) disk_reads/no_events);
}
				
