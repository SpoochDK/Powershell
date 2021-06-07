Get-ADUser -Filter * -SearchBase "OU=Ritzau,OU=Users,OU=RIT - STK,DC=ritzau,DC=org" -Properties memberOf |
     Foreach-Object{
         # $_ represents a user object
         $var = [PSCustomObject]@{
                 SID = $_.SamAccountName
                 Name = $_.Name
                 Groups = ""
                                  }
         # create one row for each user, all groups in "Group" column, each separated by ','
         if ($_.memberOf){
             $groups = @()
             $_.memberOf |
                 ForEach-Object{
                     $groups += (Get-ADGroup $_).samaccountname
                 }
             $var.Groups = $groups -join ' , '
             $var
         }
     } | Export-Csv -Path C:\export\GrpMembers.csv -NoTypeInformation