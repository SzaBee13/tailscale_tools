# Tailscale Tools

This repository contains tools and scripts for managing Tailscale deployments, particularly focusing on remote or headless setups.

## Key Features & Benefits

*   **Automated Tailscale Management:** Scripts for starting, updating, and monitoring Tailscale connections on remote machines.
*   **Systemd Integration:** Systemd service files for managing Tailscale daemons and related processes.
*   **Funnel Support:** Scripts to manage Tailscale Funnel setups for exposing services securely.

## Prerequisites & Dependencies

*   **Tailscale:** The Tailscale client must be installed on the target machine.
*   **Systemd:** This project relies heavily on Systemd for service management.
*   **Bash:** The scripts are written in Bash and require a Bash interpreter.
*   **Root access:** Most scripts require root privileges to manage system services.

## Installation & Setup Instructions

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/SzaBee13/tailscale_tools.git
    cd tailscale_tools
    ```

2.  **Copy the necessary files to the target machine.**  You'll likely want to copy the `remote/` and `systemd/` directories.  For example:

    ```bash
    scp -r remote/ user@remote_host:/opt/tailscale_tools/remote
    scp -r systemd/ user@remote_host:/opt/tailscale_tools/systemd
    ```

3.  **Configure the scripts (if necessary):**  Some scripts might require modification to reflect your specific Tailscale configuration (e.g., subnet routes, exit node settings). Edit the scripts in `/opt/tailscale_tools` on the remote host as needed.

4.  **Copy Systemd service files (on the remote host):**

    ```bash
    sudo cp /opt/tailscale_tools/systemd/*.service /etc/systemd/system/
    ```

5.  **Enable and start the Systemd services (on the remote host):**

    ```bash
    sudo systemctl enable remote-tailscale.service
    sudo systemctl start remote-tailscale.service
    # If using Tailscale Funnel:
    sudo systemctl enable tailscale-funnel.service
    sudo systemctl start tailscale-funnel.service
    ```

## Usage Examples & API Documentation (if applicable)

*   **Starting Tailscale on a remote machine:**

    ```bash
    ssh user@remote_host "sudo /opt/tailscale_tools/remote/start_remote_tailscale.sh"
    ```

*   **Updating Tailscale on a remote machine:**

    ```bash
    ssh user@remote_host "sudo /opt/tailscale_tools/remote/update_remote_tailscale.sh"
    ```

*   **Checking the status of the Tailscale connection:**

    ```bash
    ssh user@remote_host "sudo systemctl status remote-tailscale.service"
    ```

## Configuration Options

The scripts in the `remote/` directory may have configurable options.  Examine the scripts themselves to identify any customizable settings, such as:

*   Tailscale flags (e.g., `--advertise-routes`, `--exit-node`)
*   Specific device names or network interfaces.
*   Paths to Tailscale binaries.
*   Custom logging locations.

The Systemd service files can be configured by creating override files. For example, to add environment variables to `remote-tailscale.service`:

```bash
sudo systemctl edit remote-tailscale.service
```

This will open a text editor where you can add an `[Service]` section with an `Environment=` directive.

## Contributing Guidelines

1.  Fork the repository.
2.  Create a new branch for your feature or bug fix.
3.  Make your changes.
4.  Submit a pull request.

Please ensure that your code adheres to standard Bash scripting practices and includes appropriate comments.

## License Information

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

*   Thanks to the Tailscale team for creating such a useful product!
