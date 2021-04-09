#!/bin/sh

set -u # en cas de variable non defini arreter le script
set -e # en cas d'erreur le script arreter le script

#script automate install jenkins & partition

PACKAGE_NAME_JENKINS=jenkins
PACKAGE_NAME_JAVA=openjdk-11-jdk
USERJOB=userjenkins

# creation des partition sur les disques 1 & 2
#sudo mkfs -t ext4 /dev/sdc
#sudo mkfs -t ext4 /dev/sdb


#installation de jenkins mais avant java

# Une fonction qui vérifie si jenkins est installé
# et qui sinon l'installe
kgelasse_install_jenkins_package() {
    PACKAGE_NAME="jenkins"
        if ! dpkg -l | grep --quiet "^ii.*$PACKAGE_NAME" ; then
           sudo apt-get install -y gnupg gnupg1 gnupg2
           wget -q -O - https://pkg.jenkins.io/debian-stable/$PACKAGE_NAME.io.key | sudo apt-key add -
           sudo sh -c 'echo deb https://pkg.$PACKAGE_NAME.io/debian binary/ > /etc/apt/sources.list.d/$PACKAGE_NAME.list'
           sudo apt-get update
           apt-get install -y "$PACKAGE_NAME"
           sudo systemctl start jenkins
           echo "Success kgelasse_install_jenkins_package"
        fi
        sudo systemctl start jenkins
}

# Une fonction qui vérifie si jenkins est installé
# et qui sinon l'installe
kgelasse_install_java() {
    PACKAGE_NAME="openjdk"
        if ! dpkg -l | grep --quiet "^ii.*openjdk-11-jdk" ; then
            sudo apt update
            sudo apt install -y openjdk-11-jdk
            echo "Success kgelasse_install_java"
        fi
}

# une fonction qui va creer un user et lui donner les droits pour faire des operations apt-get
kgelasse_create_update_jenkins_user() {
        if ! id "$USERJOB" 2>/dev/null ; then
                echo "$USERJOB doit être créé"
                # on creer le nouvel utilisateur
                #sudo useradd $USERJOB
                #echo "test" | sudo passwd $USERJOB
                sudo useradd -m -p "$USERJOB" "$USERJOB"
                [ $? -eq 0 ] && echo "User $USERJOB has been added !" || echo "Failed !"
                # rajout des droits
                sudo cp /etc/sudoers /etc/sudoers.old
                echo "$USERJOB ALL=(ALL) /usr/bin/apt" | sudo tee -a /etc/sudoers
        fi
}
# Install des packages
#kgelasse_install_jenkins_package
kgelasse_create_update_jenkins_user