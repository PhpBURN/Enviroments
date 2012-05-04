SP="/home/$(whoami)/core"
DP="/home/$(whoami)/www"
SALIAS="defaultSite"
ENV=""

function chooseEnv() {
selection=
  until [ "$ENV" != "" ] ; do
    echo ""
    echo "Choose the Enviroment Type:"
    echo "1 - DEVELOPMENT"
    echo "2 - STAGE/TEST"
    echo "3 - PRODUCTION"
    echo -n "Enter selection: "
    read selection
    echo ""
    case $selection in
        1 ) ENV="DEV";;
        2 ) ENV="STAGE";;
        3 ) ENV="PROD";;
        * ) echo "Please enter one of the avaliable options"; pressEnter
    esac
  done
}

function chooseRepo() {
selection=
  until [ "$selection" = "1" ] || [ "$selection" = "2" ]; do
    echo ""
    echo "Avaliable Repo Types"
    echo "1 - GIT"
    echo "2 - SVN"
    echo -n "Enter selection: "
    read selection
    echo ""
    case $selection in
        1 ) checkoutGit;;
        2 ) checkoutSvn;;
        * ) echo "Please enter one of the avaliable options"; pressEnter
    esac
  done
}

# @TODO In Future add funcionalities to support more detailed configuration of apache
function configureApache() {
  mkdir -p $SP/sites/	

  source $SP/templates/basic
  source $SP/templates/basic-ssl  

  sudo echo "$VTEMPLATE" > $SP/sites/$SALIAS
  sudo echo "$VTEMPLATE_SSL" > $SP/sites/$SALIAS-SSL

  sudo ln -s $SP/sites/$SALIAS /etc/apache2/sites-enabled/$SALIAS
  sudo ln -s $SP/sites/$SALIAS-SSL /etc/apache2/sites-enabled/$SALIAS-SSL

  HOSTSCONTENT="

# --
# Alias for: $SALIAS
127.0.0.1  $SALIAS

"
  sudo echo "$HOSTSCONTENT" >> /etc/hosts

  sudo /etc/init.d/apache2 restart

  # sudo a2ensite $SALIAS
  # sudo a2ensite $SALIAS-SSL
}

# Checkout GIT
function checkoutGit() {
  echo "Checking out GIT, please enter the full repository url:"
  read url
  echo "Now enter a site alias it will be used to create its folder "
  echo "and also create its virtual host ( http://mysitealias/ )"
  echo "So DO NOT USE spaces"
SALIAS=
until [ "$SOK" = "OK" ]; do
  echo -n "Type an unique site alias: "
  read SALIAS
  echo $DP/$SALIAS
  mkdir -p $DP
  if [ -d "$DP/$SALIAS" ]; then
    echo "This site already exists please delete it first or choose another name"
    pressEnter
    SOK="FAIL"
  else
    SOK="OK"
  fi
done
  ( cd $DP ; git clone $url $SALIAS )
}

# Checkout SVN
function checkoutSvn() {
  echo "Checking out SVN :: NOT IMPLEMENTED YET"
  exit 1
}

# Press Enter Function
function pressEnter() {
  echo ""
  echo -n "Press [ENTER] to continue"
  read
  clear  
}

# Generate Next Step Number
function nextStep() {
  echo $(($1+1))
}

