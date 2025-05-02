# Demo

$env.config.show_banner = false;

# https://discuss.kde.org/t/logout-reboot-and-shutdown-using-the-terminal/743/31
def logout [
] {
  qdbus org.kde.LogoutPrompt /LogoutPrompt org.kde.LogoutPrompt.promptLogout
}