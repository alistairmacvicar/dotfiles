import os
import subprocess
import sys
import time
import threading

from evdev import InputDevice, UInput, ecodes


def get_active_window_id():
    """Get the currently focused window ID."""
    try:
        result = subprocess.run(
            ["xdotool", "getactivewindow"], capture_output=True, text=True
        )
        return result.stdout.strip()
    except Exception as e:
        print(f"Error getting active window: {e}")
        return None


def get_window_class(window_id):
    """Get the class name of a window."""
    try:
        result = subprocess.run(
            ["xdotool", "getwindowclassname", window_id], capture_output=True, text=True
        )
        return result.stdout.strip()
    except Exception:
        return None


def get_window_name(window_id):
    """Get the name of a window."""
    try:
        result = subprocess.run(
            ["xdotool", "getwindowname", window_id], capture_output=True, text=True
        )
        return result.stdout.strip()
    except Exception:
        return None


def send_key_to_window(window_id, key):
    """Send a key to a specific window."""
    subprocess.run(["xdotool", "key", "--clearmodifiers", key])


def send_keydown(window_id, key):
    """Send a keydown event to a specific window."""
    subprocess.run(["xdotool", "keydown", "--clearmodifiers", key])


def send_keyup(window_id, key):
    """Send a keyup event to a specific window."""
    subprocess.run(["xdotool", "keyup", "--clearmodifiers", key])


def disable_mouse_accel_on_virtual_device(device_name="mouse-passthrough", max_retries=10):
    """Disable mouse acceleration on the virtual passthrough device."""
    for attempt in range(max_retries):
        try:
            # Get list of xinput devices
            result = subprocess.run(
                ["xinput", "--list"], capture_output=True, text=True
            )
            
            # Find device ID for our virtual device
            for line in result.stdout.split('\n'):
                if device_name in line and 'pointer' in line.lower():
                    # Extract the device ID
                    import re
                    match = re.search(r'id=(\d+)', line)
                    if match:
                        device_id = match.group(1)
                        print(f"Found virtual device ID: {device_id}")
                        
                        # Disable mouse acceleration (set to flat profile)
                        subprocess.run(
                            ["xinput", "--set-prop", device_id, 
                             "libinput Accel Profile Enabled", "0", "1"],
                            stderr=subprocess.DEVNULL
                        )
                        print(f"Disabled mouse acceleration on virtual device {device_id}")
                        return True
            
            # Device not found yet, wait and retry
            time.sleep(0.5)
        except Exception as e:
            print(f"Error disabling mouse accel (attempt {attempt+1}): {e}")
            time.sleep(0.5)
    
    print(f"Warning: Could not disable mouse acceleration on {device_name} after {max_retries} attempts")
    return False


def main():
    # Find mouse device
    mouse = None
    by_id_path = "/dev/input/by-id/"

    if os.path.exists(by_id_path):
        for device_name in os.listdir(by_id_path):
            if "mouse" in device_name.lower() and "event" in device_name.lower():
                try:
                    device_path = os.path.join(by_id_path, device_name)
                    mouse = InputDevice(device_path)
                    print(f"Found mouse: {mouse.name} at {device_path}")
                    break
                except Exception:
                    continue

    if not mouse:
        print("Could not find mouse device. Run 'ls -l /dev/input/by-id/' to find it.")
        sys.exit(1)

    print("Monitoring mouse buttons. Press Ctrl+C to stop")

    # Create a virtual input device to pass through events
    ui = UInput.from_device(mouse, name="mouse-passthrough")
    mouse.grab()  # Grab exclusive access
    
    # Disable mouse acceleration on the virtual device in a separate thread
    accel_thread = threading.Thread(target=disable_mouse_accel_on_virtual_device, daemon=True)
    accel_thread.start()

    try:
        for event in mouse.read_loop():
            # Check if it's a button press or release we want to intercept
            if event.type == ecodes.EV_KEY and event.value in [0, 1]:
                window_id = get_active_window_id()
                if window_id:
                    window_class = get_window_class(window_id)
                    window_name = get_window_name(window_id)

                    # Check if it's RuneLite by window name
                    if window_name and "runelite" in window_name.lower():
                        intercepted = False
                        
                        if event.code == 275:  # Mouse button (back/forward)
                            if event.value == 1:  # Button pressed
                                send_keydown(window_id, "space")
                            else:  # Button released (value == 0)
                                send_keyup(window_id, "space")
                            intercepted = True
                        elif event.code == 276:  # Mouse button (back/forward)
                            if event.value == 1:  # Button pressed
                                send_keydown(window_id, "Escape")
                            else:  # Button released (value == 0)
                                send_keyup(window_id, "Escape")
                            intercepted = True
                        
                        if intercepted:
                            continue  # Don't pass through this event

            # Pass through all other events
            ui.write_event(event)
            ui.syn()
    except KeyboardInterrupt:
        print("\nStopping...")
    finally:
        mouse.ungrab()
        ui.close()


if __name__ == "__main__":
    main()
