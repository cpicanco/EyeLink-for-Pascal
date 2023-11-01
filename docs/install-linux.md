# clone the repository
git clone --recursive https://github.com/cpicanco/stimulus-control-sdl2.git

# install EyeLink development environment
```
sudo apt install ca-certificates
sudo apt-key adv --fetch-keys https://apt.sr-research.com/SRResearch_key
sudo add-apt-repository 'deb [arch=amd64] https://apt.sr-research.com SRResearch main'
```
// if necessary, change srresearch to SRResearch in
# nano /etc/apt/sources.list.d/archive_uri-https_apt_sr-research_com-jammy.list

sudo apt update
sudo apt install eyelink-display-software

# install zeromq
cd /stimulus-control-sdl2/depencendies/zeromq4-1/
./autogen.sh
./configure --enable-static
make
sudo make install
sudo ldconfig
