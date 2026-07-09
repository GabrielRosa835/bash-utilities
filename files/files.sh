#!/bin/bash

# Default variables
TARGET_FILE=""
APP_NAME=""
CMD=""
EXEC_COMPLEX=""
ICON=""
CATEGORIES=""
SCOPE="user"

# Help output
show_help() {
    echo "Usage: files -f <file_path> [OPTIONS]"
    echo "Registers a specific file as a desktop application."
    echo ""
    echo "Options:"
    echo "  -f, --file <path>        Path to the target file (Required)"
    echo "  -n, --name <name>        App name (Default: file's base name)"
    echo "  -c, --cmd <command>      Simple command to open the file (e.g., 'nvim')"
    echo "  -e, --exec <command>     Complex Exec string (Precedes --cmd)"
    echo "  -i, --icon <icon>        Icon name or absolute path"
    echo "  -C, --categories <cats>  Categories, separated by ':' (e.g., 'Development:Utility')"
    echo "  -s, --system             Register for all users in /usr/share/applications (requires sudo)"
    echo "  -h, --help               Show this help message"
}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -f|--file) TARGET_FILE="$2"; shift ;;
        -n|--name) APP_NAME="$2"; shift ;;
        -c|--cmd) CMD="$2"; shift ;;
        -e|--exec) EXEC_COMPLEX="$2"; shift ;;
        -i|--icon) ICON="$2"; shift ;;
        -C|--categories) CATEGORIES="$2"; shift ;;
        -s|--system) SCOPE="system" ;;
        -h|--help) show_help; exit 0 ;;
        *) echo "Error: Unknown parameter '$1'"; show_help; exit 1 ;;
    esac
    shift
done

# --- Validation ---

if [[ -z "$TARGET_FILE" ]]; then
    echo "Error: Target file is required. Use -f or --file."
    exit 1
fi

if [[ ! -e "$TARGET_FILE" ]]; then
    echo "Error: File '$TARGET_FILE' does not exist."
    exit 1
fi

# Get the absolute path to ensure the desktop shortcut works from anywhere
TARGET_FILE=$(realpath "$TARGET_FILE")

# --- Process Parameters ---

# 1. Determine App Name
if [[ -z "$APP_NAME" ]]; then
    APP_NAME=$(basename "$TARGET_FILE")
fi

# 2. Determine Exec Line (Complex takes precedence over Simple)
if [[ -n "$EXEC_COMPLEX" ]]; then
    EXEC_LINE="$EXEC_COMPLEX"
elif [[ -n "$CMD" ]]; then
    EXEC_LINE="$CMD \"$TARGET_FILE\""
else
    # Fallback if neither is provided
    EXEC_LINE="xdg-open \"$TARGET_FILE\""
fi

# 3. Determine Scope and Destination
if [[ "$SCOPE" == "system" ]]; then
    # System-wide needs root
    if [[ "$EUID" -ne 0 ]]; then
        echo "Error: System-wide registration (-s) requires root privileges. Please run with sudo."
        exit 1
    fi
    DEST_DIR="/usr/share/applications"
else
    DEST_DIR="$HOME/.local/share/applications"
    mkdir -p "$DEST_DIR"
fi

# Create a safe filename for the .desktop file
SAFE_NAME=$(echo "$APP_NAME" | tr '[:space:]' '_' | tr '[:upper:]' '[:lower:]')
DESKTOP_FILE="$DEST_DIR/${SAFE_NAME}.desktop"

# --- Generate .desktop File ---

echo "Generating .desktop file at: $DESKTOP_FILE"

cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Version=1.0
Type=Application
Name=$APP_NAME
Exec=$EXEC_LINE
EOF

# Append optional fields
if [[ -n "$ICON" ]]; then
    echo "Icon=$ICON" >> "$DESKTOP_FILE"
fi

if [[ -n "$CATEGORIES" ]]; then
    # Convert ':' to ';' and ensure it ends with a ';' as per FreeDesktop standards
    FORMATTED_CATS=$(echo "$CATEGORIES" | tr ':' ';')
    [[ "${FORMATTED_CATS: -1}" != ";" ]] && FORMATTED_CATS="${FORMATTED_CATS};"
    echo "Categories=$FORMATTED_CATS" >> "$DESKTOP_FILE"
fi

# Make it executable (required for some desktop environments to trust the file)
chmod +x "$DESKTOP_FILE"

# Update desktop database so the app menu recognizes it immediately
update-desktop-database "$DEST_DIR" 2>/dev/null || true

echo "Success! '$APP_NAME' is now registered."