
package glfw

/*
    Sets the specified init hint to the desired value.
    
    The values set for these hints are never reset by GLFW, but they only take effect during
    initialization. Once GLFW has been initialized, any values you set will be ignored until the
    library is terminated and initialized again.
    
    Some hints are platform-specific. Other platforms will ignore them. Setting these hints
    requires no platform-specific headers or functions.
    
    See @(ref=Init_Hint) for which type each hint expects.
    
    @(parameters)
    - hint: The hint to set.
    - value: The value of the init hint.
    
    @(errors)
    - @(ref=Error.Invalid_Enum)
    - @(ref=Error.Invalid_Value)
    
    @(thread_safety=main_thread_only)
    @(since=3.3)
*/
init_hint :: proc {
    init_hint_b32,
    init_hint_platform,
    init_hint_angle_platform,
    init_hint_wayland_libdecor,
}

// @(hide)
@(private)
init_hint_b32 :: proc(hint: Init_Hint, value: b32) {
    glfwInitHint(hint, cast(i32) value)
}

// @(hide)
@(private)
init_hint_angle_platform :: proc(hint: Init_Hint, value: Angle_Platform) {
    glfwInitHint(hint, cast(u32) value)
}

// @(hide)
@(private)
init_hint_platform :: proc(hint: Init_Hint, value: Platform) {
    glfwInitHint(hint, cast(i32) value)
}

// @(hide)
@(private)
init_hint_wayland_libdecor :: proc(hint: Init_Hint, value: Wayland_Libdecor) {
    glfwInitHint(hint, cast(i32) value)
}

/*
    This function initializes the GLFW library. Before most GLFW functions can be used, GLFW must
    be initialized, and before an application terminates GLFW, it should be terminated in order to
    free any resources allocated during or after initialization.
    
    If this function fails, it calls @(ref=terminate) before returning. If it succeeds, you should
    call @(ref=terminate) before the application exits.
    
    Additional calls to this function after successful initialization but before termination will
    return `true` immediately.
    
    The @(ref=Init_Hint.Platform) controls which platforms are considered during initialization.
    This also depends on which platforms the library was compiled to support.
    
    @(returns)
    1. `true` if successful, `false` if an error occured (See @(ref=Error)).
    
    @(errors)
    - @(ref=Errors.Platform_Unavailable)
    - @(ref=Errors.Platform_Error)
    
    @(remark=darwin)
    On MacOS, this function will change the current directory of the application to the
    `Contents/Resources` subdirectory of the application's bundle, if present. This can be disabled
    with the @(ref=Init_Hint.Cocoa_Chdir_Resources) init hint.
    
    @(remark=darwin)
    On MacOS this function will create the main menu and dock icon for the application. If GLFW
    finds a `MainMenu.nib`, it is loaded and assumed to contain a menu bar. Otherwise a minimal
    menu bar is created manually with common comments like `Hide`, `Quit` and `About`. The `About`
    entry opens a minimal "about" dialog with information from application's bundle. The menu bar
    and dock icon can be disabled entirely with the @(ref=Init_Hint.Cocoa_Menubar) init hint.
    
    @(remark=x11)
    With x11 this function will set the `LC_CTYPE` category of the application's locale according
    to the current environment if that category is still `"C"`. This is because the `"C"` locale
    breaks the Unicode text input.
    
    @(thread_safety=main_thread_only)
    @(since=1.0)
*/
init :: proc() -> b32 {
    return glfwInit()
}

/*
    Terminates the GLFW library.
    
    This function destroyes all remaining windows and cursors, restores any modified gamma ramps
    and frees any other allocated resources. Once this function is called, you must again call
    @(ref=init) successfully before you will be able to use most GLFW functions.
    
    See @(ref=init) for when this function should and should not be called.
    
    @(errors)
    - @(ref=Errors.Platform_Error)
    
    @(reentrancy)
    This function must not be called from a callback.
    
    @(warning)
    The contexts of any remaining windows must not be current on any other thread, when this
    function is called.
    
    @(thread_safety=main_thread_only)
    @(since=1.0)
*/
terminate :: proc() {
    glfwTerminate()
}

