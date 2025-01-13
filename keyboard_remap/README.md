# Linux
## Ref: https://www.swe-devops.com/posts/kmonad-service-systemd/

## Emplace file
Add the ./my_kmonad.service file to:
    `/etc/systemd/system/` 

## Reload systemd
sudo systemctl daemon-reload

## Start the my_kmonad service
sudo systemctl start my_kmonad

## Enable the my_kmonad service to start on boot
sudo systemctl enable my_kmonad

## Check the status of your service
sudo systemctl status my_kmonad

# Windows (kmonad doesn't seem to work so using the kanata fork)
Install https://github.com/jtroo/kanata. I just grabbed the kanata.exe binary from releases.

With Task Scheduler you going to want to provide something like this:
     `C:\Users\jv1143\kanata.exe --cfg C:\Users\jv1143\AppData\Local\nvim\keyboard_remap\keyboard_windows.kbd`
Open Task Scheduler:
    Press Win + R, type taskschd.msc, and hit Enter.

Create a New Task:
    Click on Create Task in the right-hand Actions pane.

General Tab:
    Give your task a name, e.g., Keyboard remap Startup.
    Select radio button for "Run only when user is logged in"
    Set the "Configure for" dropdown to your Windows version.

Triggers Tab:
    Click New.
    Set the trigger to At log on.
    Choose "Any user" or specify your user account.
    Click OK.

Actions Tab:
    Click New.
    For "Action", choose Start a program.
    In the "Program/script" field, browse to the path of kmonad.exe.
    In the "Add arguments (optional)" field, enter the relative or full path to your config.kbd file, e.g., .\path\to\config.kbd.
    Click OK.

Conditions Tab:
    Uncheck "Start the task only if the computer is on AC power" if you're on a laptop and want it to run on battery.

Settings Tab:
    Check Allow task to be run on demand.
    Optionally, enable "If the task fails, restart every..." to ensure the command runs reliably.

Save and Test:
    Click OK to save the task.
    Right-click the task and select Run to test it.
