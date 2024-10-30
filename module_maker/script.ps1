$dirs = dir .\modules -Directory | ForEach-Object {$_.Name}

foreach ($dir in $dirs) {
  echo "module `"$dir`" {`n  source = `"./modules/$dir`"`n}`n" >> modularized.tf
}