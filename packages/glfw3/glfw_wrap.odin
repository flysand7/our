
package glfw

// Library initialization and termination.

init_hint :: proc(hint: Init_Hint, value: b32) {
    glfwInitHint(hint, value)
} 

init :: proc() -> b32 {
    return glfwInit()
}

terminate :: proc() {
    glfwTerminate()
}

get_version :: proc() -> (i32, i32, i32) {
    major: i32 = ---
    minor: i32 = ---
    patch: i32 = ---
    glfwGetVersion(&major, &minor, &patch)
    return major, minor, patch
}

get_version_string :: proc() -> cstring {
    return glfwGetVersionString()
}

// Error handling.

get_error :: proc() -> (Error, cstring) {
    description: cstring = ---
    error_code := glfwGetError(&description)
    return error_code, description
}

set_error_callback :: proc(callback: Error_Proc) -> Error_Proc {
    return glfwSetErrorCallback(callback)
}

// Monitors.

get_monitors :: proc() -> []^Monitor {
    count: i32 = ---
    monitors := glfwGetMonitors(&count)
    return monitors[:count]
}

get_primary_monitor :: proc() -> ^Monitor {
    return glfwGetPrimaryMonitor()
}

get_monitor_pos :: proc(monitor: ^Monitor) -> (i32, i32) {
    pos_x: i32 = ---
    pos_y: i32 = ---
    glfwGetMonitorPos(monitor, &pos_x, &pos_y)
    return pos_x, pos_y
}

get_monitor_workarea :: proc(monitor: ^Monitor) -> (i32, i32, i32, i32) {
    pos_x: i32 = ---
    pos_y: i32 = ---
    size_x: i32 = ---
    size_y: i32 = ---
    glfwGetMonitorWorkarea(monitor, &pos_x, &pos_y, &size_x, &size_y)
    return pos_x, pos_y, size_x, size_y
}

get_monitor_physical_size :: proc(monitor: ^Monitor) -> (i32, i32) {
    size_x_mm: i32 = ---
    size_y_mm: i32 = ---
    glfwGetMonitorPhysicalSize(monitor, &size_x_mm, &size_y_mm)
    return size_x_mm, size_y_mm
}

get_monitor_content_scale :: proc(monitor: ^Monitor) -> (f32, f32) {
    scale_x: f32 = ---
    scale_y: f32 = ---
    glfwGetMonitorContentScale(monitor, &scale_x, &scale_y)
    return scale_x, scale_y
}

get_monitor_name :: proc(monitor: ^Monitor) -> cstring {
    return glfwGetMonitorName(monitor)
}

set_monitor_user_pointer :: proc(monitor: ^Monitor, pointer: rawptr) {
    glfwSetMonitorUserPointer(monitor, pointer)
}

get_monitor_user_pointer :: proc(monitor: ^Monitor) -> rawptr {
    return glfwGetMonitorUserPointer(monitor)
}

set_monitor_callback :: proc(callback: Monitor_Proc) -> Monitor_Proc {
    return glfwSetMonitorCallback(callback)
}

// Video modes.

get_video_modes :: proc(monitor: ^Monitor) -> []Video_Mode {
    count: i32 = ---
    modes := glfwGetVideoModes(monitor, &count)
    return modes[:count]
}

get_video_mode :: proc(monitor: ^Monitor) -> ^Video_Mode {
    return glfwGetVideoMode(monitor)
}

set_gamma :: proc(monitor: ^Monitor, gamma: f32) {
    glfwSetGamma(monitor, gamma)
}

get_gamma_ramp :: proc(monitor: ^Monitor) -> ^Gamma_Ramp {
    return glfwGetGammaRamp(monitor)
}

set_gamma_ramp :: proc(monitor: ^Monitor, gamma_ramp: ^Gamma_Ramp) {
    glfwSetGammaRamp(monitor, gamma_ramp)
}

// Window.

default_window_hints :: proc() {
    glfwDefaultWindowHints()
}

@(private)
window_hint_i32 :: proc(hint: Window_Hint, value: i32) {
    glfwWindowHint(hint, value)
}

@(private)
window_hint_b32 :: proc(hint: Window_Hint, value: b32) {
    glfwWindowHint(hint, cast(i32) value)
}

@(private)
window_hint_cstring :: proc(hint: Window_Hint, value: cstring) {
    glfwWindowHintString(hint, value)
}

window_hint :: proc {
    window_hint_i32,
    window_hint_b32,
    window_hint_cstring,
}

create_window :: proc(
    size_x:  i32,
    size_y:  i32,
    title:   cstring,
    monitor: ^Monitor = nil,
    share:   ^Window  = nil,
) -> ^Window {
    return glfwCreateWindow(size_x, size_y, title, monitor, share)
}