/*
    This function retrieves the major, minor and revision numbers of the GLFW library. It is
    intended for when you are using GLFW as a shared library and want to ensure that you are using
    the minimum required version.
    
    @(returns)
    1. GLFW major version number
    2. GLFW minor version number
    3. GLFW revision number
    
    @(errors)
    - None.
*/
get_version :: proc() -> (i32, i32, i32) {
    major: i32 = ---
    minor: i32 = ---
    patch: i32 = ---
    glfwGetVersion(&major, &minor, &patch)
    return major, minor, patch
}

/*
    Returns a string describing the compile-time configuration.
    
    This function returns the compile-time generated version string of the GLFW library binary.
    It describes the version, platforms, compiler and any platform or operating system specific
    compile-time options.
    
    **Do not use** the version string to parse the GLFW library version. The @(ref=get_version)
    function provides the version in numerical format.
    
    **Do not use** the version string to parse the supported platforms. The
    @(ref=platforms_supported) function lets you query platform support.
    
    @(errors)
    - None.

    @(since=3.0)
*/
get_version_string :: proc() -> cstring {
    return glfwGetVersionString()
}

/*
    @(since=3.3)
    Returns and clears the last error for the calling thread.
    
    This functions returns and clears the error code (@(ref=Error)) of the last error that occurred
    on the calling thread and a UTF-8 encoded human-readable description of it. If no error has
    occurred since the last call, it returns @(ref=Error.No_Error) (`nil`) and the returned string
    is `nil`.
    
    @(returns)
    1. The GLFW error code.
    2. The human-readable description of the error.
    
    @(errors)
    - None.
    
    @(lifetimes)
    - description: Allocated and freed by GLFW. You should not free it yourself. It is
    guaranteed to be valid only until the next error occurs or the library is terminated.
    
    @(remark)
    This function may be called before @(ref=init)
    
    @(thread_safety=safe)
    @(since=3.3)
*/
get_error :: proc() -> (Error, cstring) {
    description: cstring = ---
    error_code := glfwGetError(&description)
    return error_code, description
}

/*
    Sets the error callback.
    
    This function sets the error callback, which is called with the error code and a human-readable
    error description each tyime a GLFW error occurs.
    
    The error code is set before the callback is called. Calling @(ref=get_error) from the error
    callback will return the same value as the error code argument.
    
    The error callback is called on the thread where the error occurred. If you are using GLFW
    from multiple threads, your error callback needs to be written accordingly.
    
    Because the description string may have been generated specifically for that error, it is not
    guaranteed to be valid after the callback has returned. If you wish to use the description
    string after the callback returns you would need to make a copy.
    
    Once set, the error callback remains set, even after the library has been terminated.
    
    @(params)
    - callback: The new callback or `nil` to remove the currently-set callback.

    @(returns)
    1. The previously-set callback or `nil` if no callback was set.
    
    @(remark)
    This function may be called before @(ref=init)
    
    @(thread_safety=main_thread_only)
    @(include=Error_Proc)
    @(since=3.0)
*/
set_error_callback :: proc(callback: Error_Proc) -> Error_Proc {
    return glfwSetErrorCallback(callback)
}

/*
    Returns the currently conntected monitors.
    
    This function returns an array of handles for all currently connected monitors. The primary
    monitor is always first in the returned array. If no monitors were found, this function returns
    an empty slice (`nil`).
    
    @(returns)
    - The slice of monitor handles. The length of the slice is `0` if no monitors were found.
    
    @(errors)
    - @(ref=Error.Not_Initialized)
    
    @(lifetimes)
    - The returned array is allocated and freed by GLFW. You should not free it yourself. It is
    guaranteed to be valid only until the monitor configuration changes or the library is
    terminated.
    
    @(thread_safety=main_only)
    @(since=3.0)
*/
get_monitors :: proc() -> []^Monitor {
    count: i32 = ---
    monitors := glfwGetMonitors(&count)
    return monitors[:count]
}

/*
    Returns the primary monitor.
    
    This function returns the primary monitor. This is usually the monitor where elements like
    the task bar or global menu are located.
    
    @(returns)
    - The primary monitor or `nil` if no monitors were found.
    
    @(errors)
    - @(ref=Error.Not_Initialized)
    
    @(thread_safety=main_thread_only)
    @(since=3.0)
*/
get_primary_monitor :: proc() -> ^Monitor {
    return glfwGetPrimaryMonitor()
}

