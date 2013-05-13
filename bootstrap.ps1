param( 
[Parameter(ParameterSetName='switches')]
[switch]$programs=$false,
[Parameter(ParameterSetName='switches')]
[switch]$prefs=$false,
[Parameter(ParameterSetName='all')]
[switch]$all=$false
)

function clone-or-pull($repo) {
  $repoPath = "https://kberridge@bitbucket.org/kberridge/$repo"
  if (-not (test-path $repo)) { hg clone $repoPath }
  else { 
    pushd ".\$repo"
    hg pull -u
    popd
  }
}

function deploy($repo) {
  pushd $repo
  .\deploy.ps1
  popd
}

if ($all -or $programs) {
  write-host "installing programs..."
  
  cinst vim
  cinst ruby
  #cinst ruby.devkit #didn't work!
  cinst console2
  #cinst 7zip
  cinst sysinternals
  #cinst paint.net
  #cinst adobereader
  cinst linqpad4
  #cinst virtualclonedrive
  cinst git
}

if ($all -or $prefs) {
  write-host "cloning preferences repositories..."

  if (-not (test-path "\projects")) { mkdir "\projects" > $null }
  pushd "\projects"
  clone-or-pull "hg-prefs"
  clone-or-pull "posh-prefs"
  clone-or-pull "vim-prefs"
  deploy "posh-prefs"
  deploy "vim-prefs"
  deploy "hg-prefs"
  popd
}
