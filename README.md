# Introduction

This is a step-by-step guide on setting up Arch Linux for personal daily use. The following video shows what we'll have at the end.

## [Watch 1-min demonstration video!](https://www.youtube.com/watch?v=C4uiSL4xvbU)

[![Watch the video](./assets/video-thumbnail.png)](https://www.youtube.com/watch?v=C4uiSL4xvbU)

A few notes to begin with:

1. This is just my way to do things. You're free to have different preferences.

2. I've tried to keep things simple and include tips here and there so beginners can follow through.

3. A minimal background knowledge on Linux commands and Linux in general will be helpful, but isn't mandatory.

I will be using the [GNOME](https://www.gnome.org/) desktop environment because it looks modern out of the box and gets the job done.

# Installation

Boot into an Arch installation ISO and prepare yourself for a wonderful journey. _(that was corny as hell but I'm keeping it)_

## Splitting the shell into tabs

Right off the bat, we can use tmux to spin up multiple tabs in the shell which can be really useful if we need to run other commands or write notes while the installation is running in another tab.

```sh
# run tmux which creates a single tab
tmux
```

4 hotkeys is all you need to create and navigate around tabs.

| Hotkey | Action |
|-|-|
| Ctrl+B, C | Create a new tab |
| Ctrl+B, N | Switch to the next tab |
| Ctrl+B, P | Switch to the previous tab |
| Ctrl+B, , | Rename the current tab |

Usually, I keep at least 2 tabs and run the installation in the first tab.

## Connecting to the internet via WiFi

```sh
# list stations (think WiFi drivers, for me there's only one: wlan0)
iwctl station list

# scan for WiFi access points
# (replace wlan0 with your station name)
iwctl station wlan0 scan

# list access points
iwctl station wlan0 get-networks

# connect to a certain access point
iwctl station wlan0 connect YOUR-WIFI
```

## Running archinstall

archinstall is a convenience tool that makes installing Arch orders of magnitude easier by automating the boring steps. We can type `archinstall` and hit _[Enter]_ to start it.

Here are the settings I use in archinstall. I will only mention the ones that are different from the default values.

| Setting | Value |
|-|-|
| Mirrors > Select regions | Your country and a few more near it or on the same continent. |
| Mirrors > Optional repositories | multilib |
| Disk configuration > Partitioning | Depends on your setup, but don't use a swap partition as we'll handle swap later. I used Manual partitioning, chose my SSD, and then chose "Suggest partition layout" using the ext4 filesystem. I didn't enable creating a separate partition for the `/home` directory. |
| Swap | Enable swap on zram using the zstd compression algorithm. |
| Kernels | Just "linux" |
| Hostname | Up to you |
| Authentication > Root password | Won't tell you |
| Authentication > User account > Add user | Username and password are up to you. For "Should this user be a superuser (sudo)?" you should answer yes unless you never need root permissions (even temporarily). |
| Profile > Type | Desktop > GNOME |
| Profile > Graphics driver | All open-source (we'll cover switching to proprietary NVIDIA drivers later) |
| Profile > Greeter | gdm |
| Applications > Bluetooth | Enabled |
| Applications > Audio | pipewire |
| Applications > Print service | Enabled |
| Applications > Power management | power-profiles-daemon |
| Applications > Firewall | ufw |
| Applications > Additional fonts | All selected |
| Network configuration | Use NetworkManager (iwd backend) |
| Timezone | Up to you |

After dialing in the settings, we simply hit __Install__ and wait for a while. If something goes wrong in the middle of the installation, search engines and LLMs are your friends.

Once the installation is over, you can remove your bootable USB (or whatever you're using) and restart into your new Arch system!

# Terminals

Throughout the journey, we'll need to run a lot of commands. In a graphical desktop environment, we use what's called a "terminal emulator" or console to run commands. By default, GNOME provides kgx which is simply named __Console__ in the applications menu. This is what I'll be using, but you're free to use something with more features or eye candy.

# nano

nano is a terminal text editor available on almost any Linux shell you'll encounter. I personally use [Visual Studio Code](https://code.visualstudio.com/) for editing text, but since we are in a fresh installation of Arch, we'll go with nano for now.

# Package Managers

Package managers lets yo install, remove, and search for packages. Every Linux distro has a package manager pre-installed. In Arch Linux, we have pacman.

## But what is a package?

A package can be a program, game, library (for programming languages), theme, font, etc.

# Installing yay and Firefox

[yay](https://github.com/Jguer/yay) gives us access to tons of packages from the [AUR (Arch User Repository)](https://aur.archlinux.org/) which contains almost any program, font, or theme you could imagine. It _is_ community-maintained, though, so there is some security risk.

```sh
sudo pacman -S --needed --noconfirm git base-devel && \
tmpdir=$(mktemp -d) && \
trap 'rm -rf "$tmpdir"' EXIT && \
git clone https://aur.archlinux.org/yay-bin.git "$tmpdir/yay-bin" && \
cd "$tmpdir/yay-bin" && \
makepkg -si
```

Next, install your favorite browser. For me, that's Firefox.

```sh
sudo pacman -S --noconfirm firefox
```

# Switching to zsh

When you open a terminal, you're entering a __shell__.
Shells in Linux allow you to run and combine commands in interesting ways. They're basically programming languages.

The most well-known shell is bash which is the default in Arch Linux, but it's quite old and something modern like zsh has a lot more to offer. Let's see how we can switch our default shell from bash to zsh.

```sh
# install zsh
sudo pacman -S --noconfirm zsh zsh-autosuggestions

# switch to zsh
chsh -s $(which zsh)
```

Restart your terminal app and you shall see a first-time welcome message with a menu for setting different options based on your taste. Here's some of the more important ones I used.

| Setting | Value |
|-|-|
| Use the new completion system | Yes |
| Configure how keys behave | Emacs keymap |

If you need to re-run the zsh setup wizard in the future, you can invoke it by running `autoload -Uz zsh-newuser-install; zsh-newuser-install -f`.

## Sane keybinds

By default, zsh has unintuitive keybinds for moving the text cursor, at least for a noob like me who has never worked with vim. For example, _[Ctrl+LeftArrow]_ doesn't move to the previous word, _[Home]_ doesn't go to the beginning of the line, and so on.

Unless you're a terminal nerd and enjoy weird keyboard moves, you can fix this by adding a few lines at the end of your `.zshrc` file. We'll get into what this file does soon. Run the following command to start editing `.zshrc`.

```sh
nano ~/.zshrc
```

> Every user has a home directory at `/home/username` (replace `username` with the name of the user). In most shells, we can simply use `~` as a shorthand for the current user's home directory. For example, `~/Desktop` is the same as `/home/username/Desktop`.

Now, go to the very bottom and paste these using _[Ctrl+Shift+V]_.

```sh
autoload -Uz select-word-style
select-word-style bash

bindkey -e

# Home/End
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# alternate Home/End sequences
bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line

# Ctrl + Left/Right
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# alternate Ctrl + Left/Right
bindkey '^[[5D' backward-word
bindkey '^[[5C' forward-word

# Delete
bindkey '^[[3~' delete-char
bindkey '^[3~' delete-char
```

Hit _[Ctrl+O]_ and then _[Enter]_ to save the file. Then, hit _[Ctrl+X]_ to exit nano.

## Autosuggestions

The zsh-autosuggestions plugin auto-completes our commands based on our command history which can come in real handy. To enable it, add the following line to `.zshrc`.

```sh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
```

> By now, you probably have some idea of what `.zshrc` is. Put simply, it's a bunch of commands run by zsh as soon as you open a terminal. Other shells have their own versions of this. For example, bash has `.bashrc`.

# Making zsh look nice

[p10k](https://github.com/romkatv/powerlevel10k) is a zsh theme that decorates the terminal with eye candy. We can install it from the AUR.

```sh
yay -S --noconfirm zsh-theme-powerlevel10k-bin-git
```

To enable p10k, we need to edit `.zshrc` once again and add this line at the end:

```sh
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
```

After saving it and exiting the text editor (nano), run this command to reload `.zshrc` without restarting the terminal.

```sh
source ~/.zshrc
```

You will now be presented with the p10k configuration wizard which simply asks you a couple multi-choice questions on how you want your terminal to look.

# .zshrc

`.zshrc` is a script zsh runs every time you open a terminal. Environment variables (think global settings every program can read), aliases, functions, and shell customization commands (i.e. loading plugins or themes) usually go here.

As an example, we can add an alias named `pac` for installing packages with pacman without typing out a long command every time.

```sh
alias pac="sudo pacman --color auto --needed --noconfirm -S"
```

Now we can do `pac firefox`.

We can also "export" environment variables to let programs know our favorite text editor and file manager, for example. Only programs launched from the terminal will see these, though.

```sh
export EDITOR="code --wait"
export FILE_MANAGER=nautilus
```

> Of course, we haven't installed `code` (Visual Studio Code) yet, and you might prefer another text editor, but this is just an example.

If you use the terminal a lot, you'll end up adding lots of little functions and aliases here to make your workflow faster. This is highly subjective and different for every person, so __I recommend slowly building it up yourself instead of copying someone else's `.zshrc`.__

The reason I have included my `.zshrc` in this repo is mostly to keep a backup, but also provide a reference for others. I hope it'll be helpful for someone.

# Installing disk-related packages

These packages can help prevent headaches down the line regarding disk mounting.

```sh
sudo pacman -S --noconfirm ntfs-3g udiskie gvfs gvfs-mtp gvfs-gphoto2 gvfs-afc udiskie udisks2
```

Make sure to restart your computer after this step.

# Mounting NTFS volumes

Some of the volumes (drives) in my HDD use the NTFS file system and, even with the above packages installed, GNOME's file manager (nautilus) still fails to mount (think open or load) them and shows an error. Here's a permanent fix to that, unless you physically swap out your disk.

## 1. Get the UUID

Use lsblk to see the list of disks and volumes on your system and write down the UUID(s) of the desired volume(s).

```sh
lsblk -f
```

## 2. Create a mount point

In case you didn't know, in Linux, we typically create an empty directory in `/mnt` and then _mount_ a volume onto that directory so that the contents of the volume appear there. The name of the directory is totally up to you and has nothing to do with the traditional "name" of the volume. I will use "Stuff" for this example.

```sh
sudo mkdir -p /mnt/Stuff
```

## 3. Edit `/etc/fstab`

```sh
sudo nano /etc/fstab
```

Add the following section at the end, replacing `YOUR-UUID` with the UUID you got earlier and `/mnt/Stuff` with your mount point.

```
# auto-mount NTFS volumes
UUID=YOUR-UUID  /mnt/Stuff  ntfs-3g  defaults,noatime,uid=1000,gid=1000,umask=000  0  0
```

Hit _[Ctrl+O, Enter]_ to save the file and _[Ctrl+X]_ to exit nano.

## 4. Finalize

Run `sudo mount -a` to apply the changes instantly without a restart. If you see an error here (other than the warning "your fstab has been modified, but systemd still uses the old version"), the internet is your friend. Otherwise, it should output nothing.

Finally, open the mount point directory in the file manager and bookmark it to make it easy to access.

```sh
nautilus /mnt/Stuff &
```

> Adding `&` at the end of a command makes it non-blocking, meaning we can keep typing and running other commands in the meantime. Typically we want to use `disown` as well (e.g. `some-gui-program & disown`).

# pacman progress bars

Admittedly, this isn't the most important thing in the world, but pacman has a feature where it shows a cute little pacman animation when showing download progress, and I just have to enable it.

```sh
sudo nano /etc/pacman.conf
```

Find the line that says `#VerbosePkgLists`, and add this line below it:

```
ILoveCandy
```

# Making GNOME look and behave better

__NOTE: This is highly subjective and based on my own personal preferences. You are free to make your desktop look however you want it to.__

## Appearance

1. Go to __Settings > Appearance__.

2. Click __Add Picture__ to add your wallpapers and choose whatever you find more appealing. I usually keep my wallpapers in `~/Pictures/Wallpapers`.

3. Set __Style__ and __Accent Color__ to whatever you prefer or whatever works best with your wallpaper.

## Display Scaling

Because of my screen size and average viewing distance, I find 100% scaling too small and 125% too large, so I settle for increasing the font size. Of course, your case could be different.

1. Go to __Settings > Display__.

2. Adjust scale and other settings based on your conditions.

3. Open GNOME Tweaks (press _[Super]_ to open Overview, then type Tweaks and hit _[Enter]_).

4. Go to the __Fonts__ tab and set __Scaling Factor__ to something you're comfortable with. For me, 1.13.

5. While you're at it, set __Hinting__ to Full.

## Icons, cursors, and fonts

1. Install the [Kora icon theme](https://github.com/bikass/kora) and [Bibata cursor theme](https://github.com/ful1e5/Bibata_Cursor) from the AUR.

```sh
yay -S --noconfirm kora-icon-theme bibata-cursor-theme-bin
```

2. Install additional fonts

```sh
sudo pacman -S --needed --noconfirm ttf-jetbrains-mono ttf-jetbrains-mono-nerd inter-font awesome-terminal-fonts otf-font-awesome woff2-font-awesome

# beware, ttf-google is huge!
yay -S --needed --noconfirm ttf-google ttf-material-symbols-variable ttf-material-symbols-variable
```

Since I'm Iranian, I'll also install some Persian fonts. No matter where you live, there's probably a font pack for your language on the AUR.

```sh
yay -S --noconfirm vazirmatn-fonts ir-standard-fonts iranian-fonts vazir-code-fonts persian-fonts
```

> You can search for both pacman and AUR packages using a yay command. Example: `yay -Ss game engine`

3. Go to __Tweaks > Appearance__.

4. Set __Cursor__ to _Bibata-Modern-Classic_ and __Icons__ to _Kora_. 

5. Switch to the __Fonts__ tab in __Tweaks__.

6. Under __Preferred Fonts__, set __Monospace Text__ to _JetBrainsMono Nerd Font Light_ at size 11 (or whatever is comfortable for you).

## Window title bars

1. Go to __Tweaks > Windows__.

2. Enable __Maximize__ and __Minimize__ in the __Titlebar Buttons__ section.

3. In the __Click Actions__ section, disable __Attach Modal Dialogs__.

## Old GTK apps

Some apps use older versions of GTK (the GUI toolkit for most GNOME apps) and don't have the modern GNOME look. To fix that, we need to install and enable adw-gtk-theme.

```sh
sudo pacman -S --noconfirm adw-gtk-theme
```

Now go to __Tweaks > Appearance__ and set __Legacy Applications__ to _Adw-gtk3-dark_ (or _Adw-gtk3_ if you prefer that).

## File history settings

1. Go to __Settings > Privacy & Security__.

2. Set __File History__ Duration to 30 days.

3. Enable __Automatically Empty Trash__ and __Automatically Delete Temporary Files__ and set __Automatic Deletion Period__ to 30 days.

## Workspaces

Workspaces are one of the best features a desktop can provide IMHO, but personally, I find the default settings a bit unintuitive.

1. Go to __Settings > Multitasking__.

2. Disable __Hot Corner__ in the __Screen Edges__ section.

3. In the __Workspaces__ section, switch to __Fixed Number of Workspaces__ and set __Number of Workspaces__ to whatever works for you. For me, that's 6.

> If you haven't used workspaces before, here's an example. You could put your browser in workspace 1, coding editor in workspace 2, music player in workspace 3, and so on.

## Keyboard Shortcuts

__Another reminder that these settings are subjective.__

1. Go to __Settings > Keyboard__ and click on __View and Customize Shortcuts__.

2. Find __Show the notification list__ and set its shortcut to _[Super+N]_.

3. Find __Close window__ and set its shortcut to _[Super+W]_.

4. Go to __Custom Shortcuts__ and click __Add Shortcut__.

5. Add a new shortcut named __Open Terminal__ and set the __Command__ to `kgx &` and the __Shortcut__ to _[Super+Q]_.

6. Add another one named __Open Resources__ and set the __Command__ to `resources &` and the __Shortcut__ to _[Ctrl+Shift+Esc]_.

We can now:

1. Hit _[Super+N]_ to open and close the notification panel.
2. Hit _[Super+W]_ to close the focused window.
3. Hit _[Super+Q]_ to quickly open a new terminal window.
4. Hit _[Ctrl+Shift+Esc]_ to open Resources, once we install it in later steps.

> [Resources](https://apps.gnome.org/Resources/) is similar to the task manager on Windows. It shows us how different programs are utilizing our hardware, CPU and GPU usage graphs, temperature graphs, and so forth. We'll install Resources in later steps.

## Logout button

For some reason, someone at GNOME thought single-user setups don't need a logout button, so they made it only show when there are multiple users on the system. To show it all the time, we can run this command.

```sh
gsettings set org.gnome.shell always-show-log-out true
```

# Configuring nautilus

1. Open __Files__ and go to its __Preferences__.

2. Enable __Sort Folders Before Files__.

3. Under __Performance__, set __Search in Subfolders__ to _All Locations_ and __Show Thumbnails__ to _All Files_.

4. Install `nautilus-admin-gtk4`.

```sh
yay -S --noconfirm nautilus-admin-gtk4
```

You shall now see a new option __Open as Admin__ on directories and __Edit as Admin__ on some files.

# Installing GNOME extensions

Extensions can, without exaggeration, transform GNOME. We'll use a few popular ones to make our desktop way more enjoyable for daily driving.

1. Install gnome-browser-connector.

This package allows us to install GNOME extensions directly from the browser.

```sh
sudo pacman -S --noconfirm gnome-browser-connector
```

2. Install GNOME Shell Integration extension for your browser ([Firefox](https://addons.mozilla.org/en-US/firefox/addon/gnome-shell-integration/), [Chrome](https://chromewebstore.google.com/detail/gnome-shell-integration/gphhapmejobijbbhgpjhcjognlahblep?hl=en)).

3. Install the following extensions:

- [All-in-One Clipboard](https://extensions.gnome.org/extension/8671/all-in-one-clipboard/)
- [Blur my Shell](https://extensions.gnome.org/extension/3193/blur-my-shell/)
- [Burn My Windows](https://extensions.gnome.org/extension/4679/burn-my-windows/)
- [Color Picker](https://extensions.gnome.org/extension/3396/color-picker/)
- [Dash to Dock](https://extensions.gnome.org/extension/307/dash-to-dock/)
- [GSConnect](https://extensions.gnome.org/extension/1319/gsconnect/)
- [Hibernate Power Menu](https://extensions.gnome.org/extension/10398/hibernate-power-menu/)
- [Just Perfection](https://extensions.gnome.org/extension/3843/just-perfection/)
- [Slider Percentages](https://extensions.gnome.org/extension/10125/slider-percentages/)
- [Status Tray](https://extensions.gnome.org/extension/9164/status-tray/)
- [Switch Workspace](https://extensions.gnome.org/extension/1231/switch-workspace/)

# Configuring extensions

Open __Extensions__ from the app menu. Here you'll see a list of the extensions we just installed. Most of them have a settings button in their "three-dots menu".

## All-in-One Clipboard

1. In the __Extensions__ app, open the settings for __All-in-One Clipboard__.

2. In the __General__ section, set __Width__ and __Height__ to 420 and 450, respectively, and enable __Hide Panel Icon__.

3. In the __Global Shortcuts__ section, set __Open Clipboard Tab__ to _[Super+V]_

4. Go to the __Features__ tab, turn on __Enable Auto-Paste__

We can now open clipboard history with _[Super+V]_ and use Emojis with _[Super+.]_.

## Blur my Shell

1. Open its settings and go to the __Pipelines__ tab if not already there.

2. Under the __Default__ pipeline, Click __Manage effects__.

3. Expand __Native gaussian blur__. Set __Radius__ to 60 and __Brightness__ to 0.45.

4. Click __Add Effect__ and choose __Noise__. Expand it and set __Noise__ to 0.15 and __Lightness__ to 0.70.

5. Repeat the same steps for the __Default rounded__ pipeline, making sure the __Corner__ effect comes at the very bottom. Also, set the __Radius__ of the __Corner__ effect to 20.

6. Click __Add Pipeline__ to add a new pipeline and name it __Lockscreen__.

7. Click __Manage effects__ on the new __Lockscreen__ pipeline and add a __Native gaussian blur__ with a __Radius__ of 100 and a __Brightness__ of 0.60 followed by a __Noise__ effect with the same values as in the __Default__ pipeline.

8. Go to the __Overview__ tab and set __Overview components style__ to _Light_. In the __Application folder blur__ section, set __Sigma__ to 50 and __Brightness__ to 0.60.

9. Go to the __Applications__ tab and enable __Applications blur__.

10. Set __Blur type__ to _Dynamic_, __Sigma__ to 35, __Brightness__ to 1.00, and __Opacity__ to 215.

11. Disable __Opaque focused window__.

12. Prepare the applications which you want to have a translucent blurry background. For me, that's the default console (kgx) and text editor, so I'll have them open.

13. In the __Whitelist__ section, hit __Add Window__ and click on the app you want to get blurred.

14. Go to the __Other__ tab. Under __Lockscreen blur__, set __Pipeline__ to __Lockscreen__.

15. To avoid artifacts near rounded corners, it's recommended to install the [gnome-rounded-blur helper script](https://github.com/aunetx/blur-my-shell/blob/master/scripts/GUIDE.md).

```sh
yay -S --noconfirm gnome-rounded-blur
```

## Burn My Windows

1. Open its settings.

2. Disable everything and then enable __TV Effect__. Expand __TV Effect__ and set __Animation Time__ to 250 ms.

## Color Picker

1. The usual.

2. Turn off __Enable systray__.

3. Turn on __Enable shortcut__ and set it to _[Super+C]_.

We can now hit _[Super+C]_ to pick a color anywhere on the screen and copy it to the clipboard.

## Dash to Dock

1. Go to the __Position and size__ tab.

2. There's a gear icon next to the toggle for __Intelligent autohide__. Click it.

3. Choose __All windows__ under __Dodge windows__.

4. Set __Animation duration__ to 0.150 s, __Hide timeout__ to 0.0 s, and __Pressure threshold__ to 100.

5. Close __Intelligent autohide__ settings.

6. Set __Icon size limit__ to 48 px.

7. Switch to the __Launchers__ tab.

8. Under __Show Applications icon__, enable __Move at beginning of the dock__.

9. Disable __Show trash can__.

10. Disable __Show volumes and devices__.

11. Switch to the __Behavior__ tab.

12. Disable __Use keyboard shortcuts to activate apps__.

13. Set __Click action__ to _Minimize_ and __Scroll action__ to _Cycle through windows_.

14. Switch to the __Appearance__ tab

15. Enable __Shrink the dash__ and __Show overview on startup__.

## Hibernate Power Menu

1. Turn off __Show Hybrid Sleep__ unless you actually use that feature.

2. Turn on __Skip Hibernate Dialog__.

__NOTE:__ The hibernate button may not show up yet. We'll handle this in later sections.

## Just Perfection

1. Go to the __Visibility__ tab.

2. Turn off __Accessibility Menu__ unless you use it frequently.

3. Personally, I always use _[Fn + ArrowUp/Down]_ instead of the Quick settings panel (at the top right) to adjust my keyboard's backlight, so I turn off __Backlight Toggle Button__ here.

4. Switch to the __Behavior__ tab.

5. Turn on __Workspace Wraparound__.

6. Switch to the __Customize__ tab.

7. Set __Panel Size__ to 32 px and __Panel Icon Size__ to 16 px.

8. Set __Workspace Switcher Size__ to 8%.

## Status Tray

1. Set __Icon Style__ to _Original (colored)_.

2. Set __Icon Size__ to 18 px and __Padding between icons__ to 8 px.

3. In the __Panel Overflow__ section, turn on __Enable overflow icon__, set __Overflow button icon__ to _Dynamic preview (colour)_, and set __Inline icon limit__ to 3.

## Switch Workspace

Set __Switch Workspace Keybinding__ to _[Super+Tab]_. We can now use this hotkey to switch workspaces.

> Another way to switch workspaces is to hold _[Super]_ and scroll with your mouse. You can also hover your mouse over the workspace indicator at the top left and scroll there.

# Ignoring lid close

Personally, I want my system to stay awake when I close my laptop lid. We can edit a system file to fix that. 

```sh
sudo nano /etc/systemd/logind.conf
```

Find the three lines that say:

```
#HandleLidSwitch=suspend
#HandleLidSwitchExternalPower=suspend
#HandleLidSwitchDocked=ignore
```

For each line, remove the `#` at the beginning to uncomment it, and change the last word to `ignore`.

```
HandleLidSwitch=ignore 
HandleLidSwitchExternalPower=ignore 
HandleLidSwitchDocked=ignore
```

Save the file and exit the editor.

# Installing fastfetch

Our LARP wouldn't be complete without something like fastfetch, a command that shows a general overview of our system in the terminal.

```sh
sudo pacman -S --noconfirm fastfetch
```

The default options are fine on their own, but I like to change things up a bit.

```sh
mkdir -p ~/.config/fastfetch
nano ~/.config/fastfetch/config.jsonc
```

Here are my settings.

```jsonc
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.json",
  "logo": {
    "type": "small"
  },
  "modules": [
    "title",
    "separator",
    "os",
    "host",
    "kernel",
    "uptime",
    //"packages",
    "shell",
    "display",
    "de",
    "wm",
    //"wmtheme",
    //"theme",
    //"icons",
    //"font",
    //"cursor",
    "terminal",
    //"terminalfont",
    "cpu",
    "gpu",
    "memory",
    "swap",
    "disk",
    "localip",
    //"battery",
    "poweradapter",
    //"locale",
    "break",
    "colors"
  ]
}
```

# Compressed ram and swap files

Unless you have tons of RAM, you may occasionally run out of memory when using heavy applications or games, resulting in a freeze and jump back to the login screen.

The traditional solution to that is to put the extra bits onto the disk (in a swap file or partition), but that's slow, so some great developers made zram, a tool that compresses RAM into... RAM. In real time. Since reading and writing to RAM is a lot faster than a disk (even a fast SSD), this results in a net improve over disk-only swap.

Let's see how we can setup zram as well as a swap file for fallback.

```sh
# see the list of active swaps
swapon --show

# if any swapfiles show up, delete them
sudo rm -f /example-swapfile

# disable all swaps
sudo swapoff -a

# delete/comment lines where the third column (type) is swap, if any.
sudo nano /etc/fstab

# install zram
sudo pacman -S --needed --noconfirm zram-generator

# configure
sudo nano /etc/systemd/zram-generator.conf
```

Here's my zram config.

```ini
[zram0]
zram-size = ram * 0.5
compression-algorithm = zstd
swap-priority = 100
```

## Swappiness

Swappiness tells the system how much to prefer swapping out cold pieces of memory (i.e. rarely accessed memory pages). It's a unitless value and doesn't correspond to a single threshold or percentage. Rather, the kernel makes decisions based on several factors, and swappiness steers that decision around. A swappiness of 100 is recommended for zram.

```sh
echo "vm.swappiness=100" | sudo tee /etc/sysctl.d/99-swappiness.conf
```

## Swap file

Next, we'll add a swap file as a backup for when we fully run out of memory, even with compression. I think it's recommended to use the size of your RAM plus 1 GiB to allow hibernation, which we'll handle later. I have 16 GiB of RAM, so I'll create a 17 GiB swap file. 

```sh
# make swapfile
sudo fallocate -l 17G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# add fstab entry
echo "/swapfile none swap sw,pri=10 0 0" | sudo tee /etc/fstab
```

Notice how the priority (`pri=10` on the last line) is set to 10 which is lower than what we used for zram (`swap-priority = 100`). This means the swap file will only kick in when zram is exhausted.

## Applying changes

Finally, we'll do a restart to start using our new optimized memory system.

# Enabling hibernation

Hibernation puts the contents of your RAM into the swap file and fully powers off the system. It's similar to suspend (sleep) but survives power and battery outages.

You can skip this section if you never need to hibernate your system.

1. Edit `/etc/mkinitcpio.conf`.

```sh
sudo nano /etc/mkinitcpio.conf
```

2. Find the line that looks like `HOOKS=(...)` (__without__ a `#` at the beginning).

3. Add `resume` after `block` and before `filesystem`.

4. Save and exit.

5. Regenerate initramfs (initial RAM filesystem) for the kernel.

```sh
sudo mkinitcpio -P
```

6. Reboot.

If you've installed the __Hibernate Power Menu__ GNOME extension as mentioned in a previous section, you should see a new __Hibernate__ option in the power menu of the Quick settings panel.

# Installing regular programs

Needless to say, this is different for every person. The following is just the list of programs and packages _I_ use frequently or want to have installed on my system.

## pacman

```
7zip amberol apostrophe audacity audio-sharing authenticator autoconf automake blanket blender celluloid clang cmake collision copyparty cpu-x curl darktable dconf-editor decoder discord element-desktop errands eyedropper fastfetch fd ffmpeg fzf gcc gimp git glider godot-mono gpu-viewer graphs handbrake harfbuzz hieroglyphic identity impression kdenlive kicad kicad-library kicad-library-3d krita lazygit less linux-headers lsof lsp-plugins make man-db man-pages mplayer mpv ninja nodejs obs-studio openrgb patch pinta playerctl python-numpy python-opengl python-pillow python-pycurl python-requests python-yaml qbittorrent reaper resources ripgrep rust shortwave spirv-tools steam telegram-desktop telegram-desktop totem typescript uget unrar unzip unzip v2ray-domain-list-community v2ray-geoip vlc vlc vlc-plugins-all vulkan-headers vulkan-tools wget wl-clipboard yt-dlp zoxide
```

## AUR

```
flaccy-bin gapless gg-bin glcapsviewer-git google-chrome gradia localsend-bin material-maker-bin psiphonlinuxgui redsocks2 unified-remote-server v2rayn-bin visual-studio-code-bin vulkan-caps-viewer-wayland-bin
```

# Switching to proprietary NVIDIA drivers

My laptop has a dedicated NVIDIA GTX 1650 graphics card and, open-source drivers (like nouveau), as much as I support FOSS, just don't give the same experience as the real ones from the vendor.

You can skip this section if you don't have an NVIDIA GPU or are satisfied with nouveau.

1. Install the relevant packages.

```sh
sudo pacman -S --needed --noconfirm nvidia-open nvidia-utils lib32-nvidia-utils nvidia-prime
```

2. Remove `xf86-video-nouveau`.

```sh
sudo pacman -Rns xf86-video-nouveau
```

3. Blacklist nouveau.

```sh
sudo nano /etc/modprobe.d/blacklist-nouveau.conf
```

Add the following lines and save the file:

```
blacklist nouveau
options nouveau modeset=0
```

4. Regenerate initramfs (initial RAM filesystem) for the kernel.

```sh
sudo mkinitcpio -P
```

5. Install switcheroo-control to get the __Launch Using Discrete Graphics Card__ option in GNOME.

```sh
sudo pacman -S --noconfirm switcheroo-control
sudo systemctl enable --now switcheroo-control
```

6. Reboot.

# Bypassing internet restrictions

Ignore this section if you have unrestricted internet access.

If you're in a highly controlled internet environment or country where most services (even some package repositories) are blocked, you probably already know about VPNs, V2Ray, proxies, etc., so I won't get into the details. In my case, I have a SOCKS5 proxy server running on my phone using the Every Proxy app which allows me to route my laptop's network traffic into the VPN that's running on my phone (e.g. Npv Tunnel, V2RayNG, Psiphon, etc.).

Below are three different methods for routing your network traffic through a SOCKS5 proxy server. We will assume an imaginary address of `192.168.1.5:1080` for the proxy server.

## 1. Quick and dirty

The simplest solution is to set the `all_proxy` environment variable. This only works in the current shell session and not all programs respect these values, but it can be effective when other methods are not feasible. It can also be used in the Arch installation shell (e.g. when running archinstall).

```sh
export all_proxy=socks5h://192.168.1.5:1080
export ALL_PROXY=$all_proxy
```

## 2. v2rayN

v2rayN is a free and open-source GUI program that allows us to set system-wide proxies using different protocols supported by V2Ray (SOCKS5, VLESS, etc.).

1. Use the quick and dirty method from above to set environment variables for bootstrapping (because installing v2rayN itself requires access to the AUR).

2. Install [v2rayN](https://github.com/2dust/v2rayN) from the AUR.

```sh
yay -S --noconfirm v2rayn-bin
```

3. Go to __Configuration > Add [SOCKS]__, enter the address of the proxy server, and hit __Confirm__. You can also use __Import Share Links from clipboard__ if you have a V2Ray share link in your clipboard.

4. Right click on the newly added item and click __Set as active__.

5. Switch to __Set system proxy__ at the bottom. Enabling Tun mode doesn't seem to work properly for me, so I usually keep it off.

A couple things to keep in mind:

- This is a wonky setup and doesn't work for some command-line apps, but most browsers and GUI apps should be fine.

- v2rayN runs its own local SOCKS5 proxy server that other programs can use, even if you __Clear system proxy__. The address is usually 127.0.0.1:10808 by default.

## 3. Proxying in the terminal

A lot of programs (GUI and CLI) ignore proxy-related environment variables like `all_proxy`, and v2rayN's Tun mode doesn't always work reliably, but worry not! There's a tool named gg that routes a command's network traffic through a V2Ray config. For example, we can run `gg curl https://google.com` and it will proxy the entire command through a previously set V2Ray config or share link. gg is available on the AUR.

```sh
yay -S --noconfirm gg-bin
```

Below is a zsh function that takes the address of a SOCKS5 proxy and sets the appropriate share link for gg. Feel free to add it to your `.zshrc`.

```sh
# set a SOCKS5 proxy config (share link) for gg. gg lets us proxy an entire
# command. for example: `gg curl https://google.com` will route the network
# traffic of that command through the previously set config or share link.
ggset() {
    if [[ $# -ne 1 ]]; then
        echo "usage: ggset <host:port>"
        return 1
    fi
    gg config -w "node=socks://Og@$1"
}
```

Example usage:

```sh
ggset 192.168.1.5:1080
gg some-command-that-requires-internet
```

Better yet, we can put our entire shell inside gg! This way, all our aliases and functions will be available as well.

```sh
# set V2Ray config for gg
ggset 192.168.1.5:1080

# enter a new zsh session inside our already running zsh
# session (zsh-ception!).
gg zsh

# any command will be routed through gg!
curl https://google.com
git clone ...
speedtest
custom-alias-from-zshrc

# exit our nested zsh session to stop proxying
exit
```

There are a few problems with this approach, though. First of all, if another program like v2rayN has already set values for proxy-related environment variables (e.g. `all_proxy`), it may interfere with gg. Secondly, sudo commands or anything that requires root permissions won't run inside the nested zsh session.

To fix both problems, I've created `ggsh`, a function that starts a zsh+gg session with the ability to run sudo commands when needed and makes the nested shell blind to proxy-related env vars to avoid interference. Feel free to add this to your `.zshrc`.

```sh
# start a zsh session with network traffic routed through gg
ggsh() {
    env -u ALL_PROXY -u HTTP_PROXY -u HTTPS_PROXY \
        -u all_proxy -u http_proxy -u https_proxy \
    sudo -EH \
    gg -n "$(gg config node)" \
    sudo -EH -u "$USER" zsh
}
```

Example usage:

```sh
ggset 192.168.1.5:1080
ggsh

# we are now inside a zsh+gg session
curl ...
sudo pacman -S ...

# exit to outer session when needed
exit
```
