#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char const *argv[])
{
    char* pid = malloc(100 * sizeof(char));
    system("hyprctl clients | grep -A 4 \"class: \"Spotify\"\" | grep \"pid:\" > ~/.config/rofi/SpotifyController/C-Scripts/tmp.txt");
    FILE* file;

    //Home Directory
    char* home = malloc(100 * sizeof(int));
    strcat(home, "/home/");
    char* username = getlogin(); // Get your username
    strcat(home,username);

    char* path = "/.config/rofi/SpotifyController/C-Scripts/tmp.txt";
    strcat(home,path);

    file = fopen(home, "r");
    
    fgets(pid, 100, file);
    if (strcmp(pid,"") == 0)
    {
        //Spotify Not Running
        printf("No\n");
        return 0;
    }
    //Cut the pid till just the number
    strtok(pid, ":");
    pid = strtok(NULL, " ");

    printf("%s",pid);
    fclose(file);
    
    //Remove tmp file
    system("rm -rf ~/.config/rofi/SpotifyController/C-Scripts/tmp.txt");
    return 0;
}
