FROM kasmweb/core-ubuntu-focal:1.13.0
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

RUN  wget -q https://github.com/GitSquared/edex-ui/releases/download/v2.2.8/eDEX-UI-Linux-x86_64.AppImage \
    && apt-get update \
    && add-apt-repository ppa:appimagelauncher-team/stable \
    && apt-get install -y appimagelauncher \
    && apt-get update

RUN chmod u+x eDEX-UI-Linux-x86_64.AppImage

RUN mkdir -p .config
RUN mkdir -p Applications

RUN bash -c "$(/bin/echo -e "cat << 'EOF' | tee -a appimagelauncher.cfg \
     \n[AppImageLauncher] \
     \nask_to_move=false \
     \ndestination = /home/kasm-user/ \
     \nenable_daemon = true ")"\
EOF

RUN sed -e 's/EOF//g' appimagelauncher.cfg > appimagelauncher.cfgx
RUN cp appimagelauncher.cfgx .config/appimagelauncher.cfg

#RUN ail-cli integrate eDEX-UI-Linux-x86_64.AppImage

#RUN /bin/sh -c "cp "$(echo $(find ./Applications/ -type f -name 'eD*.AppImage' | sed -e '2s/^.//' ))" Applications/eDEX-UI-Linux-x86_64.AppImage"



#RUN bash -c "$(/bin/echo -e "cat << 'EOF' | tee -a ail.desktop \
#     \n[Desktop Entry] \
#     \nName=ail \
#     \nExec=ail-cli integrate /home/kasm-user/eDEX-UI-Linux-x86_64.AppImage && cp $(echo $(find ./Applications/ -type f -name 'eD*.AppImage' | sed -e '2s/^.//' )) Applications/eDEX-UI-Linux-x86_64.AppImage \
#     \nIcon=Inkscape \
#     \nType=Application \
#     \nCategories=GTK;GNOME;Utility; ")"\
#EOF

#RUN cp "$(echo $(find ./Applications/ -type f -name 'eD*.AppImage' | sed -e '2s/^.//' ))" Applications/eDEX-UI-Linux-x86_64.AppImage


#RUN ./eDEX-UI-Linux-x86_64.AppImage --appimage-extract-and-run --no-sandbox
RUN bash -c "$(/bin/echo -e "cat << 'EOF' | tee -a edexui.desktop \
     \n[Desktop Entry] \
     \nName=edexui \
     \nExec=/home/kasm-user/eDEX-UI-Linux-x86_64.AppImage --appimage-extract-and-run --no-sandbox \
     \nIcon=Inkscape \
     \nType=Application \
     \nCategories=GTK;GNOME;Utility; ")"\
EOF

#COPY <<EOF edexui.desktop
#[Desktop Entry]
#Name=edexui
#Exec=/home/kasm-user/eDEX-UI-Linux-x86_64.AppImage
#Icon=Inkscape
#Type=Application
#Categories=GTK;GNOME;Utility;
#EOF

RUN sed -e 's/EOF//g' edexui.desktop > edexui.desktopx
RUN cp edexui.desktopx /etc/xdg/autostart/edexui.desktop

#RUN chown root sandbox
#RUN chmod 4755 sandbox
#RUN mount -o eDEX-UI-Linux-x86_64.AppImage /mnt
# now, you can run the contents
#/mnt/AppRun
#sudo add-apt-repository ppa:appimagelauncher-team/stable
#sudo apt-get update
#sudo apt-get install appimagelauncher

######### End Customizations ###########

RUN chown 1000:0 $HOME
#RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