destroy_window :: proc(window: ^Window) {
    glfwDestroyWindow(window)
}

window_should_close :: proc(window: ^Window) -> b32 {
    return glfwWindowShouldClose(window)
}

set_window_should_close :: proc(window: ^Window, should_close: b32) {
    glfwSetWindowShouldClose(window, should_close)
}

set_window_title :: proc(window: ^Window, title: cstring) {
    glfwSetWindowTitle(window, title)
}

set_window_icon :: proc(window: ^Window, icons: []Image) {
    glfwSetWindowIcon(window, cast(i32) len(icons), raw_data(icons))
}

get_window_pos :: proc(window: ^Window) -> (i32, i32) {
    pos_x: i32 = ---
    pos_y: i32 = ---
    glfwGetWindowPos(window, &pos_x, &pos_y)
    return pos_x, pos_y
}

set_window_pos :: proc(window: ^Window, pos_x: i32, pos_y: i32) {
    glfwSetWindowPos(window, pos_x, pos_y)
}

get_window_size :: proc(window: ^Window) -> (i32, i32) {
    size_x: i32 = ---
    size_y: i32 = ---
    glfwGetWindowSize(window, &size_x, &size_y)
    return size_x, size_y
}

set_window_size_limits :: proc(
    window: ^Window,
    min_size_x: i32 = DONT_CARE,
    min_size_y: i32 = DONT_CARE,
    max_size_x: i32 = DONT_CARE,
    max_size_y: i32 = DONT_CARE,
) {
    glfwSetWindowSizeLimits(window, min_size_x, min_size_y, max_size_x, max_size_y)
}

set_window_aspect_ratio :: proc(window: ^Window, numerator: i32, denominator: i32) {
    glfwSetWindowAspectRatio(window, numerator, denominator)
}

set_window_size :: proc(window: ^Window, size_x: i32, size_y: i32) {
    glfwSetWindowSize(window, size_x, size_y)
}

get_framebuffer_size :: proc(window: ^Window) -> (i32, i32) {
    size_x: i32 = ---
    size_y: i32 = ---
    glfwGetFramebufferSize(window, &size_x, &size_y)
    return size_x, size_y
}

get_window_frame_size :: proc(window: ^Window) -> (i32, i32, i32, i32) {
    left:   i32 = ---
    top:    i32 = ---
    right:  i32 = ---
    bottom: i32 = ---
    glfwGetWindowFrameSize(window, &left, &top, &right, &bottom)
    return left, top, right, bottom
}

get_window_content_scale :: proc(window: ^Window) -> (f32, f32) {
    scale_x: f32 = ---
    scale_y: f32 = ---
    glfwGetWindowContentScale(window, &scale_x, &scale_y)
    return scale_x, scale_y
}

get_window_opacity :: proc(window: ^Window) -> f32 {
    return glfwGetWindowOpacity(window)
}

set_window_opacity :: proc(window: ^Window, opacity: f32) {
    glfwSetWindowOpacity(window, opacity)
}

iconify_window :: proc(window: ^Window) {
    glfwIconifyWindow(window)
}

restore_window :: proc(window: ^Window) {
    glfwRestoreWindow(window)
}

maximize_window :: proc(window: ^Window) {
    glfwMaximizeWindow(window)
}

show_window :: proc(window: ^Window) {
    glfwShowWindow(window)
}

hide_window :: proc(window: ^Window) {
    glfwHideWindow(window)
}

focus_window :: proc(window: ^Window) {
    glfwFocusWindow(window)
}

window_monitor :: proc(window: ^Window) -> ^Monitor {
    return glfwWindowMonitor(window)
}

set_window_monitor :: proc(
    window: ^Window,
    monitor: ^Monitor,
    pos_x: i32,
    pos_y: i32,
    size_x: i32,
    size_y: i32,
    refresh_rate: i32,
) {
    glfwSetWindowMonitor(window, monitor, pos_x, pos_y, size_x, size_y, refresh_rate)
}

get_window_attrib :: proc(window: ^Window, attrib: Window_Hint) -> b32 {
    return glfwGetWindowAttrib(window, attrib)
}

set_window_attrib :: proc(window: ^Window, attrib: Window_Hint, value: b32) {
    glfwSetWindowAttrib(window, attrib, value)
}

// Callbacks.

set_window_user_pointer :: proc(window: ^Window, pointer: rawptr) {
    glfwSetWindowUserPointer(window, pointer)
}

get_window_user_pointer :: proc(window: ^Window) -> rawptr {
    return glfwGetWindowUserPointer(window)
}

