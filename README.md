<h1 align="center">
    Spotify Controller Using Rofi For Hyprland
</h1>

</details>


<details>
<summary><b><code>Preview</code></b></summary>

![Preview](https://github.com/user-attachments/assets/de11e1e6-3601-4ff7-b357-0c777eb26fd6)

</details>

## Important
> [!WARNING]
> Be Sure That You Can Run Spotify By Typing `spotify` In Your Terminal. For Me, I've Install It From The Official [Website](https://www.spotify.com/us/download/linux/)

> [!NOTE]
> This Script Works **Perfectly** On Ubuntu 24.04 With Hyprland.

## Dependencies
  - [`rofi`](https://github.com/davatorium/rofi)
  - [`playerctl`](https://github.com/altdesktop/playerctl)
  - [`curl`](https://github.com/curl/curl)
  - [`yad`](https://github.com/v1cont/yad) (For Lyrics Displaying)

## Features
  - Automatically Open **Spotify** When Running The Script
  - Dynamic Sound Cover (`playectl` and `curl`)
  - Play Previous **Spotify** Sound (`playectl`)
  - Play/Pause **Spotify** Sound (`playectl`)
  - Play Next **Spotify** Sound (`playectl`)
  - Open Sound Lyrics (`playectl`, `curl` and `yad`)
  - Hide/Unhide **Spotify** (`hyprctl`)
  - Kill **Spotify** (`killall`)

## Installation
```
git clone https://github.com/Anas-Hamdane/Spotify-Controller.git

cd Spotify-Controller

cp Spotify-Controller ~/.config/rofi -r

chmod +x ~/.config/rofi/Spotify-Controller/launcher.sh

~/.config/rofi/Spotify-Controller/launcher.sh
```

## Recommended Configuration
- Add A KeyBind To Your `hyprland.conf/Keybinds.conf/UserKeybinds.conf` For Example I've Added This Line
```
bind = $mainMod CTRL, S, exec, ~/.config/rofi/Spotify-Controller/launcher.sh
```
- To Hide Spotify Automatically When it Opens, Add This Line To `hyprland.conf/WindowRules.conf`
```
windowrulev2 = workspace special silent, class:^(Spotify)$
```
