#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char const *argv[])
{
    // Cd to c-scripts directory to open tmp2.txt from fopen and restore workspace line in tmp2.txt 
    system("hyprctl clients | grep -B 4 \"class: \"Spotify\"\" | grep \"workspace:\" > ~/.config/rofi/SpotifyController/C-Scripts/tmp2.txt");
    FILE* file;

    //Home Directory
    char* home = malloc(100 * sizeof(int));
    strcat(home, "/home/");
    char* username = getlogin(); // Get your username
    strcat(home,username);

    char* path = "/.config/rofi/SpotifyController/C-Scripts/tmp2.txt";
    strcat(home,path);


    //Open The tmp2.txt in read-only mode
    file = fopen(home, "r");
    char* fullworkspace = malloc(100 * sizeof(char));
    // Read File First line
    fgets(fullworkspace, 100, file);

    // if File has no content because spoify isn't running

    if (feof(file))
    {
        //Spotify Not Running
        printf("No\n");
        return 0;
    }

    //cut the string till just the number of the workspace
    strtok(fullworkspace, " ");
    fullworkspace = strtok(NULL, " ");
    
    //convert char to int
    int workspaceNum = atoi(fullworkspace);

    //I have exactly 10 workspaces in my hyprland
    if (workspaceNum > 10 || workspaceNum < 1) printf("special\n");
    else printf("%d\n",workspaceNum);
    fclose(file);
    
    //Remove tmp file 
    system("rm -rf ~/.config/rofi/SpotifyController/C-Scripts/tmp2.txt");
    return 0;
}
