#ifndef SSP_HTTP_H
#define SSP_HTTP_H
#include "ssp_eeprom.h"

typedef struct {
  char *buf;
  int bufsize;
  int index;
  int sock;
} obuf_t;

typedef struct {
  char *string;
  int string_len;
  char *name;
  int value;
  int size;
  int minval;
  int maxval;
  int zeros;
  int type;
  int flags;
} form_field_t;

#define FLD_TYPE_UD 1
#define FLD_TYPE_UH 2
#define FLD_TYPE_STR 3

#define FLD_FLAG_ERR 1
#define FLD_FLAG_LEFT 2

extern char *ntoa( int value, int radix, int zeros );
extern void process_http(int sock, char*recv_buf, char*send_buf);
extern void obuf_flush( obuf_t *obuf );
extern void obuf_write( obuf_t *obuf, char *txt );
extern void obuf_bwrite( obuf_t *obuf, char *txt, int nb );
extern int field_init( form_field_t *fld, char *name, int str_len, int type,
                int size, int minval, int maxval, int zeros, int flags );
extern int f_string( form_field_t *fld, char *s );
extern int f_number( form_field_t *fld, unsigned int val );
extern int fields_init(SSP_Config_t *cfg);
extern void fields_update(SSP_Config_t *cfg);
void url_decode( char *in );

#define RECV_BUFFER_LENGTH 1460
#define SEND_BUFFER_LENGTH 1460

#endif
