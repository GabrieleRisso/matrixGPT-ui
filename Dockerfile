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
RUN mkdir -p .config/eDEX-UI/

RUN bash -c "$(/bin/echo -e "cat << 'EOF' | tee -a appimagelauncher.cfg \
     \n[AppImageLauncher] \
     \nask_to_move=false \
     \ndestination = /home/kasm-user/ \
     \nenable_daemon = true ")"\
EOF

RUN sed -e 's/EOF//g' appimagelauncher.cfg > appimagelauncher.cfgx
RUN cp appimagelauncher.cfgx .config/appimagelauncher.cfg

#RUN ./eDEX-UI-Linux-x86_64.AppImage --appimage-extract-and-run --no-sandbox
RUN bash -c "$(/bin/echo -e "cat << 'EOF' | tee -a edexui.desktop \
     \n[Desktop Entry] \
     \nName=edexui \
     \nExec=/home/kasm-user/eDEX-UI-Linux-x86_64.AppImage --appimage-extract-and-run --no-sandbox \
     \nIcon=Inkscape \
     \nType=Application \
     \nCategories=GTK;GNOME;Utility; ")"\
EOF

RUN sed -e 's/EOF//g' edexui.desktop > edexui.desktopx
RUN cp edexui.desktopx /etc/xdg/autostart/edexui.desktop

#copy edex ui settings
COPY settings.json .config/eDEX-UI/settings.json
COPY shortcuts.json .config/eDEX-UI/shortcut.json
COPY light.json .config/eDEX-UI/themes/light.json

######### End Customizations ###########

RUN chown 1000:0 $HOME
#RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
