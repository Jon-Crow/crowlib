#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <vpi_user.h>

#include "SDL3/SDL.h"

static SDL_Window *win = NULL;
static SDL_Renderer *rend = NULL;
static vpiHandle sig_clk = NULL;
static vpiHandle sig_update = NULL;
static vpiHandle sig_px = NULL;

static int scope_has_net(vpiHandle scope, const char *net_name)
{
  vpiHandle iter = vpi_iterate(vpiNet, scope);
  if (iter == NULL)
    return 0;

  vpiHandle net;
  while ((net = vpi_scan(iter)) != NULL)
  {
    const char *name = vpi_get_str(vpiName, net);
    if (name != NULL && SDL_strcasecmp(name, net_name) == 0)
    {
      vpi_free_object(iter);
      return 1;
    }
  }
  return 0;
}

static vpiHandle find_instance_with_net(vpiHandle scope, const char *net_name)
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

static void add_cb(PLI_INT32 reason, PLI_INT32 (*fn)(p_cb_data), vpiHandle obj, PLI_BYTE8 *user_data)
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


static PLI_INT32 on_clock_edge(p_cb_data cb_data)
{
  static char prev = 'U';

  s_vpi_value clk_val = { .format = vpiBinStrVal };
  vpi_get_value(cb_data->obj, &clk_val);

  char now = clk_val.value.str[0];
  int rising = (prev == '0' || prev == 'L') && (now == '1' || now == 'H');
  prev = now;

  if(rising)
  {
    s_vpi_value update_val = { .format = vpiBinStrVal };
    vpi_get_value(sig_update, &update_val);

    char update_ch = update_val.value.str[0];
    if(update_ch == '1' || update_ch == 'H')
    {
      for(int r = 0; r < 256; r++)
      {
        vpiHandle row = vpi_handle_by_index(sig_px, r);
        s_vpi_value row_val = { .format = vpiBinStrVal };
        vpi_get_value(row, &row_val);
        vpi_printf("%s\n", row_val.value.str);
      }
      vpi_printf("================================================================\n");
    }
  }

  return 0;
}

static PLI_INT32 on_start(p_cb_data cb)
{
  vpi_printf("VPI: start of simulation\n");

  vpiHandle disp_inst = find_instance_with_net(NULL, "vpi_tag_sim_display");
  if(disp_inst == NULL)
  {
    vpi_printf("No sim_display instance was found.\n");
    return -1;
  }

  char path[1024];
  snprintf(path, sizeof(path), "%s.clk", vpi_get_str(vpiFullName, disp_inst));
  sig_clk = vpi_handle_by_name(path, NULL);
  snprintf(path, sizeof(path), "%s.update_q", vpi_get_str(vpiFullName, disp_inst));
  sig_update = vpi_handle_by_name(path, NULL);
  snprintf(path, sizeof(path), "%s.px_q", vpi_get_str(vpiFullName, disp_inst));
  sig_px = vpi_handle_by_name(path, NULL);

  if(sig_clk == NULL || sig_update == NULL || sig_px == NULL)
  {
    vpi_printf("COuld not find all sim_display signals.\n");
    return -1;
  }

  add_cb(cbValueChange, on_clock_edge, sig_clk, NULL);

  if(!SDL_Init(SDL_INIT_VIDEO))
  {
    vpi_printf("Failed to initialize SDL.\n");
    return -1;
  }

  if(!SDL_CreateWindowAndRenderer("Sim Display", 512, 512, SDL_WINDOW_RESIZABLE, &win, &rend))
  {
    vpi_printf("Failed to create SDL window and renderer.\n");
    SDL_Quit();
    return -1;
  }

  SDL_SetRenderVSync(rend, 1);

  return 0;
}

static PLI_INT32 on_end(p_cb_data cb) 
{
  if(rend != NULL)
    SDL_DestroyRenderer(rend);
  if(win != NULL)
    SDL_DestroyWindow(win);
  SDL_Quit();
  vpi_printf("VPI: end of simulation\n");
}

static void entry(void)
{
  add_cb(cbStartOfSimulation, on_start, NULL, NULL);
  add_cb(cbEndOfSimulation,   on_end,   NULL, NULL);
}

void (*vlog_startup_routines[])(void) = { entry, NULL };