/*
    Returns the position of the monitor's viewport on the virtual screen.
    
    This function returns the position, in screen coordinates of the upper-left corner of the
    specified monitor.
    
    @(params)
    - monitor: The monitor to query.
    
    @(returns)
    1. The x-coordinate of the monitor's viewport on the virtual screen.
    2. The y-coordinate of the monitor's viewport on the virtual screen.
    
    @(errors)
    - @(ref=Errors.Not_Initialized)
    - @(ref=Errors.Platform_Error)
    
    @(thread_safety=main_thread_only)
    @(since=3.0)
*/
get_monitor_pos :: proc(monitor: ^Monitor) -> (i32, i32) {
    pos_x: i32 = ---
    pos_y: i32 = ---
    glfwGetMonitorPos(monitor, &pos_x, &pos_y)
    return pos_x, pos_y
}

/*
    Retrieves the work area of the monitor.
    
    This function returns the position, in screen coordinates, of the upper-left corner of the work
    area of the specified monitor, along with the size of the work area in screen coordinates. The
    work area is defined as the area of the monitor not occluded by the window system task bar where
    present. If no task bar exists, then the work area is the monitor resolution in screen
    coordinates.
    
    @(params)
    - monitor: The monitor to query.
    
    @(returns)
    1. The x-coordinate of the work area.
    2. The y-coordinate of the work area.
    
    @(errors)
    - @(ref=Error.Not_Initialized)
    - @(ref=Error.Platform_Error)
    
    @(thread_safety=main_thread_only)
    @(since=3.3)
*/
get_monitor_workarea :: proc(monitor: ^Monitor) -> (i32, i32, i32, i32) {
    pos_x: i32 = ---
    pos_y: i32 = ---
    size_x: i32 = ---
    size_y: i32 = ---
    glfwGetMonitorWorkarea(monitor, &pos_x, &pos_y, &size_x, &size_y)
    return pos_x, pos_y, size_x, size_y
}

/*
    Returns the physical size of the monitor.
    
    This function returns the size, in millimetres, of the display area of the specified monitor.
    
    Some platforms do not provide accurate monitor size information, either because monitor's
    [EDID](https://en.wikipedia.org/wiki/Extended_display_identification_data) data is incorrect,
    or because the driver does not report it accurately.
    
    @(params)
    - monitor: The monitor to query.
    
    @(returns)
    1. The width of the monitor, in millimetres, of the monitor's display area.
    2. The height of the monitor, in millimetres, of the monitor's display area.
    
    @(errors)
    - @(ret=Error.Not_Initialized)
    
    @(remark=win32)
    On Windows 8 and earlier the physical size is calculated from the current resolution and system
    DPI instead of querying the monitor EDID data.
    
    @(thread_safety=main_thread_only)
    @(since=3.0)
*/
get_monitor_physical_size :: proc(monitor: ^Monitor) -> (i32, i32) {
    size_x_mm: i32 = ---
    size_y_mm: i32 = ---
    glfwGetMonitorPhysicalSize(monitor, &size_x_mm, &size_y_mm)
    return size_x_mm, size_y_mm
}

/*
    Retrieves the content scale for the specified monitor.
    
    This function retrieves the content scale for the specified monitor. The content scale is the
    ratio between the current DPI and the platfom's default DPI. This is especially important for
    text and any UI elements. If the pixel dimensions of your UI scaled by this value look
    reasonable on your monitor, it should appear at a reasonable size on other monitors regardless
    of their DPI and scaling settings. This relies on the system DPI and scaling settings being
    somewhat correct.
    
    The content scale may depend on both the monitor resolution, pixel density and on the user
    settings. It may be very different from the raw DPI calculated from the physical size and the
    current resolution.
    
    @(params)
    - monitor: The monitor to query.
    
    @(returns)
    1. The x-axis of the content scale.
    2. The y-axis of the content scale.
    
    @(errors)
    - @(ref=Error.Not_Initialized)
    - @(ref=Error.Platform_Error)
    
    @(thread_safety=main_thread_only)
    @(since=3.3)
*/
get_monitor_content_scale :: proc(monitor: ^Monitor) -> (f32, f32) {
    scale_x: f32 = ---
    scale_y: f32 = ---
    glfwGetMonitorContentScale(monitor, &scale_x, &scale_y)
    return scale_x, scale_y
}

