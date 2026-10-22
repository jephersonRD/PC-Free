name: win 11 + tailscale + Download.bat script 

on:
  workflow_dispatch:

jobs:
  secure-rdp:
    runs-on: windows-2022
    timeout-minutes: 350

    steps:
      - name: Configure Core RDP Settings
        run: |
          # Enable Remote Desktop and disable Network Level Authentication (if needed)
          Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' `
                             -Name "fDenyTSConnections" -Value 0 -Force
          Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' `
                             -Name "UserAuthentication" -Value 0 -Force
          Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' `
                             -Name "SecurityLayer" -Value 0 -Force

          # Remove any existing rule with the same name to avoid duplication
          netsh advfirewall firewall delete rule name="RDP-Tailscale"
         
          # For testing, allow any incoming connection on port 3389
          netsh advfirewall firewall add rule name="RDP-Tailscale" `
            dir=in action=allow protocol=TCP localport=3389

          # (Optional) Restart the Remote Desktop service to ensure changes take effect
          Restart-Service -Name TermService -Force

      - name: Create RDP User with Fixed Password
        run: |
          $password = "MR.English2008"
          $securePass = ConvertTo-SecureString $password -AsPlainText -Force
          if (-not (Get-LocalUser -Name "RDP" -ErrorAction SilentlyContinue)) {
              New-LocalUser -Name "RDP" -Password $securePass -AccountNeverExpires
          }
          Add-LocalGroupMember -Group "Administrators" -Member "RDP"
          Add-LocalGroupMember -Group "Remote Desktop Users" -Member "RDP"
         
          echo "RDP_CREDS=User: RDP | Password: $password" >> $env:GITHUB_ENV
         
          if (-not (Get-LocalUser -Name "RDP")) {
              Write-Error "User creation failed"
              exit 1
          }

      - name: Install Tailscale
        run: |
          $tsUrl = "https://pkgs.tailscale.com/stable/tailscale-setup-1.82.0-amd64.msi"
          $installerPath = "$env:TEMP\tailscale.msi"
         
          Invoke-WebRequest -Uri $tsUrl -OutFile $installerPath
          Start-Process msiexec.exe -ArgumentList "/i", "`"$installerPath`"", "/quiet", "/norestart" -Wait
          Remove-Item $installerPath -Force

      - name: Establish Tailscale Connection
        run: |
          # Bring up Tailscale with the provided auth key and set a unique hostname
          & "$env:ProgramFiles\Tailscale\tailscale.exe" up --authkey=${{ secrets.TAILSCALE_AUTHKEY }} --hostname=gh-runner-$env:GITHUB_RUN_ID
         
          # Wait for Tailscale to assign an IP
          $tsIP = $null
          $retries = 0
          while (-not $tsIP -and $retries -lt 10) {
              $tsIP = & "$env:ProgramFiles\Tailscale\tailscale.exe" ip -4
              Start-Sleep -Seconds 5
              $retries++
          }
         
          if (-not $tsIP) {
              Write-Error "Tailscale IP not assigned. Exiting."
              exit 1
          }
          echo "TAILSCALE_IP=$tsIP" >> $env:GITHUB_ENV
     
      - name: Verify RDP Accessibility
        run: |
          Write-Host "Tailscale IP: $env:TAILSCALE_IP"
         
          # Test connectivity using Test-NetConnection against the Tailscale IP on port 3389
          $testResult = Test-NetConnection -ComputerName $env:TAILSCALE_IP -Port 3389
          if (-not $testResult.TcpTestSucceeded) {
              Write-Error "TCP connection to RDP port 3389 failed"
              exit 1
          }
          Write-Host "TCP connectivity successful!"

      - name: Maintain Connection + Watch RDP User
        run: |
          Write-Host "`n=== RDP ACCESS ==="
          Write-Host "Address: $env:TAILSCALE_IP"
          Write-Host "Username: RDP"
          Write-Host "Password: $(echo $env:RDP_CREDS)"
          Write-Host "==================`n"

          $rdpProfile = "C:\Users\RDP"
          $startupPath = "$rdpProfile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
          $downloadUrl = "https://gitlab.com/MR.English2008/pcme_rdp/-/raw/main/Downloads.bat"
          $downloadPath = "$startupPath\Downloads.bat"

          while ($true) {
              if (Test-Path $rdpProfile) {
                  try {
                      if (-not (Test-Path $startupPath)) {
                          New-Item -ItemType Directory -Path $startupPath -Force | Out-Null
                      }

                      Invoke-WebRequest -Uri $downloadUrl -OutFile $downloadPath -UseBasicParsing
                      Write-Host "✅ Downloads.bat copied to $downloadPath"

                      # Run the batch file for the first time
                      cmd /c $downloadPath
                      Write-Host "✅ Downloads.bat executed successfully"
                      break
                  }
                  catch {
                      Write-Host "❌ Error copying or executing Downloads.bat: $($_.Exception.Message)"
                      break
                  }
              }
              else {
                  Write-Host "[$(Get-Date)] Waiting for RDP profile to be created..."
                  Start-Sleep -Seconds 30
              }
          }

          # Keep runner alive
          while ($true) {
              Write-Host "[$(Get-Date)] RDP Active - Use Ctrl+C in workflow to terminate"
              Start-Sleep -Seconds 300
          }
