{ lib, pkgs, ... }:
let

  blue-artwork.sha256 = "05vyghd28fzm7y5dxx0r2zx0lb08s0p40h9bnqi117818j4i6xms";
  blue-artwork.url = "https://cdn.pixabay.com/photo/2024/01/04/16/28/ai-generated-8487850_1280.jpg";
  christmas-photo-dark.sha256 = "19mr1ynhnzl0fg5hg26nb92969h6am25mzhyg6kmgn4b3yig9yw5";
  christmas-photo-dark.url = "https://cdn.pixabay.com/photo/2024/11/19/00/04/wallpaper-9207726_1280.png";
  dog-closeup-photo-dark.sha256 = "1xb37n974d9466lyk526xw6x92kyx98728wxwzsnvf6ywjbpnlg8";
  dog-closeup-photo-dark.url = "https://i2.pickpik.com/photos/213/179/661/dog-head-eye-pupil-dog-look-c72f72c4dfd56f1a3fa2a40121a12795.jpg";
  dog-sunset-photo-dark.sha256 = "113hbc5p0pqqh2nj9df3qhr5bymky7ssqcc0ixld2f03jsiq3ydk";
  dog-sunset-photo-dark.url = "https://i1.pickpik.com/photos/142/189/178/dog-wolf-profile-dog-sunset-ec5a3da4aaf31bd6e7578e0573bbe207.jpg";
  hoody-artwork-dark.sha256 = "08n5k9clc76fkmp9g7wb7pk91v47n3a48k676d9parlyzl5klxi5";
  hoody-artwork-dark.url = "https://cdn.pixabay.com/photo/2023/10/03/19/32/ai-generated-8292337_1280.png";
  husky-photo-dark.sha256 = "17j1q3pp6k6cphfrmn5ccbjlzv95vydjhf5s0sbbisb3r07j2kbk";
  husky-photo-dark.url = "https://images.pexels.com/photos/4594148/pexels-photo-4594148.jpeg";
  husky-simple-photo-dark.sha256 = "0pjkhmbww7s7ccb0aka7kc7svwpf48n6ajvd6bbj7qldyx8s6szy";
  husky-simple-photo-dark.url = "https://images.pexels.com/photos/11755247/pexels-photo-11755247.jpeg";
  mushing-artwork-light.sha256 = "1acbzw6cv2mkvd3jca58yj0cbgzlzxid42hh4c0w3h94bwgxw878";
  mushing-artwork-light.url = "https://cdn.pixabay.com/photo/2020/06/23/07/28/poles-5331672_1280.jpg";
  puppy-photo-light.sha256 = "0xgqb9jjfx4b9vc4wikzshwlb5lj2mvqn0nhnxczsa2639f5458l";
  puppy-photo-light.url = "https://images.pexels.com/photos/3640877/pexels-photo-3640877.jpeg";

  default-light = builtins.fetchUrl blue-artwork;
  default-dark = builtins.fetchUrl blue-artwork;

  dconf1.settings."org/gnome/desktop/background".picture-uri = "file://${default-light}";
  dconf1.settings."org/gnome/desktop/background".picture-uri-dark = "file://${default-dark}";

in
{
  services.xserver.desktopManager.gnome.extraGSettingsOverrides = ''
    [org/gnome/desktop/background]
    picture-uri='file://${default-light}'
    picture-uri-dark='file://${default-dark}'
  '';
  programs.dconf.profiles.user.databases = [ dconf1 ];
}

