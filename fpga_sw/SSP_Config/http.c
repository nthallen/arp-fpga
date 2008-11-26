#include "config.h"
#include <string.h>
#include <lwip/sockets.h>
#include <ctype.h>
#include <malloc.h>
#include "http.h"
#include "ssp_print.h"
#include "ssp_eeprom.h"
#include "daslogo_jpg.h"

void obuf_flush( obuf_t *obuf ) {
  int bytes_written = lwip_send(obuf->sock, obuf->buf, obuf->index, 0);
  if ( bytes_written <= 0 )
    report_error( "obuf_flush: Error from lwip_send", "\002\003\001" );
  else if (bytes_written != obuf->index)
    report_error( "obuf_flush: short write", "\002\003\002" );
  obuf->index = 0;
}

void obuf_bwrite( obuf_t *obuf, char *txt, int nb ) {
  while ( nb > 0 ) {
    int free = obuf->bufsize - obuf->index;
    int nbf = free < nb ? free : nb;
    memcpy( &obuf->buf[obuf->index], txt, nbf );
    nb -= nbf;
    txt += nbf;
    obuf->index += nbf;
    if (obuf->index == obuf->bufsize) obuf_flush(obuf);
  }
}

void obuf_write( obuf_t *obuf, char *txt ) {
  int nb = strlen(txt);
  obuf_bwrite( obuf, txt, nb );
}

void val_error_start( obuf_t *obuf ) {
  obuf_write( obuf, "<p class=\"invalid\">" );
}

int val_error_end( obuf_t *obuf ) {
  obuf_write( obuf, "</p>\r\n" );
  return 2;
}

// returns 2
int val_error( obuf_t *obuf, char *txt ) {
  val_error_start(obuf);
  obuf_write( obuf, txt );
  return val_error_end(obuf);
}

// returns 2
int val_badvar( obuf_t *obuf, char *var ) {
  val_error_start(obuf);
  obuf_write( obuf, "Unrecognized variable name encountered: &ldquo;" );
  obuf_write( obuf, var ); //### This should be html-quoted
  obuf_write( obuf, "&rdquo;" );
  return val_error_end(obuf);
}

form_field_t fld_SN;
typedef struct {
  form_field_t Y, M, D;
} form_date_t;
form_date_t fld_FAB;
form_date_t fld_CFG;
form_field_t fld_MA[6];
form_field_t fld_IP[4];
form_field_t fld_NM[4];
form_field_t fld_GW[4];
form_field_t fld_NT;

