
package glfw

VERSION_MAJOR :: 3
VERSION_MINOR :: 3
VERSION_PATCH :: 8

TRUE  :: true
FALSE :: false

// TODO: Integrations with vulkan and OpenGL
VkInstance       :: distinct rawptr
VkPhysicalDevice :: distinct rawptr

/*
    Key and button actions.
*/
Action :: enum i32 {
    Release = 0,
    Press   = 1,
    Repeat  = 2,
}

Joystick_Button_State :: enum u8 {
    Release = 0,
    Press   = 1,
}

/*
    Joystick hat states.
    In order to specify centered use HAT_CENTERED constant.
*/
Hat_State :: bit_set[Hat_State_Bits; u8]
Hat_State_Bits :: enum {
    Up    = 0,
    Right = 1,
    Down  = 2,
    Left  = 3,
}

HAT_CENTERED   :: Hat_State{}
HAT_UP         :: Hat_State{.Up}
HAT_RIGHT      :: Hat_State{.Right}
HAT_DOWN       :: Hat_State{.Down}
HAT_LEFT       :: Hat_State{.Left}
HAT_RIGHT_UP   :: Hat_State{.Right, .Up}
HAT_RIGHT_DOWN :: Hat_State{.Right, .Down}
HAT_LEFT_UP    :: Hat_State{.Left,  .Up}
HAT_LEFT_DOWN  :: Hat_State{.Left,  .Down}

/*
    Keyboard keys.
*/
Key :: enum i32 {
    Space         = 32,
    Apostrophe    = 39,
    Comma         = 44,
    Minus         = 45,
    Period        = 46,
    Slash         = 47,
    Key0          = 48,
    Key1          = 49,
    Key2          = 50,
    Key3          = 51,
    Key4          = 52,
    Key5          = 53,
    Key6          = 54,
    Key7          = 55,
    Key8          = 56,
    Key9          = 57,
    Semicolon     = 59,
    Equal         = 61,
    A             = 65,
    B             = 66,
    C             = 67,
    D             = 68,
    E             = 69,
    F             = 70,
    G             = 71,
    H             = 72,
    I             = 73,
    J             = 74,
    K             = 75,
    L             = 76,
    M             = 77,
    N             = 78,
    O             = 79,
    P             = 80,
    Q             = 81,
    R             = 82,
    S             = 83,
    T             = 84,
    U             = 85,
    V             = 86,
    W             = 87,
    X             = 88,
    Y             = 89,
    Z             = 90,
    Left_Bracked  = 91,
    Backslash     = 92,
    Right_Bracked = 93,
    Grave_Accent  = 96,
    World1        = 161,
    World2        = 162,
    Escape        = 256,
    Enter         = 257,
    Tab           = 258,
    Backspace     = 259,
    Insert        = 260,
    Delete        = 261,
    Right         = 262,
    Left          = 263,
    Down          = 264,
    Up            = 265,
    Page_Up       = 266,
    Page_Down     = 267,
    Home          = 268,
    End           = 269,
    Caps_Lock     = 280,
    Scroll_Lock   = 281,
    Num_Lock      = 282,
    Print_Screen  = 283,
    Pause         = 284,
    F1            = 290,
    F2            = 291,
    F3            = 292,
    F4            = 293,
    F5            = 294,
    F6            = 295,
    F7            = 296,
    F8            = 297,
    F9            = 298,
    F10           = 299,
    F11           = 300,
    F12           = 301,
    F13           = 302,
    F14           = 303,
    F15           = 304,
    F16           = 305,
    F17           = 306,
    F18           = 307,
    F19           = 308,
    F20           = 309,
    F21           = 310,
    F22           = 311,
    F23           = 312,
    F24           = 313,
    F25           = 314,
    KP0           = 320,
    KP1           = 321,
    KP2           = 322,
    KP3           = 323,
    KP4           = 324,
    KP5           = 325,
    KP6           = 326,
    KP7           = 327,
    KP8           = 328,
    KP9           = 329,
    KP_Decimal    = 330,
    KP_Divide     = 331,
    KP_Multiply   = 332,
    KP_Subtract   = 333,
    KP_Add        = 334,
    KP_Enter      = 335,
    KP_Equal      = 336,
    Left_Shift    = 340,
    Left_Control  = 341,
    Left_Alt      = 342,
    Left_Suprt    = 343,
    Right_Shift   = 344,
    Right_Control = 345,
    Right_Alt     = 346,
    Right_Suprt   = 347,
    Menu          = 348, Last = Menu,
}

KEY_UNKNOWN :: Key(-1)
KEY_LAST    :: Key(.Menu)

/*
    Modifier key flags.
*/
Mod :: bit_set[Mod_Bits; i32]
Mod_Bits :: enum {
    Shift     = 0,
    Control   = 1,
    Alt       = 2,
    Suprt     = 3,
    Caps_Lock = 4,
    Num_Lock  = 5,
}

/*
    Mouse buttons.
*/
Mouse_Button :: enum i32 {
    Button1 = 0, Left   = Button1,
    Button2 = 1, Right  = Button2,
    Button3 = 2, Middle = Button3,
    Button4 = 3,
    Button5 = 4,
    Button6 = 5,
    Button7 = 6,
    Button8 = 7, Last = Button8,
}

/*
    Joystick IDs.
*/
Joystick :: enum i32 {
    Joystick1  = 0,
    Joystick2  = 1,
    Joystick3  = 2,
    Joystick4  = 3,
    Joystick5  = 4,
    Joystick6  = 5,
    Joystick7  = 6,
    Joystick8  = 7,
    Joystick9  = 8,
    Joystick10 = 9,
    Joystick11 = 10,
    Joystick12 = 11,
    Joystick13 = 12,
    Joystick14 = 13,
    Joystick15 = 14,
    Joystick16 = 15, Last = Joystick16,
}

