{ config, ... }:{
    services.xserver.xkb.layout = config.huskyos.keyboardLayout;
}