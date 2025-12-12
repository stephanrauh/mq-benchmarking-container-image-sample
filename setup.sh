#!/bin/bash
echo $(ls -CF)

cd /app
echo "Installing jq..."
yum install -y jq > /dev/null 2>&1
yum install wget -y
yum install maven -y /dev/null 2>&1 
yum install unzip -y > /dev/null 2>&1
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip > /dev/null 2>&1
rm -f awscliv2.zip > /dev/null 2>&1

./aws/install


java_version=`java -version |& awk -F '"' '/version/ {print $2}'`
if [[ "$java_version" =~ .*25.*  ]]; then
    echo "Java is up to date"
else 
    echo "Installing Java 25..."
    yum install -y java-25-amazon-corretto-devel > /dev/null 2>&1
fi

echo "export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which javac))))" >> ~/.bashrc
source ~/.bashrc

mvn_version=`mvn -version |& awk '/Apache Maven/ {print $3 }'`
if [[ "$mvn_version" =~ .*3\.6.* ]]; then
    echo "Maven is up to date"
else 
    echo "Updating maven to 3.6..."
    wget https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz > /dev/null 2>&1
    tar zxvf apache-maven-3.8.6-bin.tar.gz > /dev/null 2>&1
    echo "export PATH=/app/apache-maven-3.6.1/bin:$PATH" >> ~/.bashrc
fi

source ~/.bashrc
echo "Done."
