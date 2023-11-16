
package glfw

GL_Proc :: #type proc "c" ()
VK_Proc :: #type proc "c" ()

Monitor :: struct {}
Window  :: struct {}
Cursor  :: struct {}

Error_Proc :: #type proc "c" (code: Error, description: cstring)

Window_Pos_Proc      :: #type proc "c" (window: ^Window, pos_x: i32, pos_y: i32)
Window_Size_Proc     :: #type proc "c" (window: ^Window, size_x: i32, size_y: i32)

Window_Focus_Proc    :: #type proc "c" (window: ^Window, focused: b32)
Window_Iconify_Proc  :: #type proc "c" (window: ^Window, iconified: b32)
Window_Maximize_Proc :: #type proc "c" (window: ^Window, maximized: b32)

Window_Close_Proc    :: #type proc "c" (window: ^Window)
Window_Refresh_Proc  :: #type proc "c" (window: ^Window)

Framebuffer_Size_Proc     :: #type proc "c" (window: ^Window, size_x: i32, size_y: i32)
Window_Content_Scale_Proc :: #type proc "c" (window: ^Window, scale_x: f32, scale_y: f32)

Mouse_Button_Proc :: #type proc "c" (window: ^Window, button: Mouse_Button, action: Action, mods: Mod)
Cursor_Pos_Proc   :: #type proc "c" (window: ^Window, pos_x: f64, pos_y: f64)
Cursor_Enter_Proc :: #type proc "c" (window: ^Window, entered: b32)
Scroll_Proc       :: #type proc "c" (window: ^Window, offset_x: f64, offset_y: f64)
Key_Proc          :: #type proc "c" (window: ^Window, key: Key, scan: i32, action: Action, mods: Mod)
Char_Proc         :: #type proc "c" (window: ^Window, codepoint: rune)

/*
    Note: Scheduled for removal in GLFW version 4.0.
*/
Char_Mods_Proc    :: #type proc "c" (window: ^Window, codepoint: rune, mods: Mod)

Drop_Proc         :: #type proc "c" (window: ^Window, path_count: i32, paths: [^]cstring)
Monitor_Proc      :: #type proc "c" (window: ^Window, event: Connection_Event)
Joystick_Proc     :: #type proc "c" (window: ^Window, event: Connection_Event)

/*
    Describes a single video mode.
*/
Video_Mode :: struct {
    width:        i32,
    height:       i32,
    red_bits:     i32,
    green_bits:   i32,
    blue_bits:    i32,
    refresh_rate: i32,
}

/*
    Describes the gamma ramp for a monitor.
*/
Gamma_Ramp :: struct {
    red:   [^]u16,
    green: [^]u16,
    blue:  [^]u16,
    size:  u32,
}

/*
    Describes a single 2D image.
*/
Image :: struct {
    width:  i32,
    height: i32,
    pixels: [^]u8,
}

/*
    Describes the Gamepad input state.
*/
Gamepad_State :: struct {
    buttons: [Gamepad_Button]b8,
    axes:    [Gamepad_Axis]f32,
}

