{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
        -- enable_wayland = false; -- https://github.com/wez/wezterm/issues/4483
        font = wezterm.font_with_fallback {
          {
            family = 'Iosevka Comfy',
            stretch = 'Expanded',
            weight = 'Regular',
            harfbuzz_features = { 'dlig=1' }
          },
        };
        font_size = 13;
        allow_square_glyphs_to_overflow_width = "Always";
        color_scheme = "Catppuccin Mocha";
        window_background_opacity = 1;
        enable_tab_bar = false;
        hide_mouse_cursor_when_typing = false;
        window_close_confirmation = "NeverPrompt";
        window_padding = {
          left = '1cell',
          right = '1cell',
          top = '0.5cell',
          bottom = '0.5cell',
        };
      }
    '';
  };
}
