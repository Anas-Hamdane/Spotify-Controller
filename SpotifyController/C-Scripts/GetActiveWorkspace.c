#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

//debug

int main(int argc, char const *argv[])
{
    system("hyprctl activeworkspace > ~/.config/rofi/SpotifyController/C-Scripts/tmp3.txt");
    FILE* file;

    //Home Directory
    char* home = malloc(100 * sizeof(int));
    strcat(home, "/home/");
    char* username = getlogin(); // Get your username
    strcat(home,username);

    char* path = "/.config/rofi/SpotifyController/C-Scripts/tmp3.txt";
    strcat(home,path);
    
    file = fopen(home, "r");

    char* activeworkspace = malloc(200 * sizeof(char));
    
    fgets(activeworkspace, 100, file);

    //Cut string till just the number of the workspace
    strtok(activeworkspace, " ");
    activeworkspace = strtok(NULL, " ");
    activeworkspace = strtok(NULL, " ");

    printf("%s\n",activeworkspace);
    fclose(file);
    
    //Remove tmp file
    system("rm -rf ~/.config/rofi/SpotifyController/C-Scripts/tmp3.txt");
    return 0;
}
