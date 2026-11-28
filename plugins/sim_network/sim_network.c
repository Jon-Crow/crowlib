#include "../common.h"

static PLI_INT32 on_start(p_cb_data cb)
{
  return 0;
}

static PLI_INT32 on_end(p_cb_data cb)
{
  return 0;
}

static void entry(void)
{
  add_cb(cbStartOfSimulation, on_start, NULL, NULL);
  add_cb(cbEndOfSimulation,   on_end,   NULL, NULL);
}