/*
    Returns the name of the specified monitor.
    
    This function returns a human-readable name, encoded as UTF-8, of the specified monitor. The
    name typically reflects the make and model of the monitor and is not guaranteed to be unique
    among the connected monitors.
    
    @(params)
    - monitor: The monitor to query
    
    @(returns)
    1. The UTF-8 encoded name of the monitor, or `nil` if an error occurred.
    
    @(errors)
    - @(ref=Error.Not_Initialized)
    
    @(lifetimes)
    The returned string is allocated and freed by GLFW. You should not free it yourself. It is
    valid only until the specified monitor is disconnected or the library is terminated.
    
    @(thread_safety=main_thread_only)
    @(since=3.0)
*/
get_monitor_name :: proc(monitor: ^Monitor) -> cstring {
    return glfwGetMonitorName(monitor)
}

/*
    Sets the user pointer of the specified monitor.
    
    This function sets the user-defined pointer of the specified monitor. The current value is
    retained until the monitor is disconnected. The initial value is `nil`.
    
    @(params)
    - monitor: The monitor whose pointer to set.
    - pointer: The new pointer value to set.
    
    @(reentrancy)
    This function may be called from the monitor callback, or even for a monitor that is being
    disconnected.
    
    @(thread_safety=safe)
    @(since=3.3)
*/
set_monitor_user_pointer :: proc(monitor: ^Monitor, pointer: rawptr) {
    glfwSetMonitorUserPointer(monitor, pointer)
}

/*
    Returns the user pointer of the specified monitor.
    
    This function returns the current value of the user-defined pointer of the specified monitor.
    The initial value is `nil`.
    
    @(params)
    - monitor: The monitor whose pointer to return
    
    @(returns)
    1. The user pointer of the specified monitor
    
    @(reentrancy)
    This function may be called from the monitor callback, or even for a monitor that is being
    disconnected.
    
    @(thread_safety=safe)
    @(since=3.3)
*/
get_monitor_user_pointer :: proc(monitor: ^Monitor) -> rawptr {
    return glfwGetMonitorUserPointer(monitor)
}

/*
    Sets the monitor configuration callback.
    
    This function sets the monitor configuration callback, or removes the currently-set callback.
    This callback function will be called when a monitor is connected or disconnected from the
    system.
    
    @(params)
    - callback: The new callback, or `nil` to remove the currently-set callback.
    
    @(returns)
    1. The previously-set callback or `nil` if no callback was set or the library had not been
    initialized
    
    @(errors)
    - @(ref=Error.Not_Initialized)
    
    @(thread_safety=main_thread_only)
    @(since=3.0)
*/
set_monitor_callback :: proc(callback: Monitor_Proc) -> Monitor_Proc {
    return glfwSetMonitorCallback(callback)
}

/*
    Returns the available video modes for the specified monitor.
    
    This function returns a slice of all video modes supported by the specified monitor. The
    returned array is sorted in ascending order, first by color bit depth (the sum of all
    components), then by resolution area (the product of components), then resolution width
    and finally by refresh rate.
    
    @(params)
    - monitor: The monitor to query
    
    @(returns)
    1. The slice of video modes. In case error occured returns a zero-length `nil` slice.
    
    @(errors)
    - @(ref=Error.Not_Initialized)
    - @(ref=Error.Platform_Error)
    
    @(lifetimes)
    - The returned array is allocated and freed by GLFW. You should not free it yourself. It is
    valid until the specified monitor is disconnected, if this function is called again for that
    monitor, or if the library is terminated.
    
    @(thread_safety=main_thread_only)
    @(since=1.0)
*/
get_video_modes :: proc(monitor: ^Monitor) -> []Video_Mode {
    count: i32 = ---
    modes := glfwGetVideoModes(monitor, &count)
    return modes[:count]
}