// Should be called only once on startup.
// Allocates space for field structures.
// Return non-zero if any init fails
int fields_init( SSP_Config_t *cfg ) {
  int i, rv = 0;
  if ( field_init( &fld_SN, "SN", 6, FLD_TYPE_UD, 3, 0, 65535, 3, FLD_FLAG_LEFT ) ||
       field_init( &fld_FAB.Y, "FY", 4, FLD_TYPE_UD, 4, 2008, 2100, 1, 0 ) ||
       field_init( &fld_FAB.M, "FM", 2, FLD_TYPE_UD, 2, 1, 12, 2, 0 ) ||
       field_init( &fld_FAB.D, "FD", 2, FLD_TYPE_UD, 2, 1, 31, 2, 0 ) ||
       field_init( &fld_CFG.Y, "CY", 4, FLD_TYPE_UD, 4, 2008, 2100, 1, 0 ) ||
       field_init( &fld_CFG.M, "CM", 2, FLD_TYPE_UD, 2, 1, 12, 2, 0 ) ||
       field_init( &fld_CFG.D, "CD", 2, FLD_TYPE_UD, 2, 1, 31, 2, 0 ) ||
       field_init( &fld_NT, "NT", 80, FLD_TYPE_STR, 40, 0, 0, 0, FLD_FLAG_LEFT ) )
    rv = 1;
  for (i = 0; i < 6; i++ ) {
    char *name = strdup("MAn");
    name[2] = i+'0';
    if ( field_init( &fld_MA[i], name, 2, FLD_TYPE_UH, 2, 0, 255, 2, 0 ) )
      rv = 1;
  }
  for ( i = 0; i < 4; i++ ) {
    char *name = strdup("IPn");
    name[2] = i+'0';
    if ( field_init( &fld_IP[i], name, 3, FLD_TYPE_UD, 3, 0, 255, 1, 0 ))
      rv = 1;
  }
  for ( i = 0; i < 4; i++ ) {
    char *name = strdup("NMn");
    name[2] = i+'0';
    if ( field_init( &fld_NM[i], name, 3, FLD_TYPE_UD, 3, 0, 255, 1, 0 ))
      rv = 1;
  }
  for ( i = 0; i < 4; i++ ) {
    char *name = strdup("GWn");
    name[2] = i+'0';
    if ( field_init( &fld_GW[i], name, 3, FLD_TYPE_UD, 3, 0, 255, 1, 0 ))
      rv = 1;
  }
  if ( rv ) {
  	report_error("fields_init: out of memory", "\002\003\004" );
	  return rv;
  }
  if ( f_number( &fld_SN, cfg->serial ) ||
       f_number( &fld_FAB.Y, cfg->fab_date.year ) ||
       f_number( &fld_FAB.M, cfg->fab_date.month ) ||
       f_number( &fld_FAB.D, cfg->fab_date.day ) ||
       f_number( &fld_CFG.Y, cfg->cfg_date.year ) ||
       f_number( &fld_CFG.M, cfg->cfg_date.month ) ||
       f_number( &fld_CFG.D, cfg->cfg_date.day ) ||
       f_string( &fld_NT, cfg->notes ) )
    rv = 1;
  for (i = 0; i < 6; i++ )
    if ( f_number( &fld_MA[i], cfg->net_cfg.mac_address[i] ) )
      rv = 1;
  for ( i = 0; i < 4; i++ ) {
    if ( f_number( &fld_IP[i], cfg->net_cfg.ip_address[i] ) ||
         f_number( &fld_NM[i], cfg->net_cfg.ip_netmask[i] ) ||
         f_number( &fld_GW[i], cfg->net_cfg.ip_gateway[i] ) )
      rv = 1;
  }
  if ( rv )
    report_error( "fields_init validation", "\002\003\005" );
  return 0;
}

// Updates field structures with numbers from configuration.
// It may make sense for this to be called only once on startup, or possibly on request.
void fields_update( SSP_Config_t *cfg ) {
  int i;
  cfg->serial = fld_SN.value;
  cfg->fab_date.year = fld_FAB.Y.value;
  cfg->fab_date.month = fld_FAB.M.value;
  cfg->fab_date.day = fld_FAB.D.value;
  cfg->cfg_date.year = fld_CFG.Y.value;
  cfg->cfg_date.month = fld_CFG.M.value;
  cfg->cfg_date.day = fld_CFG.D.value;
  strcpy( cfg->notes, fld_NT.string );
  for (i = 0; i < 6; i++ )
  	cfg->net_cfg.mac_address[i] = fld_MA[i].value;
  for ( i = 0; i < 4; i++ ) {
  	cfg->net_cfg.ip_address[i] = fld_IP[i].value;
  	cfg->net_cfg.ip_netmask[i] = fld_NM[i].value;
  	cfg->net_cfg.ip_gateway[i] = fld_GW[i].value;
  }
}

// field_init allocates the specified string space
// returns non-zero if memory allocation failed
int field_init( form_field_t *fld, char *name, int str_len, int type,
                  int size, int minval, int maxval, int zeros, int flags  ) {
  fld->string = malloc(str_len+1);
  fld->string_len = str_len;
  fld->name = name;
  fld->type = type;
  fld->size = size;
  fld->minval = minval;
  fld->maxval = maxval;
  fld->zeros = zeros;
  fld->flags = flags & (FLD_FLAG_LEFT);
  return(fld->string == NULL);
}

#define MAX_ESCAPE 30
void param_output( obuf_t *obuf, char *param, char *value ) {
	char escape[MAX_ESCAPE], *esc;
	int i = 0;
  obuf_write( obuf, " " );
  obuf_write( obuf, param );
  obuf_write( obuf, "=\"" );
  // html escape value
  for ( i = 0; ; ++value ) {
  	esc = NULL;
  	switch (*value) {
  		case '&': esc = "&amp;"; break;
  		case '"': esc = "&quot;"; break;
  		case '\'': esc = "&apos;"; break;
  		case '>': esc = "&gt;"; break;
  		case '<': esc = "&lt;"; break;
  		default: break;
  	}
  	if ( ( esc && i ) || (i+1 == MAX_ESCAPE) || (i && *value == '\0') ) {
			escape[i] = '\0';
			obuf_write(obuf, escape);
			i = 0;
  	}
  	if ( *value == '\0' ) break;
  	else if ( esc ) obuf_write(obuf, esc );
  	else escape[i++] = *value;
  }
  obuf_write( obuf, "\"" );
}

