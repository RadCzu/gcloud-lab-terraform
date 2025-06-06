Get-Content .env | ForEach-Object {
  $pair = $_ -split '='
  Set-Item -Path Env:$($pair[0]) -Value $pair[1]
}

echo "enviroment variables set..."