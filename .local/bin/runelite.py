import os
import subprocess
import sys

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

    try:
        for event in mouse.read_loop():
            # Check if it's a button press we want to intercept
            if event.type == ecodes.EV_KEY and event.value == 1:
                window_id = get_active_window_id()
                if window_id:
                    window_class = get_window_class(window_id)
                    window_name = get_window_name(window_id)

                    # Check if it's RuneLite by window name
                    if window_name and "runelite" in window_name.lower():
                        if event.code == 275:  # Mouse button (back/forward)
                            send_key_to_window(window_id, "space")
                            continue  # Don't pass through this event
                        elif event.code == 276:  # Mouse button (back/forward)
                            send_key_to_window(window_id, "Escape")
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
