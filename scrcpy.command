#!/bin/zsh

# Prevent history saving to keep session clean
unset HISTFILE
setopt HIST_NO_STORE
setopt NO_HIST_SAVE_NO_DUPS
setopt NO_SHARE_HISTORY
setopt NO_APPEND_HISTORY

# Remove zsh cache files for a fresh session
rm -f ~/.zsh_history ~/.zcompdump*

# Disable terminal session state saving
unset TMOUT
unset SHELL_SESSION_HISTORY

# Clean up on Ctrl+C (reset terminal and remove cache files)
trap 'tput reset; rm -f ~/.zsh_history ~/.zcompdump*; echo -e "\033[1;32m✔ Cleaned up and exiting.\033[0m"; exit' SIGINT

# Clear screen for a fresh start
clear

# Display a visually appealing prompt for scrcpy configuration
echo -e "\033[1;34m========================================\033[0m"
echo -e "\033[1;36m       scrcpy Configuration Menu       \033[0m"
echo -e "\033[1;34m========================================\033[0m"
echo -e "\033[1;33mEnter resolution for scrcpy -m (e.g., 720):"
echo -e "\033[1;33m(Press Enter to use default scrcpy -d)\033[0m"
echo -e "\033[1;34m----------------------------------------\033[0m"
read number

# Set scrcpy command based on user input
if [[ -n "$number" && "$number" =~ ^[0-9]+$ ]]; then
    scrcpy_cmd=(scrcpy -d -m "$number")
else
    scrcpy_cmd=(scrcpy -d)
fi

# Initialize counters
retry_count=0              # Tracks attempts within a block
block_count=0              # Tracks completed blocks of 100 attempts
max_attempts_per_block=50 # Maximum attempts before prompting user

# Function to display a dynamic progress bar for the 60-second countdown
show_progress_bar() {
    local remaining=$1
    local total=60
    local width=30  # Width of the progress bar
    local filled=$(( (total - remaining) * width / total ))
    local empty=$(( width - filled ))
    local bar=""
    # Build the filled part of the bar with █ characters
    for ((i=0; i<filled; i++)); do bar+="█"; done
    # Build the empty part of the bar with spaces
    for ((i=0; i<empty; i++)); do bar+=" "; done
    # Display the bar and remaining time, overwriting the current line
    echo -ne "\r\033[1;33m[$bar] ${remaining} seconds remaining\033[0m"
}

while true; do
    # Check if a block of 100 attempts is complete
    if [[ $retry_count -ge $max_attempts_per_block ]]; then
        ((block_count++))
        clear
        # Display retry prompt with a clean, bordered layout
        echo -e "\033[1;34m========================================\033[0m"
        echo -e "\033[1;36m       scrcpy Retry Prompt       \033[0m"
        echo -e "\033[1;34m========================================\033[0m"
        echo -e "\033[1;32mCompleted $((block_count * max_attempts_per_block)) attempts.\033[0m"
        echo -e "\033[1;33mContinue running scrcpy? (y/n, timeout in 60 seconds):\033[0m"
        echo -e "\033[1;34m----------------------------------------\033[0m"

        # Dynamic countdown with progress bar
        response=""
        remaining=60
        while [[ $remaining -gt 0 ]]; do
            show_progress_bar $remaining
            # Read a single character with a 1-second timeout
            read -t 1 -k 1 input
            if [[ $? -eq 0 ]]; then
                response=$input
                # Exit loop if a valid response is received
                if [[ $response == "y" || $response == "Y" || $response == "n" || $response == "N" ]]; then
                    break
                fi
            fi
            ((remaining--))
        done

        # Clear the progress bar line for a clean exit
        echo -ne "\r\033[K"
        # Exit if user doesn't press 'y' or 'Y'
        if [[ $response != "y" && $response != "Y" ]]; then
            clear
            echo -e "\033[1;32m✔ No 'y' entered or timeout reached. Cleaned up and exiting.\033[0m"
            tput reset
            rm -f ~/.zsh_history ~/.zcompdump*
            exit
        fi
        # Reset retry counter for the next block
        retry_count=0
    fi

    # Clear screen before each scrcpy attempt
    clear
    if [[ $retry_count -eq 0 ]]; then
        # First attempt in a block: show command without retry count
        echo -e "\033[1;32m🚀 Running: ${scrcpy_cmd[*]}\033[0m"
    else
        # Subsequent attempts: show retry count
        echo -e "\033[1;32m🚀 Retry attempt $retry_count: Running ${scrcpy_cmd[*]}\033[0m"
    fi

    # Execute the scrcpy command
    "${scrcpy_cmd[@]}"
    # Display failure message and wait before retrying
    echo -e "\033[1;31m❌ scrcpy failed, retrying in 1 second...\033[0m"
    sleep 1
    # Increment retry counter
    ((retry_count++))
done