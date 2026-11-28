#include "common.h"

int scope_has_net(vpiHandle scope, const char *net_name)
{
  vpiHandle iter = vpi_iterate(vpiNet, scope);
  if (iter == NULL)
    return 0;

  vpiHandle net;
  while ((net = vpi_scan(iter)) != NULL)
  {
    const char *name = vpi_get_str(vpiName, net);
    if (name != NULL && strcasecmp(name, net_name) == 0)
    {
      vpi_free_object(iter);
      return 1;
    }
  }
  return 0;
}

vpiHandle find_instance_with_net(vpiHandle scope, const char *net_name)
{
  vpiHandle iter = (scope == NULL) ? vpi_iterate(vpiModule, NULL) : vpi_iterate(vpiInternalScope, scope);
  if (iter == NULL)
    return NULL;

  vpiHandle child;
  while ((child = vpi_scan(iter)) != NULL)
  {
    vpiHandle found = scope_has_net(child, net_name) ? child : find_instance_with_net(child, net_name);

    if (found != NULL)
    {
      vpi_free_object(iter);
      return found;
    }
  }
  return NULL;
}

void add_cb(PLI_INT32 reason, PLI_INT32 (*fn)(p_cb_data), vpiHandle obj, PLI_BYTE8 *user_data)
{
  static s_vpi_time  cb_time  = { .type   = vpiSuppressTime };
  static s_vpi_value cb_value = { .format = vpiBinStrVal };

  s_cb_data cb = {0};
  cb.reason    = reason;
  cb.cb_rtn    = fn;
  cb.obj       = obj;
  cb.time      = &cb_time;
  cb.value     = &cb_value;
  cb.user_data = user_data;
  if (vpi_register_cb(&cb) == NULL)
    vpi_printf("VPI: failed to register callback %d\n", (int)reason);
}