void field_output( obuf_t *obuf, form_field_t *fld ) {
  char *class;
  obuf_write( obuf, "<input type=\"text\"" );
  switch ( fld->flags & (FLD_FLAG_ERR|FLD_FLAG_LEFT) ) {
    case FLD_FLAG_ERR: class = "err"; break;
    case FLD_FLAG_LEFT: class = "l"; break;
    case FLD_FLAG_ERR|FLD_FLAG_LEFT: class = "l err"; break;
    default: class = NULL; break;
  }
  if ( class ) param_output( obuf, "class", class );
  param_output( obuf, "name", fld->name );
  if ( fld->size > 0 )
    param_output( obuf, "size", ntoa(fld->size,10,1) );
  param_output( obuf, "value", fld->string );
  obuf_write( obuf, ">" );
}

void date_output( obuf_t *obuf, form_date_t *date ) {
  field_output( obuf, &date->M );
  obuf_write( obuf, " / " );
  field_output( obuf, &date->D );
  obuf_write( obuf, " / " );
  field_output( obuf, &date->Y );
}

void ipflds_output( obuf_t *obuf, char *heading, form_field_t *fld ) {
  int i;
  obuf_write( obuf, "<tr><th>" );
  obuf_write( obuf, heading );
  obuf_write( obuf, ":</th>\r\n" );
  obuf_write( obuf, "  <td>" );
  field_output( obuf, &fld[0] );
  for ( i = 1; i < 4; i++ ) {
    obuf_write( obuf, " .\r\n      " );
    field_output( obuf, &fld[i] );
  }
  obuf_write( obuf, "</td></tr>\r\n" );
}

// f_string() strips leading and trailing whitespace and checks to make sure the string fits
// in the specified field. Returns non-zero on error
int f_string( form_field_t *fld, char *s ) {
	int i;
  fld->flags &= ~FLD_FLAG_ERR;
  while ( isspace(*s) ) s++;
  i = strlen(s);
  while ( i > 0 && isspace(s[i-1]))
    s[--i] = '\0';
  strncpy( fld->string, s, fld->string_len );
  fld->string[fld->string_len] = '\0';
  if ( i > fld->string_len ) {
    fld->flags |= FLD_FLAG_ERR;
    return 2;
  }
  fld->value = 0;
  switch ( fld->type ) {
    case FLD_TYPE_UD:
      for ( s = fld->string; isdigit(*s); ++s ) {
        fld->value = fld->value * 10 + *s - '0';
      }
      break;
    case FLD_TYPE_UH:
      for ( s = fld->string; isxdigit(*s); ++s ) {
        fld->value = fld->value * 16 + tolower(*s) +
          (isdigit(*s) ? 0 - '0' : 10 - 'a');
      }
      break;
    case FLD_TYPE_STR:
    default:
      break;
  }
  switch ( fld->type ) {
    case FLD_TYPE_UD:
    case FLD_TYPE_UH:
      if ( fld->value < fld->minval || fld->value > fld->maxval ) {
        fld->flags |= FLD_FLAG_ERR;
        return 2;
      }
      break;
    default:
      break;
  }
  return 0;
}

#define F_NUM_STRMAX 20
char *ntoa( int value, int radix, int zeros ) {
  static char str[F_NUM_STRMAX];
  int i = F_NUM_STRMAX;
  int digits = 0;
  unsigned int n = value;
  
  str[i] = '\0';
  while ( n != 0 && i > 0 ) {
    int d = n % radix;
    str[--i] = d >= 10 ? d - 10 + 'A' : d + '0';
    ++digits;
    n /= radix;
  }
  while ( digits < zeros && i > 0 ) {
    str[--i] = '0';
    ++digits;
  }
  return str+i;
}

