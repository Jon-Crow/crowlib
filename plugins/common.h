#ifndef CROWLIB_COMMON_H
#define CROWLIB_COMMON_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <strings.h>
#include <vpi_user.h>

int scope_has_net(vpiHandle scope, const char *net_name);

vpiHandle find_instance_with_net(vpiHandle scope, const char *net_name);

void add_cb(PLI_INT32 reason, PLI_INT32 (*fn)(p_cb_data), vpiHandle obj, PLI_BYTE8 *user_data);

#endif