set_window_pos_callback :: proc(window: ^Window, callback: Window_Pos_Proc) -> Window_Pos_Proc {
    return glfwSetWindowPosCallback(window, callback)
}

set_window_size_callback :: proc(window: ^Window, callback: Window_Size_Proc) -> Window_Size_Proc {
    return glfwSetWindowSizeCallback(window, callback)
}

set_window_close_callback :: proc(window: ^Window, callback: Window_Close_Proc) -> Window_Close_Proc {
    return glfwSetWindowCloseCallback(window, callback)
}

set_window_refresh_callback :: proc(window: ^Window, callback: Window_Refresh_Proc) -> Window_Refresh_Proc {
    return glfwSetWindowRefreshCallback(window, callback)
}

set_window_focus_callback :: proc(window: ^Window, callback: Window_Focus_Proc) -> Window_Focus_Proc {
    return glfwSetWindowFocusCallback(window, callback)
}

set_window_iconify_callback :: proc(window: ^Window, callback: Window_Iconify_Proc) -> Window_Iconify_Proc {
    return glfwSetWindowIconifyCallback(window, callback)
}

set_window_maximize_callback :: proc(window: ^Window, callback: Window_Maximize_Proc) -> Window_Maximize_Proc {
    return glfwSetWindowMaximizeCallback(window, callback)
}

set_framebuffer_size_callback :: proc(window: ^Window, callback: Framebuffer_Size_Proc) -> Framebuffer_Size_Proc {
    return glfwSetFramebufferSizeCallback(window, callback)
}

set_window_content_scale_callback :: proc(window: ^Window, callback: Window_Content_Scale_Proc) -> Window_Content_Scale_Proc {
    return glfwSetWindowContentScaleCallback(window, callback)
}

// Events.

poll_events :: proc() {
    glfwPollEvents()
}

wait_events :: proc() {
    glfwWaitEvents()
}

wait_events_timeout :: proc(timeout: f64) {
    glfwWaitEventsTimeout(timeout)
}

post_empty_event :: proc() {
    glfwPostEmptyEvent()
}

// Input.

get_input_mode :: proc(window: ^Window, mode: Input_Mode) -> i32 {
    return glfwGetInputMode(window, mode)
}

@(private)
set_input_mode_b32 :: proc(window: ^Window, mode: Input_Mode, value: b32) {
    glfwSetInputMode(window, mode, cast(i32) value)
}

@(private)
set_input_mode_i32 :: proc(window: ^Window, mode: Input_Mode, value: i32) {
    glfwSetInputMode(window, mode, value)
}

set_input_mode :: proc {
    set_input_mode_b32,
    set_input_mode_i32,
}

raw_mouse_motion_supported :: proc() -> b32 {
    return glfwRawMouseMotionSupported()
}

get_key_name :: proc(key: Key, scancode: i32) -> cstring {
    return glfwGetKeyName(key, scancode)
}

get_key_scancode :: proc(key: Key) -> i32 {
    return glfwGetKeyScancode(key)
}

get_key :: proc(window: ^Window, key: Key) -> Action {
    return glfwGetKey(window, key)
}

get_mouse_button :: proc(window: ^Window, button: Mouse_Button) -> Action {
    return glfwGetMouseButton(window, button)
}

get_cursor_pos :: proc(window: ^Window) -> (f64, f64) {
    pos_x: f64 = ---
    pos_y: f64 = ---
    glfwGetCursorPos(window, &pos_x, &pos_y)
    return pos_x, pos_y
}

set_cursor_pos :: proc(window: ^Window, pos_x: f64, pos_y: f64) {
    glfwSetCursorPos(window, pos_x, pos_y)
}

// Cursors.

create_cursor :: proc(image: ^Image, x: i32, y: i32) -> ^Cursor {
    return glfwCreateCursor(image, x, y)
}

create_standard_cursor :: proc(shape: Cursor_Shape) -> ^Cursor {
    return glfwCreateStandardCursor(shape)
}

destroy_cursor :: proc(cursor: ^Cursor) {
    glfwDestroyCursor(cursor)
}

set_cursor :: proc(window: ^Window, cursor: ^Cursor) {
    glfwSetCursor(window, cursor)
}

// More callbacks.

set_key_callback :: proc(window: ^Window, callback: Key_Proc) -> Key_Proc {
    return glfwSetKeyCallback(window, callback)
}

set_char_callback :: proc(window: ^Window, callback: Char_Proc) -> Char_Proc {
    return glfwSetCharCallback(window, callback)
}

set_char_mods_callback :: proc(window: ^Window, callback: Char_Mods_Proc) -> Char_Mods_Proc {
    return glfwSetCharModsCallback(window, callback)
}