/*
    Returns the current mode of the specified monitor.
    
    This function returns the current video mode of the specified monitor. If you have created a
    full-screen window for that monitor, the return value will depend on whether that window is
    iconified.
    
    @(params)
    - monitor: The monitor to query
    
    @(returns)
    - The current mode of the monitor, or `nil` if an error occurred.
    
    @(errors)
    - @(ref=Error.Not_Initialized)
    - @(ref=Error.Platform_Error)
    
    @(thread_safety=main_thread_only)
    @(since=3.0)
*/
get_video_mode :: proc(monitor: ^Monitor) -> ^Video_Mode {
    return glfwGetVideoMode(monitor)
}

/*
    Generates a gamma ramp and sets it for the specified monitor.
    
    This function generates an appropriately-sized gamma ramp from the specified exponent and then
    calls @(ref=set_gamma_ramp) with it. The value `gamma` must be a finite number greater than
    zero.
    
    The software controlled gamma ramp is applied *in addition* to the hardware gamma correction,
    which today is usually an approximation of sRGB gamma. This means that setting a perfectly
    linear ramp, or gamma `1.0`, will produce the default (sRGB-like) behaviour.
    
    For gamma-correct rendering with OpenGL or OpenGL ES see @(ref=Window_Hint.SRGB_Capable) hint.
    
    @(params)
    - monitor: The monitor whose gamma ramp to set
    - gamma: The desired exponent
    
    @(errors)
    - @(ref=Error.Not_Initialized)
    - @(ref=Error.Invalid_Value)
    - @(ref=Error.Platform_Error)
    - @(ref=Error.Feature_Unavailable)
    
    @(remark=wayland)
    Under wayland gamma handling is a priviliged protocol, this function will this never be
    implemented and emits @(ref=Error.Feature_Unavailable)
    
    @(thread_safety=main_thread_only)
    @(since=3.0)
*/
set_gamma :: proc(monitor: ^Monitor, gamma: f32) {
    glfwSetGamma(monitor, gamma)
}

/*
    Returns the current gamma ramp for the specified monitor.
    
    This function returns the current gamma ramp of the specified monitor.
    
    @(params)
    - monitor: The monitor to query.
    
    @(returns)
    - The current gamma ramp or `nil` if an error occurred.
    
    @(errors)
    - @(ref=Error.Not_Initialized)
    - @(ref=Error.Platform_Error)
    - @(ref=Error.Feature_Unavailable)
    
    @(remark=wayland)
    Under wayland gamma handling is a priviliged protocol, this function will this never be
    implemented and emits @(ref=Error.Feature_Unavailable)
    
    @(pointer_lifetime)
    The returned structure and its arrays are allocated and freed by GLFW. You should not free them
    yourself. They are valid until the specified monitor is disconnected, this function is called
    again for that monitor or the library is terminated.
    
    @(thread_safety=main_thread_only)
    @(since=3.0)
*/
get_gamma_ramp :: proc(monitor: ^Monitor) -> ^Gamma_Ramp {
    return glfwGetGammaRamp(monitor)
}

/*
    Sets the current gamma ramp for the specified monitor.
    
    This function sets the current gamma ramp for the specified monitor. The original gamma ramp
    for that monitor is saved by GLFW the first time this function is called and is restored by
    @(ref=terminate) function.
    
    The software-controlled gamma ramp is applied *in addition* to the hardware gamma correction,
    which today is usually an approximation of sRGB gamma. This means that setting a perfectly
    linear ramp, or gamma 1.0, will produce the default (usually sRGB-like) behavior.
    
    For gamma-correct rendering with OpenGL or OpenGL ES, see @(ref=Window_Hint.SRGB_Capable)
    window hint.
    
    @(params)
    - monitor: The monitor whose gamma ramp to ramp.
    - gamma_ramp: The gamma ramp to use.
    
    @(errors)
    - @(ref=Error.Not_Initialized)
    - @(ref=Error.Platform_Error)
    - @(ref=Error.Feature_Unavailable) (see remarks)
    
    @(remark)
    The size of the specified gamma ramp should match the size of the current ramp for that monitor.
    
    @(remark=win32)
    The gamma ramp size must be 256
    
    @(remark=wayland)
    Gamma handling is a privileged protocool, this function will thus never be implemented and
    emits @(ref=Error.Feature_Unavailable)
    
    @(lifetimes)
    The specified gamma ramp is copied before this function returns.
    
    @(thread_safety=main_thread_only)
    @(since=3.0)
*/
set_gamma_ramp :: proc(monitor: ^Monitor, gamma_ramp: ^Gamma_Ramp) {
    glfwSetGammaRamp(monitor, gamma_ramp)
}

