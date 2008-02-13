#include <sys/time.h>
#include <time.h>
#include <unistd.h>
#include <stdio.h>

int main( int argc, char **argv ) {
  struct timeval t0, t1;
  int i;
  
  gettimeofday(&t0, NULL);
  for ( i = 0; i < 8; i++ ) {
    sleep(1);
    gettimeofday(&t1, NULL);
    t1.tv_sec -= t0.tv_sec;
    if ( t1.tv_usec < t0.tv_usec ) {
      --t1.tv_sec;
      t1.tv_usec += 1000000L;
    }
    t1.tv_usec -= t0.tv_usec;
    printf( "elapsed = %ld.%06ld\n", t1.tv_sec, t1.tv_usec );
  }
  return 0;
}