/*
    Gamepad buttons.
*/
Gamepad_Button :: enum i32 {
    A            = 0, Cross    = A,
    B            = 1, Circle   = B,
    X            = 2, Square   = X,
    Y            = 3, Triangle = Y,
    Left_Bumper  = 4,
    Right_Bumper = 5,
    Back         = 6,
    Start        = 7,
    Guide        = 8,
    Left_Thumb   = 9,
    Right_Thumb  = 10,
    DPad_Up      = 11,
    DPad_Right   = 12,
    DPad_Down    = 13,
    DPad_Left    = 14, Last = DPad_Left,
}

/*
    Gamepad axes.
*/
Gamepad_Axis :: enum i32 {
    Left_X        = 0,
    Left_Y        = 1,
    Right_X       = 2,
    Right_Y       = 3,
    Left_Trigger  = 4,
    Right_Trigger = 5, Last = Right_Trigger,
}

/*
    GLFW Error codes.
*/
Error :: enum i32 {
    No_Error            = 0,
    Not_Initialized     = 0x00010001,
    No_Current_Context  = 0x00010002,
    Invalid_Enum        = 0x00010003,
    Invalid_Value       = 0x00010004,
    Out_Of_Memory       = 0x00010005,
    Api_Unavailable     = 0x00010006,
    Version_Unavailable = 0x00010007,
    Platform_Error      = 0x00010008,
    Format_Unavailable  = 0x00010009,
    No_Window_Context   = 0x0001000a,
}

Window_Hint :: enum i32 {
    Focused                  = 0x00020001,
    Iconified                = 0x00020002,
    Resizable                = 0x00020003,
    Visible                  = 0x00020004,
    Decorated                = 0x00020005,
    Auto_Iconify             = 0x00020006,
    Floating                 = 0x00020007,
    Maximized                = 0x00020008,
    Center_Cursor            = 0x00020009,
    Transparent_Framebuffer  = 0x0002000a,
    Hovered                  = 0x0002000b,
    Focus_On_Show            = 0x0002000c,
    Red_Bits                 = 0x00021001,
    Green_Bits               = 0x00021002,
    Blue_Bits                = 0x00021003,
    Alpha_Bits               = 0x00021004,
    Depth_Bits               = 0x00021005,
    Stencil_Bits             = 0x00021006,
    Accum_Red_Bits           = 0x00021007,
    Accum_Green_Bits         = 0x00021008,
    Accum_Blue_Bits          = 0x00021009,
    Accum_Alpha_Bits         = 0x0002100a,
    Aux_Buffers              = 0x0002100b,
    Stereo                   = 0x0002100c,
    Samples                  = 0x0002100d,
    SRGB_Capable             = 0x0002100e,
    Refresh_Rate             = 0x0002100f,
    Doublebuffer             = 0x00021010,
    Client_API               = 0x00022001,
    Context_Version_Major    = 0x00022002,
    Context_Version_Minor    = 0x00022003,
    Context_Revision         = 0x00022004,
    Context_Robustness       = 0x00022005,
    OpenGL_Forward_Compat    = 0x00022006,
    OpenGL_Debug_Context     = 0x00022007,
    OpenGL_Profile           = 0x00022008,
    Context_Release_Behavior = 0x00022009,
    Context_No_Error         = 0x0002200a,
    Context_Creation_API     = 0x0002200b,
    Scale_To_Monitor         = 0x0002200c,
    Cocoa_Retina_Framebuffer = 0x00023001,
    Cocoa_Frame_Name         = 0x00023002,
    Cocoa_Graphics_Switching = 0x00023003,
    X11_Class_Name           = 0x00024001,
    X11_Instance_Name        = 0x00024002,
}

Client_API :: enum i32 {
    No_Api        = 0,
    OpenGL_API    = 0x00030001,
    OpenGL_ES_API = 0x00030002,
}

Context_Robustness :: enum i32 {
    No_Robustness         = 0,
    No_Reset_Notification = 0x00031001,
    Lose_Context_On_Reset = 0x00031002,
}

OpenGL_Profile :: enum i32 {
    Any_Profile    = 0,
    Core_Profile   = 0x00032001,
    Compat_Profile = 0x00032002,
}

Input_Mode :: enum i32 {
    Cursor               = 0x00033001,
    Sticky_Keys          = 0x00033002,
    Sticky_Mouse_Buttons = 0x00033003,
    Lock_Key_Mods        = 0x00033004,
    Raw_Mouse_Motion     = 0x00033005,
}

Cursor_Mode :: enum i32 {
    Normal   = 0x00034001,
    Hidden   = 0x00034002,
    Disabled = 0x00034003,
}

Context_Release_Behavior :: enum i32 {
    Any   = 0,
    Flush = 0x00035001,
    None  = 0x00035002,
}

Context_Creation_API :: enum i32 {
    Native = 0x00036001,
    EGL    = 0x00036002,
    OSMESA = 0x00036003,
}

Cursor_Shape :: enum i32 {
    Arrow     = 0x00036001,
    IBeam     = 0x00036002,
    Crosshair = 0x00036003,
    Hand      = 0x00036004,
    HResize   = 0x00036005,
    VResize   = 0x00036006,
}

Connection_Event :: enum i32 {
    Connected    = 0x00040001,
    Disconnected = 0x00040002,
}

Init_Hint :: enum i32 {
    Joystick_Hat_Buttons  = 0x00050001,
    Cocoa_Chdir_Resources = 0x00051001,
    Cocoa_Menubar         = 0x00051002,
}

DONT_CARE :: -1