/*
    Resets all window hints to their default values.
    
    This function resets all window hints to their default values.
    
    @(errors)
    - @(ref=Error.Not_Initialized)
    
    @(thread_safety=main_thread_only)
    @(since=3.0)
*/
default_window_hints :: proc() {
    glfwDefaultWindowHints()
}

/*
    Sets the specified window hint to the desired value.
    
    This function sets hints for the next call to @(ref=create_window). The hints, once set retain
    their value until changed by a call to this function or @(ref=default_window_hints), or until
    the library is terminated.
    
    This function is a polymorphic variant accepting hints of integer, boolean, string and various
    enumeration types. You have to ensure you are calling the correct variant. In order to see
    which variant is expected for any specific value of hint, see @(ref=Window_Hint).
    
    This function does not check whether the specified hint values are valid. If you set hints to
    invalid values, this will instead be reported by the next call to @(ref=create_window).
    
    Some hints are platform-specific. These may be set on any platform, but they will only affect
    their specific platform. Other platforms will ignore them.
    
    @(params)
    - hint: The hint to set.
    - value: The value to set the hint to.
    
    @(errors)
    - @(ref=Error.Not_Initialized)
    - @(ref=Error.Invalid_Enum)
    
    @(lifetimes)
    If you provide string as a parameter, the string is copied.
    
    @(thread_safety=main_thread_only)
    @(since=3.0)
*/
window_hint :: proc {
    window_hint_i32,
    window_hint_b32,
    window_hint_cstring,
}

// @(hide)
@(private)
window_hint_i32 :: proc(hint: Window_Hint, value: i32) {
    glfwWindowHint(hint, value)
}

// @(hide)
@(private)
window_hint_b32 :: proc(hint: Window_Hint, value: b32) {
    glfwWindowHint(hint, cast(i32) value)
}

// @(hide)
@(private)
window_hint_cstring :: proc(hint: Window_Hint, value: cstring) {
    glfwWindowHintString(hint, value)
}

