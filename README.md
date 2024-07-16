<h1 align="center">
    Spotify Controller Using Rofi For Hyprland
</h1>

<details>
<summary><b><code>Video</code></b></summary>

https://github.com/Anas-Hamdane/Spotify-Controller/assets/155746228/b6d338a0-7140-4bdb-9adf-e808ed246ef8


</details>


<details>
<summary><b><code>Picture</code></b></summary>

![Preview](https://github.com/Anas-Hamdane/Spotify-Controller/assets/155746228/5eff45cd-e466-461c-8d34-28ddc9eef7f1)

</details>

## Important
> [!WARNING]
> Be Sure That You Can Run Spotify By Typing `spotify` In The Terminal. For Me, I Installed It From The Official [Website](https://www.spotify.com/us/download/linux/)

> [!NOTE]
> This Script Works **Perfectly** On Ubuntu 24.04 With Hyprland.

## Dependencies
  - [`rofi`](https://github.com/davatorium/rofi)
  - [`playerctl`](https://github.com/altdesktop/playerctl)
  - [`curl`](https://github.com/curl/curl)

## Features
  - If Spotify Is Already Closed It'll Run It Automatically (Uses A `hyprctl` Command)
  - Dynamic Sound Cover (`playectl`, `curl` and `imagemagick`)
  - Play Previous **Spotify** Sound (`playectl`)
  - Play/Pause **Spotify** Sound (`playectl`)
  - Play Next **Spotify** Sound (`playectl`)
  - Hide/Unhide **Spotify** (Uses Mainly `hyprctl` Commands)
  - Kill **Spotify** (Uses `killall`)

## Installation
```
git clone https://github.com/Anas-Hamdane/Spotify-Controller.git

cd Spotify-Controller

cp SpotifyController ~/.config/rofi -r

chmod +x ~/.config/rofi/SpotifyController/SpotifyController.sh

~/.config/rofi/SpotifyController/SpotifyController.sh
```

## Recommended Configuration
- Add A KeyBind To Your `hyprland.conf/Keybinds.conf/UserKeybinds.conf` For Example I've Added This Line
```
bind = $mainMod CTRL, S, exec, ~/.config/rofi/SpotifyController/SpotifyController.sh
```
- To Hide Spotify Automatically When it Opens, Add This Line To `hyprland.conf/WindowRules.conf`
```
windowrulev2 = workspace special silent, class:^(Spotify)$
```
