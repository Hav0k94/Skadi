{
  user = {
    name = "toto";
    mail = "toto@example.org";
  };
  git = {
    signingKey = "~/.ssh/id_ed25519.pub";
    signingKeyContent = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF/WTo7ZO3o0N1UPQihc0jWJBqBmdSCHEET+NydKjKPO toto";
  };
  sshkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF/WTo7ZO3o0N1UPQihc0jWJBqBmdSCHEET+NydKjKPO toto";
  hostname = {
    vps = "vps";
    wsl = "wsl";
  };
}
