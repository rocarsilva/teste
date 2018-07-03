#! /bin/bash
# by rogerio.silva@seniorsolution.com.br 


set -e 

JAVASTART=$(java -jar agent.jar -jnlpUrl http://10.158.0.5:8080/computer/slave/slave-agent.jnlp -secret b29463e5906f462ea64609968f81251996f7a08f4acbdbdb1aa14e7b1a0d195a -workDir "/jenkis_slave" &)
PID_AGENT=$(ps -ef | grep java | grep -i "jnlpUrl" | awk '{print $2}')

# case start agent jenkins
case "$1" in
  start)
          echo "Caregando teste"   
          cd /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.171-8.b10.el7_5.x86_64/jre/bin
          echo "Inicializando node slave...$JAVASTART" >> /export/logs/agent.log
          ;;
  stop)
          echo "Encerrando conexão"   
          kill -9 $PID_AGENT
          ;;
     *)
          echo "Usage:  {start|stop}"   
          exit 1
esac
exit 0
