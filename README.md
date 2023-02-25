# DockerGitlabUpgrade
CMD/Powershell scripts to update a docker installation of gitlab from previous to current versions This is a work in progress and mostly cobbled together for just a migration , but it may prove of value to someone out there.

It aims to automate the migration from a starting old version of gitlab to the last version available at the moment. It needs a .tar file containing the backup of the old server (my initial version is 13.5.3) and an etc\ directory where you have exported all the needed files from the old version containing your user/groups/projects.. \etc gitlab-secrets.json gitlab.rb ssh_host_ecdsa_key ssh_host_ecdsa_key.pub ssh_host_ed25519_key ssh_host_ed25519_key.pub ssh_host_rsa_key ssh_host_rsa_key.pub \trusted-certs

First , have a docker up and running in your machine. Next , edit the restaura.cmd file to set your working directory and the directory where you wish to place the docker files Finally , check gitlab.env file to make sure the paths are sane to your system. If that is all good you can proceed to the more complex update.cmd

Here I have one section per yml version file to deal with the upgrade and waiting for the migrations to occur before going for the next update.

I'm working on a saner version using powershell (actualizador.ps1) but it is not quite there yet. The aim is to iterate thru all the keypoint versions in the array and perform the same actions for each version , quite more easy to mantain, and not needing a different yml for each version.

Afterwards , run restaura.cmd from a windows cmd or just double click it from the installed folder and let it do its thing. When the restoration is done it will call the update.cmd and go for the update route.

Credit to https://gitlab-com.gitlab.io/support/toolbox/upgrade-path/?current=13.4.7&distro=docker&edition=ce for showing the keypoints (would be nice an endpoint to get a json with the versions!)

https://ss64.com/ So many time since I did dos batch files that I needed to relearn every command there.

https://stackoverflow.com/questions/6359820/how-to-set-commands-output-as-a-variable-in-a-batch-file That stumped me for more time that I care to assume.

TODO : Use one centralized point to define the configuration of directories Accept a parameter with the url of the gitlab installation , get its version an prepare a route to get to the last published version Bug squashing.