set_mouse_button_callback :: proc(window: ^Window, callback: Mouse_Button_Proc) -> Mouse_Button_Proc {
    return glfwSetMouseButtonCallback(window, callback)
}

set_cursor_pos_callback :: proc(window: ^Window, callback: Cursor_Pos_Proc) -> Cursor_Pos_Proc {
    return glfwSetCursorPosCallback(window, callback)
}

set_cursor_enter_callback :: proc(window: ^Window, callback: Cursor_Enter_Proc) -> Cursor_Enter_Proc {
    return glfwSetCursorEnterCallback(window, callback)
}

set_scroll_callback :: proc(window: ^Window, callback: Scroll_Proc) -> Scroll_Proc {
    return glfwSetScrollCallback(window, callback)
}

set_drop_callback :: proc(window: ^Window, callback: Drop_Proc) -> Drop_Proc {
    return glfwSetDropCallback(window, callback)
}

// Joystick input.

joystick_present :: proc(jid: Joystick) -> b32 {
    return glfwJoystickPresent(jid)
}

get_joystick_axes :: proc(jid: Joystick) -> []f32 {
    count: i32 = ---
    axes := glfwGetJoystickAxes(jid, &count)
    return axes[:count]
}

get_joystick_buttons :: proc(jid: Joystick) -> []Joystick_Button_State {
    count: i32 = ---
    buttons := glfwGetJoystickButtons(jid, &count)
    return buttons[:count]
}

get_joystick_hats :: proc(jid: Joystick) -> []Hat_State {
    count: i32 = ---
    hats := glfwGetJoystickHats(jid, &count)
    return hats[:count]
}

get_joystick_name :: proc(jid: Joystick) -> cstring {
    return glfwGetJoystickName(jid)
}

get_joystick_guid :: proc(jid: Joystick) -> cstring {
    return glfwGetJoystickGUID(jid)
}

set_joystick_user_pointer :: proc(jid: Joystick, pointer: rawptr) {
    glfwSetJoystickUserPointer(jid, pointer)
}

get_joystick_user_pointer :: proc(jid: Joystick) -> rawptr {
    return glfwGetJoystickUserPointer(jid)
}

joystick_is_gamepad :: proc(jid: Joystick) -> b32 {
    return glfwJoystickIsGamepad(jid)
}

set_joystick_callback :: proc(callback: Joystick_Proc) -> Joystick_Proc {
    return glfwSetJoystickCallback(callback)
}

update_gamepad_mappings :: proc(mappings: cstring) -> b32 {
    return glfwUpdateGamepadMappings(mappings)
}

get_gamepad_state :: proc(jid: Joystick, state: ^Gamepad_State) -> (b32, Error) {
    res := glfwGetGamepadState(jid, state)
    if res <= 1 {
        return cast(b32) res, .No_Error
    }
    return false, cast(Error) res
}

// Clipboard.

set_clipboard_string :: proc(window: ^Window, string: cstring) {
    glfwSetClipboardString(window, string)
}

get_clipboard_string :: proc(window: ^Window) -> cstring {
    return glfwGetClipboardString(window)
}

// Time.

get_time :: proc() -> f64 {
    return glfwGetTime()
}

set_time :: proc(time: f64) {
    glfwSetTime(time)
}

get_timer_value :: proc() -> u64 {
    return glfwGetTimerValue()
}

get_timer_frequency :: proc() -> u64 {
    return glfwGetTimerFrequency()
}

// Context.

make_context_current :: proc(window: ^Window) {
    glfwMakeContextCurrent(window)
}

get_context_current :: proc() -> ^Window {
    return glfwGetCurrentContext()
}

swap_buffers :: proc(window: ^Window) {
    glfwSwapBuffers(window)
}

swap_interval :: proc(interval: i32) {
    glfwSwapInterval(interval)
}

extension_supported :: proc(extension: cstring) -> b32 {
    return glfwExtensionSupported(extension)
}

get_proc_address :: proc(name: cstring) -> GL_Proc {
    return glfwGetProcAddress(name)
}

// Vulkan.

vulkan_supported :: proc() -> b32 {
    return glfwVulkanSupported()
}

get_required_instance_extensions :: proc() -> []cstring {
    count: i32 = ---
    exts := glfwGetRequiredInstanceExtensions(&count)
    return exts[:count]
}

get_instance_proc_address :: proc(instance: VkInstance, name: cstring) -> VK_Proc {
    return glfwGetInstanceProcAddress(instance, name)
}

get_physical_device_presentation_support :: proc(
    instance:     VkInstance,
    device:       VkPhysicalDevice,
    queue_family: u32,
) -> b32 {
    return glfwGetPhysicalDevicePresentationSupport(instance, device, queue_family)
}
