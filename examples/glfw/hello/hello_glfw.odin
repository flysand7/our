
package hello

import "core:os"
import "core:log"
import "our:glfw3"
import "core:runtime"

glfw_error_callback :: proc "c" (error: glfw3.Error, description: cstring) {
    context = runtime.default_context()
    log.errorf("%v: %s", error, description)
    os.exit(1)
}

glfw_key_callback :: proc "c" (window: ^glfw3.Window, key: glfw3.Key, scancode: i32, action: glfw3.Action, mods: glfw3.Mod) {
    context = runtime.default_context()
    log.debugf("Key %v was changed.", key)
    if key == .Escape {
        glfw3.set_window_should_close(window, true)
    }
}

main :: proc() {
    major, minor, _ := glfw3.get_version()
    if major < glfw3.VERSION_MAJOR {
        if minor < glfw3.VERSION_MINOR {
            log.fatalf("Version of GLFW installed in the system is too old to run this example (not really, I'm just flexing)\n")
            os.exit(1)
        }
    }
    glfw3.set_error_callback(glfw_error_callback)
    if !glfw3.init() {
        log.fatalf("Unable to initialize GLFW\n")
        os.exit(1)
    }
    defer glfw3.terminate()
    window := glfw3.create_window(1280, 720, "Hello")
    defer glfw3.destroy_window(window)
    glfw3.set_key_callback(window, glfw_key_callback)
    for !glfw3.window_should_close(window) {
        glfw3.poll_events()
    }
}