// Convert value to a string using fld's definition (type, zeros)
// Invoke f_string() with the resulting string. This will convert it back to a number
// If no error, verify that the number is equal to the input and flag an error if so
int f_number( form_field_t *fld, unsigned int value ) {
  char *s = ntoa(value, fld->type == FLD_TYPE_UD ? 10 : 16, fld->zeros );
  if ( ! f_string( fld, s ) && fld->value != value)
    fld->flags |= FLD_FLAG_ERR;
  return fld->flags & FLD_FLAG_ERR;
}

// Return 0 if no errors
// Return 2 if there are validation errors
int macaddr_in( obuf_t *obuf, int index, char *value ) {
  int ival = 0;
  // Index was checked before calling, but just to make sure...
  if ( index < 0 || index > 5 )
    return val_error( obuf, "Invalid Mac Addr variable index" );
  return f_string( fld_MA+index, value );
}

// Return 0 if no errors
// Return 2 if there are validation errors
// Won't report errors verbosely here because they may be repetetive.
int ipaddr_in( obuf_t *obuf, form_field_t *fld, char *var, char *val ) {
  int index;
  if ( isdigit(var[2]) && var[3] == '\0' )
    index = var[2] - '0';
  if ( index < 0 || index > 3 )
    return val_badvar( obuf, var );
  return f_string( fld+index, val );
}

// Return 0 if no errors
// Return 2 if there are validation errors,  but don't be verbose. Leave that to caller
int date_in( obuf_t *obuf, form_date_t *date, char *var, char *val ) {
  if ( var[2] == '\0' ) {
    switch ( var[1] ) {
      case 'Y':
        return f_string( &date->Y, val );
      case 'M':
        return f_string( &date->M, val );
      case 'D':
        return f_string( &date->D, val );
      default:
        break;
    }
  }
  return val_badvar( obuf, var );
}

// Return 0 if no errors
// Return 1 if var is 'SU'
// Return 2 if there are validation errors
int store_var( obuf_t *obuf, char *var, char *val ) {
  // Should probably first translate any html entities
  int rv = 0;

  if ( val == NULL )
    return val_error( obuf, "Missing value" );
  switch (var[0]) {
    case 'M':
      if ( var[1] == 'A' && isdigit(var[2]) && var[2] <= '5' && var[3] == '\0')
        return macaddr_in( obuf, var[2] - '0', val );
      break;
    case 'I':
      if ( var[1] == 'P' )
        return ipaddr_in( obuf, fld_IP, var, val );
      break;
    case 'N':
      if ( var[1] == 'M' && isdigit(var[2]) && var[3] == '\0')
        return ipaddr_in( obuf, fld_NM, var, val );
      else if ( var[1] == 'T' && var[2] == '\0' )
      	return f_string( &fld_NT, val );
      break;
    case 'G':
      if ( var[1] == 'W' && isdigit(var[2]) && var[3] == '\0')
        return ipaddr_in( obuf, fld_GW, var, val );
      break;
    case 'S':
      switch (var[1]) {
        case 'N':
          if ( var[2] == '\0' ) {
          	if ( f_string( &fld_SN, val ) )
            	return val_error( obuf, "Serial Number out of range" );
          	return 0;
          }
          break;
        case 'U':
          if ( var[2] == '\0' )
            return 1;
          break;
      }
      break;
    case 'F':
      return date_in( obuf, &fld_FAB, var, val );
    case 'C':
      return date_in( obuf, &fld_CFG, var, val );
    default: break;
  }
  return val_badvar(obuf, var);
}

// parse_get() will directly update the SSP_Config structure
// returns non-zero if we received a non-zero 'submitted' value
// return 0 if not submitted
// return 1 if submitted and values are all OK
// return 2 if validation errors occurred
int parse_get( obuf_t *obuf, char *URL ) {
  int i, rv = 0;

  // look for question mark or NUL
  i = strcspn( URL, "?" );
  if ( URL[i] == '\0' ) return 0;
  URL += i+1;
  while ( *URL != '\0' ) {
    char *var, *val;
    int rvi;
    i = strcspn( URL, "=&" );
    if ( URL[i] == '=' ) {
      var = URL;
      URL[i] = '\0';
      URL += i+1;
      val = URL;
      i = strcspn( URL, "&" );
      URL += i;
      if (*URL == '&')
        *URL++ = '\0';
    } else {
      var = URL;
      URL += i;
      if ( *URL == '&' )
        *URL++ = '\0';
      val = NULL;
    }
    //url_decode(var); // unnecessary due to our choice of field names
    url_decode(val);
    rvi = store_var( obuf, var, val );
    if ( rvi > rv ) rv = rvi;
  }
  return rv;
}

