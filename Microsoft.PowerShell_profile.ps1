# powershell $PROFILE
# I had to run this command to get this to work
#  powershell -ExecutionPolicy Bypass -File $PROFILE -Force
oh-my-posh --init --shell pwsh | Invoke-Expression