/*
    Creates the window and its associated context.
    
    This function creates a window and it's associated OpenGL and OpenGL ES context. Most of the
    options controlling how the window and its context should be created are specified with window
    hints (see @(ref=window_hint)).
    
    Successfull creation does not change which context is current. Before you can use the newly
    created context you need to make it current (see @(ref=make_context_current)).
    
    The meaning of the `share` parameter is as follows: Object sharing is implemented by the
    operating system and the graphics driver. On the platforms where it is possible to choose which
    types of objects are shared, GLFW requests that all types are shared. You might want to see
    the relevant chapters of the [OpenGL](https://www.opengl.org/registry/) and
    [OpenGL ES](https://www.khronos.org/opengles/) docs for more information. The name and number
    of the chapter varies between versions and API's but at times has been named *Shared Objects
    and multiple contexts*.
    
    The created window, the framebuffer and the context may differ from what you requested. Not all
    parameters and hints are hard constraints. In order to see the list of hard constraints, see
    @(ref=Window_Hint). The list of soft constraints includes the size of the window, especially
    for full screen windows. To query the actual attributes of the created window, framebuffer and
    context see @(ref=get_window_attrib), @(ref=get_window_size) and @(ref=get_framebuffer_size).
    
    To create a full screen window, you need to specify the monitor the window will cover. If no
    monitor is specified, the window will be windowed mode. Unless you have a way for the user to
    choose a specific monitor, it is recommended that you pick the primary monitor. In order to
    query available monitors see @(ref=get_monitors)
    
    For full-screen windows, the specified size becomes the resolution of the window's desired
    *video mode*. As long as a full-screen window is not iconified (minimized)m the supported video
    mode most closely matching the desired video mode is set for the specified monitor.
    
    By default, newly created windows use the placement recommended by the window system. To create
    the window at a specific position, set the @(ref=Window_Hint.Position_X) and
    @(ref=Window_Hint.Position_Y) window hints before creation. To restore the default behaviour
    set either or both hints back to @(ref=ANY_POSITION).
    
    As long as at least one full-screen window is not iconified (minimized), the screensaver is
    prohibited from starting.
    
    Window systems put limits on window sizes. Very large or very small window dimensions. You
    might want to check the actual window size after creation.
    
    The *swap interval* is not set during window creation and the initial value may vary depending
    on the driver settings and defaults.
    
    @(params)
    - size_x: The desired width, in screen coordinates, of the window. Must be greater than zero.
    - size_y: The desired height, in screen coordinates, of the window. Must be greater than zero.
    - title: The initial, UTF-8 encoded window title.
    - monitor: The monitor to use for full-screen mode, or `nil` for windowed mode.
    - share: The window whose to share context resources with, or `nil` to not share resources.
    
    @(returns)
    - window: The handle to the created window, or `nil` if an error occurred.
    
    @(errors)
    - @(ref=Error.Not_Initialized)
    - @(ref=Error.Invalid_Enum)
    - @(ref=Error.Invalid_Value)
    - @(ref=Error.Api_Unavailable)
    - @(ref=Error.Version_Unavailable)
    - @(ref=Error.Format_Unavailable)
    - @(ref=Error.Platform_Error)
    
    @(remark=win32)
    Window creation will fail if the microsoft GDI software OpenGL implementation is the only one
    available.
    
    @(remark=macos)
    The GLFW window has no icon, as it is not a document window, but the dock icon will be the same
    as the application bundle's icon. For more information on bundles see the
    [Bundle Programming Guide](https://developer.apple.com/library/mac/documentation/CoreFoundation/Conceptual/CFBundles/)
    in the Mac Developer Library.
    
    @(remark=macos)
    On OSX 10.10 and later, the window frame will not be rendered at full resolution on Retina
    displays unless the @(ref=Window_Hint.Cocoa_Retina_Framebuffer) hint is set to `true`. And
    the `NSHighResolutionCapable` key is enabled in the applications bundle's `Info.plist`. For
    more information, see
    [High Resolution Guidelines for OS X](https://developer.apple.com/library/mac/documentation/GraphicsAnimation/Conceptual/HighResolutionOSX/Explained/Explained.html).
    in the Mac Developer Library.
    
    @(remark x11)
    Some window managers will not respect the placement of initially-hidden windows.
    
    @(remark x11)
    Due to the asynchronous nature of X11, it may take a moment for the window to reach its
    requested state. This means that you may not be able to query the final size, position or other
    attributes directly after window creation.
    
    @(remark x11)
    The class part of the `WM_CLASS` window property will by default be set to the window title
    passed to this function. The instance part will use the contents of `RESOURCE_NAME` environment
    variable, if present and not empty, or fall back to the window title. Set the
    @(ref=Window_Hint.X11_Class_Name) and @(ref=Window_Hint.X11_Instance_Name) window hints to
    override this behavior.
    
    @(remark=wayland)
    Compositors should implement the `xdg-decoration` protocol for GLFW to decorate the window
    properly. If this protocol isn't supported, or if the compositor prefers client-side decorations,
    a very simple fallback frame will be drawn using the `wp_viewporter` protocol. A compositor
    can still emit `close`, `maximize` and `fullscreen` events, using, for instance a keybind
    mechanism. If neither of these protocols is supported, the window won't be decorated.
    
    @(remark=wayland)
    Screensaver inhibition requires the idle-inhibit protocol to be implemented in the user's
    compositor.
    
    @(thread_safety=main_thread_only)
    @(since=3.0)
*/
create_window :: proc(
    size_x:  i32,
    size_y:  i32,
    title:   cstring,
    monitor: ^Monitor = nil,
    share:   ^Window  = nil,
) -> ^Window {
    return glfwCreateWindow(size_x, size_y, title, monitor, share)
}

/*
    Destroys the specified window and its associated context.
    
    This function destroys the specified window and its context. On calling this function no
    further callbacks will be called for that window.
    
    If the context of the specified window is current on the main thread, it is detached before
    being destroyed.
    
    @(params)
    - window: The window to destroy
    
    @(errors)
    - @(ref=Error.Not_Initialized)
    - @(ref=Error.Platform_Error)
    
    @(note)
    The context of the specified window must not be current on any other thread when this function
    is called.
    
    @(reentrancy)
    This function must not be called within a callback.
    
    @(thread_safety=main_thread_only)
    @(since=3.0)
*/
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