int x2d( char c ) {
	return ( c >= 'A') ? c - 'A' + 10 : c - '0';
}

void url_decode( char *in ) {
	char *out = in;
	if ( in == NULL ) return;
	while (*in) {
		if ( *in == '%' && isxdigit(in[1]) && isxdigit(in[2]) ) {
			*out++ = x2d(in[1])*16 + x2d(in[2]);
			in += 3;
		} else if ( *in == '+' ) {
			*out++ = ' ';
			++in;
		} else *out++ = *in++;
	}
	*out = '\0';
}

// I need:
// HTTP/1.1 200 OK
// Content-type: image/jpg
// Content-length: %d
// Expires: Thu, 01 Dec 2009 16:00:00 GMT
// Connection: close
//
static void process_http_image(obuf_t *obuf, char *type, char *img, int imgsize) {
  int rv, i;
  // Output http header, header, banner
  obuf_write( obuf,
    "HTTP/1.1 200 OK\r\n"
    "Content-type: " );
  obuf_write( obuf, type );
  obuf_write( obuf,
  	"\r\n"
    "Connection: close\r\n"
    "Content-length: " );
  obuf_write( obuf, ntoa(imgsize, 10, 1) );
  obuf_write( obuf, "\r\n\r\n" );
  obuf_bwrite( obuf, img, imgsize );
}

