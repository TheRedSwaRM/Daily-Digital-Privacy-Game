Get-ChildItem "D:\UPD\CS 198-199\Daily-Digital-Privacy-Game\assets" -recurse | 
  Where {-Not $_.PSIsContainer} | 
  Rename-Item -NewName {$_.FullName.ToLower()}