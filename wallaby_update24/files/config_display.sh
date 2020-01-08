#CMD="dmesg | grep Kernel"
#X=eval $CMD
X=`dmesg | grep hdmi=1`
echo $X


CONFFILE=/etc/X11/xorg.conf.d/20-display.conf
LCDFILE=/etc/X11/xorg.conf.d/20-display.conf.lcd
HDMIFILE=/etc/X11/xorg.conf.d/20-display.conf.hdmi

echo "config_display.sh" > /dev/kmsg

rm -f $CONFFILE

if dmesg | grep -q "hdmi=1"
then
    echo "hdmi"
    ln -s $HDMIFILE $CONFFILE
else
    echo "lcd"
    ln -s $LCDFILE $CONFFILE
fi
