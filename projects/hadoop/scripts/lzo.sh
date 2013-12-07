#!/bin/bash
TMP_DIR="/tmp"
echo 'Install "lzo" ...'   |tee -ai $TMP_DIR/install_log                                                      
                                                                                                              
/sbin/ldconfig -p |grep lzo >> /dev/null                                                                      
if [ $? = 0 ];then                                                                                            
      echo "lzo is installed" |tee -ai $TMP_DIR/install_log  
      exit 0                                                
else  
      cd /application/search/tmp/lzo-2.05/
      ./configure --enable-shared --disable-asm --prefix=/usr/local                                           
      make                                                                                                    
      make install                                                                                            
                                                                                                              
      touch /etc/ld.so.conf.d/usr_local_lib.conf                                                              
      echo "/usr/local/lib" > /etc/ld.so.conf.d/usr_local_lib.conf                                           
      /sbin/ldconfig                                                                                          
      /sbin/ldconfig -p |grep lzo && /sbin/ldconfig -v |grep lzo   2>&1 | tee -ai $TMP_DIR/install_log        
      if [ $? = 0 ];then
            echo " [`date`] INFO : lzo install succeed" | tee  -ai $LOG_DIR/install_log
      else
            echo " [`date`] ERROR : lzo intall failed"  | tee  -ai $LOG_DIR/install_log
      fi                                                                                                      
fi
