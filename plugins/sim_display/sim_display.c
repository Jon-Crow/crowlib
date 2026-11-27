#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <vpi_user.h>

#include "SDL3/SDL.h"

#define TARGET_FPS (60)
#define FRAME_MS   (1000 / TARGET_FPS)

static SDL_Window   *win            = NULL;
static SDL_Renderer *rend           = NULL;
static SDL_Texture  *tx             = NULL;
static vpiHandle    sig_sim_display = NULL;
static vpiHandle    sig_clk         = NULL;
static vpiHandle    sig_update      = NULL;
static vpiHandle    sig_px          = NULL;
static vpiHandle    sig_keys        = NULL;
static int          disp_w          = 0;
static int          disp_h          = 0;
static int          key_count       = 0;
static int          *keys           = NULL;

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

static Uint32 px_to_color(const char *px)
{
  int clr = 0;
  for(int i = 0; i < 24; i++)
  {
    clr = clr << 1;
    if(px[i] == '1' || px[i] == 'H')
      clr |= 1;
  }
  return clr;
}

static void set_key(int idx, int val)
{
  if(idx < 0 || idx >= key_count)
    return;

  s_vpi_value keys_val = { .format = vpiBinStrVal };
  vpi_get_value(sig_keys, &keys_val);
  
  keys_val.value.str[idx] = val ? '1' : '0';

  vpi_put_value(sig_keys, &keys_val, NULL, vpiNoDelay);
}

static PLI_INT32 on_clock_edge(p_cb_data cb_data)
{
  static Uint64 last_frame = 0;
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
      Uint64 time = SDL_GetTicks();
      if((time - last_frame) < FRAME_MS)
        SDL_Delay(FRAME_MS - (time - last_frame));
      last_frame = time;

      void *px;
      int pitch;
      if(SDL_LockTexture(tx, NULL, &px, &pitch))
      {
        for(int r = 0; r < disp_h; r++)
        {
          vpiHandle row = vpi_handle_by_index(sig_px, r);
          s_vpi_value row_val = { .format = vpiBinStrVal };
          vpi_get_value(row, &row_val);
          
          const char *row_str = row_val.value.str;
          if(row_str == NULL)
            goto unlock;

          Uint32 *dest = (Uint32*)((Uint8*)px + r*pitch);
          for(int c = 0; c < disp_w; c++)
            dest[c] = px_to_color(&row_str[(disp_w - 1 - c) * 24]);
        }

        unlock:
        SDL_UnlockTexture(tx);
      }

      SDL_RenderClear(rend);
      SDL_RenderTexture(rend, tx, NULL, NULL);
      SDL_RenderPresent(rend);
    }

    SDL_Event e;
    while(SDL_PollEvent(&e))
    {
      switch(e.type)
      {
        case SDL_EVENT_QUIT:
          s_vpi_value val = { .format = vpiBinStrVal };
          val.value.str = "0";
          vpi_put_value(sig_sim_display, &val, NULL, vpiNoDelay);
          break;
        
        case SDL_EVENT_KEY_DOWN:
          if(!e.key.repeat)
          {
            for(int i = 0; i < key_count; i++)
            {
              if(e.key.key == keys[i])
              {
                vpi_printf("Key %0d was pressed\n", e.key.key);
                set_key(i, 1);
              }
            }
          }
          break;
        
        case SDL_EVENT_KEY_UP:
          if(!e.key.repeat)
          {
            for(int i = 0; i < key_count; i++)
            {
              if(e.key.key == keys[i])
                set_key(i, 0);
            }
          }
          break;
      }
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
  snprintf(path, sizeof(path), "%s.vpi_tag_sim_display", vpi_get_str(vpiFullName, disp_inst));
  sig_sim_display = vpi_handle_by_name(path, NULL);
  snprintf(path, sizeof(path), "%s.clk", vpi_get_str(vpiFullName, disp_inst));
  sig_clk = vpi_handle_by_name(path, NULL);
  snprintf(path, sizeof(path), "%s.update_q", vpi_get_str(vpiFullName, disp_inst));
  sig_update = vpi_handle_by_name(path, NULL);
  snprintf(path, sizeof(path), "%s.vpi_px", vpi_get_str(vpiFullName, disp_inst));
  sig_px = vpi_handle_by_name(path, NULL);
  snprintf(path, sizeof(path), "%s.keys", vpi_get_str(vpiFullName, disp_inst));
  sig_keys = vpi_handle_by_name(path, NULL);

  if(
    sig_sim_display == NULL || 
    sig_clk         == NULL || 
    sig_update      == NULL || 
    sig_px          == NULL ||
    sig_keys        == NULL
  )
  {
    vpi_printf("COuld not find all sim_display signals.\n");
    return -1;
  }

  disp_w = vpi_get(vpiSize, vpi_handle_by_index(sig_px, 0)) / 24;
  disp_h = 0;
  while(vpi_handle_by_index(sig_px, disp_h) != NULL)
    disp_h++;

  vpi_printf("Screen size: %0dx%0d\n", disp_w, disp_h);

  snprintf(path, sizeof(path), "%s.key_vals", vpi_get_str(vpiFullName, disp_inst));
  vpiHandle gen_keys = vpi_handle_by_name(path, NULL);
  
  if(gen_keys == NULL)
  {
    vpi_printf("Could not find key_vals.\n");
    return -1;
  }

  key_count = (int)vpi_get(vpiSize, sig_keys);

  keys = malloc(key_count * sizeof(int));
  if(keys == NULL)
  {
    vpi_printf("Failed to allocate key array.\n");
    return -1;
  }

  vpi_printf("Listening to %0d keys:\n", key_count);
  for(int i = 0; i < key_count; i++)
  {
    vpiHandle key = vpi_handle_by_index(gen_keys, i);
    if(key == NULL)
    {
      vpi_printf("Retrieving index %0d from key array failed.\n", i);
      return -1;
    }

    s_vpi_value key_val = { .format = vpiIntVal };
    vpi_get_value(key, &key_val);
    keys[i] = key_val.value.integer;
    vpi_printf("\t%0d\n", keys[i]);
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

  SDL_SetRenderVSync(rend, 0);

  tx = SDL_CreateTexture(rend, SDL_PIXELFORMAT_XRGB8888, SDL_TEXTUREACCESS_STREAMING, disp_w, disp_h);
  SDL_SetTextureScaleMode(tx, SDL_SCALEMODE_NEAREST);
  SDL_SetRenderLogicalPresentation(rend, disp_w, disp_h, SDL_LOGICAL_PRESENTATION_LETTERBOX);

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
