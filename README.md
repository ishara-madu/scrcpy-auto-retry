# scrcpy-auto-retry

## Purpose
The purpose of this script is to simplify the use of `scrcpy` (a tool for displaying and controlling Android devices from a computer) on macOS by:
- Allowing users to specify a custom resolution or use the default `scrcpy` settings.
- Automatically retrying `scrcpy` execution on failure with a short delay.
- Providing a clean and visually appealing interface with progress bars and prompts.
- Ensuring a clean session by disabling Zsh history and removing cache files on exit.

## Features
- **Custom Resolution Input**: Users can specify a resolution (e.g., 720) for `scrcpy -m` or use the default settings.
- **Automatic Retries**: Retries `scrcpy` execution on failure with a 1-second delay.
- **Progress Bar**: Displays a dynamic progress bar during the 60-second timeout for user prompts.
- **Session Cleanup**: Prevents Zsh history saving and removes cache files (`~/.zsh_history`, `~/.zcompdump*`) on exit or Ctrl+C.
- **User-Friendly Interface**: Clear prompts and a clean layout with colored output for better readability.
- **Retry Prompt**: After 50 attempts, prompts the user to continue or exit with a 60-second timeout.

## Prerequisites
- **macOS**: This script is designed for macOS, as it uses a `.command` file executable in Terminal.app.
- **Zsh**: The script is written for the Zsh shell, which is the default shell on macOS (since macOS Catalina).
- **scrcpy**: Must be installed and accessible in the system's PATH (e.g., via Homebrew: `brew install scrcpy`).
- **Android Device**: A connected Android device with USB debugging enabled.

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/scrcpy-auto-retry.git
   ```
2. Navigate to the repository directory:
   ```bash
   cd scrcpy-auto-retry
   ```
3. Ensure the script is executable:
   ```bash
   chmod +x scrcpy-auto-retry.command
   ```

## Usage
The script is packaged as a `.command` file, which is macOS-specific and can be run in several ways using a Zsh terminal (Terminal.app on macOS):

1. **Double-Click to Run**:
   - Locate the `scrcpy-auto-retry.command` file in Finder.
   - Double-click the file to automatically open it in Terminal.app and execute the script.
   - Note: If macOS blocks the file (due to security settings), right-click the file, select **Open**, and confirm to allow execution.

2. **Right-Click to Open in Terminal**:
   - In Finder, right-click the `scrcpy-auto-retry.command` file.
   - Select **Open With** > **Terminal** (or **Terminal.app**).
   - This will launch the script in a new Terminal window.

3. **Direct Execution in Terminal**:
   Navigate to the script's directory and run:
   ```bash
   ./scrcpy-auto-retry.command
   ```

4. **Absolute Path Execution**:
   Run the script using its full path:
   ```bash
   /path/to/scrcpy-auto-retry/scrcpy-auto-retry.command
   ```

5. **Using Zsh Explicitly**:
   If Zsh is not your default shell, explicitly invoke it:
   ```bash
   zsh ./scrcpy-auto-retry.command
   ```

6. **Running from Any Directory**:
   If the script is in your PATH, you can run it directly:
   ```bash
   scrcpy-auto-retry.command
   ```
   To add it to your PATH, move the script to a directory like `/usr/local/bin` and ensure it's executable:
   ```bash
   sudo mv scrcpy-auto-retry.command /usr/local/bin/
   sudo chmod +x /usr/local/bin/scrcpy-auto-retry.command
   ```

**Steps After Launch**:
- Enter a resolution for `scrcpy -m` (e.g., `720`) when prompted, or press Enter to use the default settings.
- The script will attempt to run `scrcpy`. If it fails, it will retry automatically with a 1-second delay.
- After 50 attempts, the script will prompt you to continue (`y`) or exit (`n` or timeout after 60 seconds).
- Press `Ctrl+C` at any time to exit cleanly, resetting the terminal and removing cache files.

## Screenshots
Below are screenshots demonstrating the script's interface in action:

| **Configuration Menu** | **Progress Bar & Retry Prompt** |
|------------------------|------------------|
| ![Configuration Menu](https://github.com/ishara-madu/scrcpy-auto-retry/raw/main/screenshots/configuration_menu.png)<br>Shows the initial prompt for entering the scrcpy resolution. | ![Progress Bar](https://github.com/ishara-madu/scrcpy-auto-retry/raw/main/screenshots/progress_bar.png)<br>Displays the dynamic progress bar during the 60-second timeout and Shows the prompt after 50 attempts asking to continue or exit.
*Replace the placeholder URLs above with the actual URLs of your hosted screenshots.*


## Notes
- The script uses Zsh-specific features (`setopt`, `read -k`, etc.) and is designed to run in a Zsh environment, which is the default on macOS.
- Ensure `scrcpy` is properly configured and your Android device is connected via USB with debugging enabled.
- The script prevents history saving to maintain a clean session, which is useful for privacy or debugging purposes.
- The progress bar and colored output enhance the user experience but require a terminal that supports ANSI escape codes.
- The `.command` file is macOS-specific and may not work on other operating systems without modification.
- If double-clicking the `.command` file does not work due to macOS security settings, you may need to adjust Gatekeeper settings (`System Settings > Privacy & Security`) or use the right-click **Open** method.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.