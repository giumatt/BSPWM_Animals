#!/bin/bash

install_ITA () {
    clear

    echo "Cosa vuoi fare?
    È consigliato seguire questi step in ordine:
    0) Installa il sistema ed i font (solo bspwm e sxhkd ed imposta lo sfondo);
    1) Installa le applicazioni principali ed imposta lo sfondo (polybar, rofi, picom, ...);
    2) Installa le applicazioni opzionali;
    3) Configura i temi per alcune applicazioni;
    ) Esci."
    read -p "La tua scelta (0-3): " choice

    case $choice in
        
        0)
            system_install_IT
            ;;
        1)
            main_applications_IT
            ;;
        2)
            user_applications_IT
            ;;
        3)
            themes_menu_IT
            ;;
        *)
            exit 0
            ;;
    esac    
}

final_step () {
    clear
    echo "Cosa vuoi fare?
    0) Torna al menu principale;
    1) Riavvia il sistema;
    2) Esci."
    read -p "La tua scelta (0-2): " choice

    case $choice in

        0)
            install_ITA
            ;;
        1)
            sudo reboot
            ;;
        *)
            exit 0
            ;;
    esac
}

system_install_IT () {
    clear

    cp -r scripts ~
    chmod +x ~/scripts/*

    echo "Installo Window Manager, Display Manager (SDDM) ed Alacritty"
    set -x
    sudo pacman -S bspwm sxhkd nitrogen sddm alacritty arandr
    set +x

    echo "\n Abilito il servizio per il Display Manager e copio i suoi file di configurazione"
    set -x
    sudo systemctl enable sddm.service
    sudo systemctl start sddm.service
    sudo rm -rf /usr/lib/sddm/sddm.conf.d/default.conf
    sudo cp system_files/SDDM/Xsetup /usr/share/sddm/scripts/
    sudo cp system_files/SDDM/default.conf /usr/lib/sddm/sddm.conf.d/
    set +x

    echo "\n Copio i file di configurazione"
    cp -r alacritty bspwm sxhkd ~/.config
    cp -r Sfondi ~/Pictures

    echo "\n Installo i fonts"
    set -x
    yay -S - < fonts.txt
    set +x

    echo "\n Ricordati di installare i Nerd Fonts.\n"

    echo "\n È consigliato riavviare il sistema.\n"

    final_step
}

main_applications_IT () {
    clear

    echo "Installo l'AUR helper YAY"
    git clone https://aur.archlinux.org/yay.git && cd yay
    makepkg -si
    cd ../BSPWM_Animals
    rm -rf ~/yay

    echo "\n Installo le applicazioni principali"
    set -x
    yay -S - < programs.txt
    set +x

    echo "\n Copio i file di configurazione"
    cp -r dunst picom polybar ranger zathura ~/.config

    echo "\n Imposto lo sfondo"
    nitrogen --set-auto Pictures/Sfondi/Pink-Floyd-Animals-Expanded.jpg

    sed -i '11,17 s/^#//' ~/scripts/startup.sh 
    bspc wm -r

    echo "\n Terminato"
    final_step
}

user_applications_IT () {
    clear

    echo "\n Installo le applicazioni utente"
    set -x
    yay -S - < user_programs.txt
    set +x
    
    echo "\n Terminato"
    final_step
}

themes_menu_IT () {
    clear

    echo "Cosa vuoi fare?
    0) Installa Betterdiscord ed imposta il tema Catppuccin per Discord;
    1) Scarica il tema GTK Catppuccin;
    2) Installa Spicetify ed imposta il tema Catppuccin per Spotify;
    3) Scarica ed imposta il tema Catppuccin per SDDM;
    4) Torna al menu principale;
    5) Esci."
    read -p "La tua scelta (0-5): " choice
    app_themes_IT "$choice"
}

app_themes_IT () {
    clear

    case $choice in

        0)
            set -x
            git clone https://github.com/BetterDiscord/BetterDiscord.git && cd BetterDiscord
            npm install
            npm run build
            npm run inject
            set +x

            echo "Clono il file CSS del tema"
            wget https://raw.githubusercontent.com/catppuccin/discord/master/Catppuccin.theme.css
            cp Catppuccin.theme.css ~/.config/BetterDiscord/themes

            cd ~/BSPWM_Animals

            echo "Tema installato correttamente. \n"
            read -p "Tornare al menu precedente? (Y/n)" yn

            if [ "$yn" = "Y" ] || [ "$yn" = "y" ]; then
                themes_menu_IT
            elif [ "$yn" = "N" ] || [ "$yn" = "n" ]; then
                final_step
            fi

            ;;
        1)
            set -x
            wget https://github.com/catppuccin/gtk/releases/download/v-0.2.7/Catppuccin-Mocha-Mauve.zip
            unzip Catppuccin-Mocha-Mauve.zip -d Catppuccin-Mocha-Mauve-dir
            set -x
            mkdir ~/.themes
            cp -r Catppuccin-Mocha-Mauve-dir/ Catppuccin-Mocha-Mauve ~/.themes

            echo "Tema installato correttamente. Non dimenticare di selezionarlo dal gestore dei temi GTK. \n"
            read -p "Tornare al menu precedente? (Y/n)" yn

            if [ "$yn" = "Y" ] || [ "$yn" = "y" ]; then
                rm -rf 
                themes_menu_IT
            elif [ "$yn" = "N" ] || [ "$yn" = "n" ]; then
                final_step
            fi

            ;;
        2)
            echo "Installo Spicetify"
            set -x
            curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.sh | sh
            curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh | sh
            set +x 

            echo "Spicetify richiede i permessi di scrittura e lettura su Spotify"
            sudo chmod a+wr /opt/spotify
            sudo chmod a+wr /opt/spotify/Apps -R

            echo "Clono il tema da GitHub"
            git clone https://github.com/catppuccin/spicetify
            cp -r spicetify/catppuccin-mocha ~/.config/spicetify/Themes/
            cp spicetify/js/catppuccin-mocha.js ~/.config/spicetify/Extensions/

            echo "Configuro il nuovo tema di Spicetify"
            set -x
            spicetify update
            spicetify config current_theme catppuccin-mocha
            spicetify config color_scheme mauve
            spicetify config inject_css 1 replace_colors 1 overwrite_assets 1
            spicetify config extensions catppuccin-mocha.js
            spicetify apply
            set +x

            echo "Tema installato correttamente. \n"
            read -p "Tornare al menu precedente? (Y/n)" yn

            if [ "$yn" = "Y" ] || [ "$yn" = "y" ]; then
                rm -rf 
                themes_menu
            elif [ "$yn" = "N" ] || [ "$yn" = "n" ]; then
                final_step
            fi

            ;;

        4)
            install_ITA

            ;;
        *)
            exit 0

            ;;
    esac     
}

# Main function
read -p "Select your language (IT or EN): " language

if [ "$language" = "IT" ] || [ "$language" = "it" ]; then
    install_ITA
elif [ "$language" = "EN" ] || [ "$language" = "en" ]; then
    install_ENG
fi