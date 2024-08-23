# ami-jenkins-test-p

This repo creates custom AMI to host Jenkins using Packer

Features:

1. Use Ubuntu 24.04 LTS as source image1

## Packer instruction

(in local test, in `packer` folder, run `export AWS_PROFILE=ghactions` before initiation)(no space around '='!!)

1. `packer fmt jenkins-ami.pkr.hcl`
2. `packer init jenkins-ami.pkr.hcl`
3. `packer validate jenkins-ami.pkr.hcl`                                                            
4. `packer build jenkins-ami.pkr.hcl`  