// I need:
// HTTP/1.1 200 OK
// Content-type: text/html
// Connection: close
//
static void process_http_form(obuf_t *obuf, char *URL) {
  int rv, i;
  
  // Output http header, header, banner
  obuf_write( obuf,
    "HTTP/1.1 200 OK\r\n"
    "Content-Type: text/html; charset=utf-8\r\n"
    "Connection: close\r\n\r\n"
    "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\"\r\n"
    "   \"http://www.w3.org/TR/html4/loose.dtd\">\r\n"
    "<html>\r\n"
    "<head>\r\n"
    "<title>SSP Configuration Utility</title>\r\n"
    "<style type=\"text/css\">\r\n"
    "<!--\r\n"
    "body { background-color: cyan }\r\n"
    "h1 { margin-top: 4px; margin-bottom: 0px }\r\n"
    "h2 { margin-top: 0px; margin-bottom: 15px }\r\n"
    "h1, h2 { color: #000099 }\r\n"
    "th { text-align: right }\r\n"
    "td { font-weight: bold }\r\n"
    ".invalid { color: red }\r\n"
    "input { background-color: #CCFFFF; text-align: center }\r\n"
		"input.l { text-align: left }\r\n"
		"input.err { background-color: #FFCCCC }\r\n"
		".form {\r\n"
		"  border: 1px solid black;\r\n"
		"  float: left;\r\n"
		"  padding: 10px;\r\n"
		"}\r\n"
		".copyright {\r\n"
		"  font-size: x-small;\r\n"
		"  clear: both;\r\n"
		"}\r\n"
    "-->\r\n"
    "</style>\r\n"
    "</head>\r\n"
    "<body>\r\n"
    "<img name=\"daslogo\" src=\"daslogo.jpg\" width=\"600\" height=\"100\" alt=\"Anderson Group Data Acquisition Logo\" usemap=\"#daq_map\" border=\"0\">\r\n"
    "<map name=\"daq_map\" id=\"daq_map\">\r\n"
    "\r\n"
    "<area href=\"http://www.harvard.edu/\" shape=\"rect\" coords=\"10, 11, 91, 35\" alt=\"Harvard Home Page\" >\r\n"
    "<area href=\"http://www.arp.harvard.edu/\" shape=\"rect\" coords=\"91, 6, 246, 43\" alt=\"Anderson Group Home Page\" >\r\n"
    "<area href=\"http://www.arp.harvard.edu/eng/das/\" shape=\"rect\" coords=\"30, 47, 273, 79\" alt=\"Anderson Group Data Acquisition Home Page\" >\r\n"
    "</map>\r\n"
    "<h1>Scalable Signal Processor</h1>\r\n"
    "<h2>Configuration Utility</h2>\r\n"
    "<div class=\"form\">\r\n" );

  // Parse request to update field values. Output validation errors to obuf
  rv = parse_get(obuf, URL);

  // if submit, run validation checks. if OK, write to EEPROM
  if ( rv == 1 ) {
  	fields_update( &SSP_Config );
  	if ( EE_WriteConfig( &SSP_Config ) ) {
  		val_error( obuf, "Write returned an error" );
  	} else {
  		obuf_write( obuf, "<p><b>Write was successful</b></p>\r\n" );
    // Output any useful status information
  	}
  } else if ( rv == 2 ) {
    val_error( obuf, "Input Validation Failed" );
  }
  // Output form
  obuf_write( obuf,
    "<form action=\"/\" method=\"GET\">\r\n"
    "<table>\r\n"
    "<tr><th>SSP Board Serial Number:</th>\r\n"
    "  <td>ARP_SSP_" );
  field_output( obuf, &fld_SN );
  obuf_write( obuf, "</td></tr>\r\n"
    "<tr><th>Fabrication Date:</th>\r\n"
    "  <td>" );
  date_output( obuf, &fld_FAB );
  obuf_write( obuf, "</td></tr>\r\n"
    "<tr><th>Configuration Date:</th>\r\n"
    "  <td>" );
  date_output( obuf, &fld_CFG );
  obuf_write( obuf, "</td></tr>\r\n"
    "<tr><th>MAC Address:</th>\r\n"
    "  <td>" );
  field_output( obuf, &fld_MA[0] );
  for ( i = 1; i < 6; i++ ) {
    obuf_write( obuf, " :\r\n"
      "      " );
    field_output( obuf, &fld_MA[i] );
  }
  obuf_write( obuf, "</td></tr>\r\n" );
  ipflds_output( obuf, "IP Address", fld_IP );
  ipflds_output( obuf, "IP Netmask", fld_NM );
  ipflds_output( obuf, "IP Gateway", fld_GW );
  obuf_write( obuf, "<tr><th>Notes:</th>\r\n"
    "  <td>" );
  field_output( obuf, &fld_NT );
  obuf_write( obuf, "</td></tr>\r\n"
    "<tr><th>Configuration Length:</th><td>" );
  obuf_write( obuf, ntoa( SSP_Config.hdr.n_bytes, 10, 1 ) );
  obuf_write( obuf, "</td></tr>\r\n"
    "<tr><th>Configuration Checksum:</th><td>" );
  obuf_write( obuf, ntoa( SSP_Config.hdr.checksum, 10, 1 ) );
  obuf_write( obuf, "</td></tr>\r\n"
    "<tr><th>Configuration Version:</th><td>0</td></tr>\r\n"
    "<tr><td colspan=\"2\" align=\"center\">"
    "<input type=\"submit\" name=\"SU\" value=\"submit\"></td></tr>\r\n"
    "</table>\r\n"
    "</form>\r\n" );

  // Output footer
  obuf_write( obuf,
    "</div>\r\n"
    "<p class=\"copyright\">&copy; 2008 President and Fellows of Harvard College</p>\r\n"
    "</body>\r\n"
    "</html>\r\n" );
  obuf_flush(obuf);
}

void process_http(int sock, char*receiveBuffer, char*sendBuffer) {
  char *methodPtr;
  char *dataPtr;
  char *typePtr;
  int bytesReceived;
  obuf_t obuf;
  
  // Read the request from the socket into the receive buffer
  bytesReceived = lwip_read(sock, receiveBuffer, RECV_BUFFER_LENGTH);
  
  // Tokenize the received request
  methodPtr = strtok(receiveBuffer, " ");
  dataPtr = strtok((char *)NULL, " ");
  typePtr = strtok((char *)NULL, "\r");
  
  print_mutex_lock();
  safe_printf(("Processing %s %s request for %s\r\n", typePtr, methodPtr, dataPtr));
  print_mutex_unlock();

  // Initialize output buffer
  obuf.buf = sendBuffer;
  obuf.bufsize = SEND_BUFFER_LENGTH;
  obuf.index = 0;
  obuf.sock = sock;
  
  // Should distinguish between form requests and other objects here
  if(!strcmp(methodPtr, "GET")) {
  	if ( !strcmp(dataPtr, "/daslogo.jpg" ) )
  		process_http_image( &obuf, "image/jpg", daslogo_jpg, daslogo_jpg_size );
    else
      process_http_form( &obuf, dataPtr );
  }
}
