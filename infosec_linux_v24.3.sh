#!/bin/sh
HOSTNAME=`hostname`
DATE=`date +%m%d`
JEUS_HOME=/usr/local/jeus
DOMAIN_HOME=$JEUS_HOME/domains

LANG=C
export LANG

clear
sleep 1

SVersion=24.3
SLast_update=2024.10

function perm {
	ls -l $1 | awk '{
   k = 0
   s = 0
   for( i = 0; i <= 8; i++ )
   {
       k += ( ( substr( $1, i+2, 1 ) ~ /[rwxst]/ ) * 2 ^( 8 - i ) )
   }
   j = 4
   for( i = 4; i <= 10; i += 3 )
   {
       s += ( ( substr( $1, i, 1 ) ~ /[stST]/ ) * j )
       j/=2
   }
   if ( k )
   {
       printf( "%0o%0o ", s, k )
   } else
       {
               printf ( "0000 " )
       }

   print
	}'
}

echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#################################  Preprocessing...  #####################################"
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1

# FTP 서비스 동작확인
find /etc/ -name "proftpd.conf" | grep "/etc/"                                                     > proftpd.txt
find /etc/ -name "vsftpd.conf" | grep "/etc/"                                                      > vsftpd.txt
profile=`cat proftpd.txt`
vsfile=`cat vsftpd.txt`


############################### APACHE Check Process Start ##################################

#0. 필요한 함수 선언

apache_awk() {
	if [ `ps -ef | grep -i $1 | grep -v "ns-httpd" | grep -v "grep" | awk '{print $8}' | grep "/" | grep -v "httpd.conf" | uniq | wc -l` -gt 0 ]
	then
		apaflag=8
	elif [ `ps -ef | grep -i $1 | grep -v "ns-httpd" | grep -v "grep" | awk '{print $9}' | grep "/" | grep -v "httpd.conf" | uniq | wc -l` -gt 0 ]
	then
		apaflag=9
	fi
}

# 1. 아파치 프로세스 구동 여부 확인 및 아파치 TYPE 판단, awk 컬럼 확인

if [ `ps -ef | grep -i "httpd" | grep -v "ns-httpd" | grep -v "lighttpd" | grep -v "grep" | wc -l` -gt 0 ]
then
	apache_type="httpd"
	apache_awk $apache_type

elif [ `ps -ef | grep -i "apache2" | grep -v "ns-httpd" | grep -v "lighttpd" | grep -v "grep" | wc -l` -gt 0 ]
then
	apache_type="apache2"
	apache_awk $apache_type
else
	apache_type="null"
	apaflag=0	
fi

# 2. 아파치 홈 디렉토리 경로 확인

if [ $apaflag -ne 0 ]
then

	if [ `ps -ef | grep -i $apache_type | grep -v "ns-httpd" | grep -v "grep" | awk -v apaflag2=$apaflag '{print $apaflag2}' | grep "/" | grep -v "httpd.conf" | uniq | wc -l` -gt 0 ]
	then
		APROC1=`ps -ef | grep -i $apache_type | grep -v "ns-httpd" | grep -v "grep" | awk -v apaflag2=$apaflag '{print $apaflag2}' | grep "/" | grep -v "httpd.conf" | uniq`
		APROC=`echo $APROC1 | awk '{print $1}'`
		$APROC -V > APROC.txt 2>&1
				
		ACCTL=`echo $APROC | sed "s/$apache_type$/apachectl/"`
		$ACCTL -V > ACCTL.txt 2>&1
				
		if [ `cat APROC.txt | grep -i "root" | wc -l` -gt 0 ]
		then
			AHOME=`cat APROC.txt | grep -i "root" | awk -F"\"" '{print $2}'`
			ACFILE=`cat APROC.txt | grep -i "server_config_file" | awk -F"\"" '{print $2}'`
			AVERSION=`cat APROC.txt | grep -i "version"`
		else
			AHOME=`cat ACCTL.txt | grep -i "root" | awk -F"\"" '{print $2}'`
			ACFILE=`cat ACCTL.txt | grep -i "server_config_file" | awk -F"\"" '{print $2}'`
			AVERSION=`cat ACCTL.txt | grep -i "version"`			
		fi
	fi
	
	if [ -f $AHOME/$ACFILE ]
	then
		ACONF=$AHOME/$ACFILE
	else
		ACONF=$ACFILE
	fi	
fi

# 3. 불필요한 파일 삭제

rm -rf APROC.txt
rm -rf ACCTL.txt

################################ APACHE Check Process End ###################################

clear
sleep 1
echo " " > $HOSTNAME.$DATE.linux.result.txt 2>&1

echo "***************************************************************************************"
echo "***************************************************************************************"
echo "*                                                                                     *"
echo "*  Linux Security Checklist version $SVersion                                         *"
echo "*                                                                                     *"
echo "***************************************************************************************"
echo "***************************************************************************************"

echo "=======================================================================================" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■■■■■■■■■■■■■■■■■■■             Linux Security Check           	 ■■■■■■■■■■■■■■■■■■■■" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■■■■■■■■■■■■■■■■■■■      Copyright ⓒ 2024, SK shieldus Co. Ltd.    ■■■■■■■■■■■■■■■■■■■■" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■■■■■■■■■■■■■■■■■■■     Ver $SVersion // Last update $SLast_update ■■■■■■■■■■■■■■■■■■■■" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1

echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "##################################  Start Time  #######################################"
date
echo "##################################  Start Time  #######################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
date                                                                                           		>> $HOSTNAME.$DATE.linux.result.txt 2>&1

echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "*************************************** START *****************************************"
echo "*************************************** START *****************************************" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
sleep 1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "############################     5.3.2.  보안관리     #################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "               
sleep 1                                                                        		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-001 START"                                                                           		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#############           SNMP community 스트링 설정 오류           				#############"
echo "#############           SNMP community 스트링 설정 오류            				#############" 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: SNMP Community string 초기 값(public, private)이 아니고 아래의 복잡도를 만족할 경우 양호"            	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 복잡도 : 영문자, 숫자가 포함된 10자리 이상 또는 영문자, 숫자, 특수문자 포함 8자리 이상일 경우 양호"         			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ [참고] SNMP V3의 경우 별도 인증기능을 사용하고 해당 비밀번호가 복잡도를 만족할 경우 양호로 판단"         			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                               	   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① SNMP 서비스 활성화 여부 확인(UDP 161)"                                                				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `netstat -na | grep ":161 " | grep -i "^udp" | wc -l` -eq 0 ]
then
	echo "☞ SNMP Service Disable"                                                             		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disabled"
else
	netstat -na | grep ":161 " | grep -i "^udp"                                                		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Interview"
fi
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "② SNMP Community String 설정 값"                                                        		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/snmpd.conf ]
then
	echo "● /etc/snmpd.conf 파일 설정:"                                                        		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------"                              		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	cat /etc/snmpd.conf | egrep -i "public|private|com2sec|community" | grep -v "^#"           		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                   		> snmpd.txt
fi
if [ -f /etc/snmp/snmpd.conf ]
then
	echo "● /etc/snmp/snmpd.conf 파일 설정:"                                                   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------"                              		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	cat /etc/snmp/snmpd.conf | egrep -i "public|private|com2sec|community" | grep -v "^#"      		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                   		> snmpd.txt
fi
if [ -f /etc/snmp/conf/snmpd.conf ]
then
	echo "● /etc/snmp/conf/snmpd.conf 파일 설정:"                                              		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------"                              		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	cat /etc/snmp/conf/snmpd.conf | egrep -i "public|private|com2sec|community" | grep -v "^#" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                   		> snmpd.txt
fi
if [ -f /SI/CM/config/snmp/snmpd.conf ]
then
	echo "● /SI/CM/config/snmp/snmpd.conf 파일 설정:"                                              	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------"                                  	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	cat /SI/CM/config/snmp/snmpd.conf | egrep -i "public|private|com2sec|community" | grep -v "^#" 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                       	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                       	> snmpd.txt
fi

if [ -f snmpd.txt ]
then
	rm -rf snmpd.txt
else
	echo "snmpd.conf 파일이 없습니다."                                                         			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo Result=$flag1                                                                         		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-001 END"                                                                             		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 

#24년 개선 사항 : Postfix, Exim 확인
sleep 1
echo "SRV-004 START"                                                                           		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#################           불필요한 SMTP 서비스 실행 			            #################"
echo "#################           불필요한 SMTP 서비스 실행             			#################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: SMTP가 동작 중이지 않거나, 업무상 사용 중인 경우 양호"                           					>> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "■ 현황"                                                                                  		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① Sendmail/Postfix/Exim 프로세스 확인"                                    					    >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | egrep -i "sendmail|postfix|exim" | grep -v grep | wc -l` -gt 0 ]
then
    flag1="Enabled"
    ps -ef | egrep -i "sendmail|postfix|exim" | grep -v grep													   											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "☞ Sendmail|Postfix|Exim Service Disable"                                                         												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disabled"
fi
echo " "                                                                                       																>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "② /etc/services 파일에서 포트 확인"                                                     																	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          																>> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp"   		       																	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       																>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "③ 서비스 포트 활성화 여부 확인"                                                         																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          																>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2="Enabled"
	else
		echo "☞ Sendmail/Postfix/Exim Service Disable"                                                     												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2="Disabled"
	fi
else
	echo "서비스 포트 확인 불가" 				                                               				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result=$flag1":"$flag2                                                                    		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-004 END"                                                                             		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 

#24년 개선사항 : postfix, exim 추가
sleep 1
echo "SRV-005 START"                                                                           		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "###########           SMTP 서비스 expn/vrfy 명령어 실행 제한 미비 			           ##########"
echo "###########           SMTP 서비스 expn/vrfy 명령어 실행 제한 미비            		   ##########" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: expn, vrfy 명령어 사용을 허용하지 않고 있을 경우 양호"  										   	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① sendmail 프로세스 확인"                                    					       				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep sendmail | grep -v grep | wc -l` -gt 0 ]
then
	flag1="Interview"
	ps -ef | grep sendmail | grep -v grep													   						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	
    echo " "                                                                                   						>> $HOSTNAME.$DATE.linux.result.txt 2>&1    
	echo "② /etc/mail/sendmail.cf 파일의 옵션 확인"                                                						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"      						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/mail/sendmail.cf ]
	then
	    grep -v '^ *#' /etc/mail/sendmail.cf | grep PrivacyOptions                                  				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	    if [ `grep -v '^ *#' /etc/mail/sendmail.cf | grep PrivacyOptions | grep noexpn | wc -l` -eq 0 ]
		then
				flag2="F"    
		else
	    	if [ `grep -v '^ *#' /etc/mail/sendmail.cf | grep PrivacyOptions | grep novrfy | wc -l` -eq 0 ]
			then
				flag2="F"
			else
				flag2="O"
			fi
		fi
	else
		echo "/etc/sendmail.cf 파일이 없습니다."                                                 						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2="Null"
	fi
	
	echo " "                                                                                       					>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "③ /etc/sendmail.cf 파일의 옵션 확인"                                                							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"      						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/sendmail.cf ]
	then
	    grep -v '^ *#' /etc/sendmail.cf | grep PrivacyOptions                                  						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	    if [ `grep -v '^ *#' /etc/sendmail.cf | grep PrivacyOptions | grep noexpn | wc -l` -eq 0 ]
		then
				flag2="F"    
		else
			if [ `grep -v '^ *#' /etc/sendmail.cf | grep PrivacyOptions | grep novrfy | wc -l` -eq 0 ]
			then
				flag2="F"
			else
				flag2="O"
			fi
		fi
	else
		echo "/etc/sendmail.cf 파일이 없습니다."                                                 						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2="Null"
	fi
else
	echo "☞ Sendmail Service Disable"                                                         						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disabled"
fi

echo " "                                    					       												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "➃ Postfix 프로세스 확인"                                    					       								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep postfix | grep -v grep | wc -l` -gt 0 ]
then
	flag1="Interview"
	ps -ef | grep postfix  | grep -v grep			  																>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	
	echo " "                                                                                   						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "⑤ /etc/postfix/main.cf 파일의 옵션 확인"                                                						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"     						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/postfix/main.cf ]
	then
	grep -v '^ *#' /etc/postfix/main.cf | grep disable_vrfy_command      											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		if [ `grep -v '^ *#' /etc/postfix/main.cf | grep disable_vrfy_command | wc -l` -eq 0 ]
		then
			echo "disable_vrfy_command 설정 미 존재"											      					>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			flag2="F"
		elif [ `grep -v '^ *#' /etc/postfix/main.cf | grep disable_vrfy_command | grep -i "no" | wc -l` -gt 0 ]
		then
			cat /etc/postfix/main.cf | grep disable_vrfy_command								  					>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			flag2="F"
		else
			cat /etc/postfix/main.cf | grep disable_vrfy_command													>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			flag2="O"
		fi
	else
		echo "☞ /etc/postfix/main.cf 파일이 존재하지 않음"									  							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "☞ Postfix Service Disable"														   						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disabled"
fi

echo " "                                                                                   									>> $HOSTNAME.$DATE.linux.result.txt 2>&1	
echo "⑥ Exim 프로세스 확인" 		                                    					       								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep exim | grep -v grep | wc -l` -gt 0 ]
then
	flag1="Interview"
	ps -ef | grep exim | grep -v grep 														   								>> $HOSTNAME.$DATE.linux.result.txt 2>&1

	echo " "                                                                                   								>> $HOSTNAME.$DATE.linux.result.txt 2>&1	
	echo "⑦ Exim 설정 파일 확인(/etc/exim*/exim*.conf.template)"								   								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "----------------------------------------------------"								   								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/exim*/exim*.conf.template ]
	then
		if [ `cat /etc/exim*/exim*.conf.template | grep -v "#" | egrep "acl_smtp_expn|acl_smtp_vrfy" | wc -l` -gt 0 ]
		then
			cat /etc/exim*/exim*.conf.template | grep -v "#" | egrep "acl_smtp_expn|acl_smtp_vrfy"   						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		fi
	else
		echo "☞ /etc/exim*/exim*.conf.template 파일이 존재하지 않음"							   									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi

	echo " "                                                                                   								>> $HOSTNAME.$DATE.linux.result.txt 2>&1		
	echo "⑧ Exim 설정 파일 확인(/etc/exim*/exim*.conf)"								  		   									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "----------------------------------------------------"								   								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/exim*/exim*.conf ]
	then
		if [ `cat /etc/exim*/exim*.conf | grep -v "#" | egrep "acl_smtp_expn|acl_smtp_vrfy" | wc -l` -gt 0 ]
		then
		cat /etc/exim*/exim*.conf | grep -v "#" | egrep "acl_smtp_expn|acl_smtp_vrfy" 		   								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		fi
	else
		echo "☞ /etc/exim*/exim*.conf 파일이 존재하지 않음"									   									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi

	echo " "                                                                                   								>> $HOSTNAME.$DATE.linux.result.txt 2>&1		
	echo "⑨ Exim 설정 파일 확인(/etc/exim*/conf.d/*.conf)"									   									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "----------------------------------------------------"								   								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/exim*/conf.d/*.conf ]
	then
		if [ `cat /etc/exim*/conf.d/*.conf | grep -v "#" | egrep "acl_smtp_expn|acl_smtp_vrfy" | wc -l` -gt 0 ]
		then
		cat /etc/exim*/conf.d/*.conf | grep -v "#" | egrep "acl_smtp_expn|acl_smtp_vrfy"	 	   							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
        fi
	else
		echo "☞ /etc/exim*/conf.d/*.conf 파일이 존재하지 않음"								  	 								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "☞ Exim Service Disable"															   								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disabled"
fi

echo " "                                                                                       																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "[참고]"                                                                              	   																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "/etc/services 파일에서 포트 확인"                                                          																			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp"                    																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "서비스 포트 활성화 여부 확인"                                                        	   	   																			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"                                          																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "☞ Sendmail Service Disable"                                                     																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "서비스 포트 확인 불가" 				                                               																				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                   																			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result=$flag1":"$flag2                                                                																			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-005 END"                                                                             																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 

#24년 개선사항 : postfix, exim 추가
sleep 1
echo "SRV-006 START"                                                                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "####################          SMTP 서비스 로그 수준 설정 미흡          ####################"
echo "####################          SMTP 서비스 로그 수준 설정 미흡          ####################" 											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준"																															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "[ Sendmail ]"																													>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "1. sendmail.cf 설정 파일 내부의 LogLevel 설정값 확인"																					>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "2. LogLevel 설정값이 기본값 이상의 수준(9 이상)인지 확인"																					>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "																															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "[ Postfix ]"																													>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "1. syslog(/etc/syslog.conf, /etc/rsyslog.conf, /etc/rsyslog.d/ 경로) 설정 파일 확인"												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "2. debug_peer_level 설정값이 기본값 이상의 수준(2 이상)인지 확인"																			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "																															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "[ Exim ]"																														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "1. 설정 파일 확인 (/etc/exim*/exim*.conf.template 또는 /etc/exim*/exim*.conf 또는 /etc/exim*/conf.d/*.conf)"							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "2. log_level 설정값*이 기본값 이상의 수준(5 이상)인지 확인"																				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "설정값이 없는 경우 Default 값: 5"																									>> $HOSTNAME.$DATE.linux.result.txt 2>&1

echo "■ 현황"																															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① sendmail 프로세스 확인"																											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "---------------------------------------------------------------------------------------"										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep sendmail | grep -v grep | wc -l` -gt 0 ]
then
	flag1="Interview"
	ps -ef | grep sendmail | grep -v grep																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "																														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "② /etc/mail/sendmail.cf 파일 확인"																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "---------------------------------------------------------------------------------------"									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/mail/sendmail.cf ]
	then
		if [ `cat /etc/mail/sendmail.cf | grep -v "#" | grep -i LogLevel | wc -l` -eq 0 ]
		then 
			echo "LogLevel 설정이 안되어 있음"																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			flag1="Interview"			
		else
			if [ `cat /etc/mail/sendmail.cf | grep -v "#" | grep -i LogLevel | awk -F= '{print $2}'` -ge 9 ]
			then 
				cat /etc/mail/sendmail.cf | grep -v "#" | grep -i LogLevel															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				flag2="O"																	
			else 
				cat /etc/mail/sendmail.cf | grep -v "#" | grep -i LogLevel															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				flag2="X"											
			fi
		fi
	else
		echo "☞ /etc/mail/sendmail.cf 파일이 존재하지 않음"																				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi

	echo " "																														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "③ /etc/sendmail.cf 파일 확인"																								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "---------------------------------------------------------------------------------------"									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/sendmail.cf ]
	then
		if [ `cat /etc/sendmail.cf | grep -v "#" | grep -i LogLevel | wc -l` -eq 0 ]
		then 
			echo "☞ LogLevel 설정이 안되어 있음"																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			flag1="Interview"			
		else  
			if [ `cat /etc/sendmail.cf | grep -v "#" | grep -i LogLevel | awk -F= '{print $2}'` -ge 9 ]
			then
				cat /etc/sendmail.cf | grep -v "#" | grep -i LogLevel																>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				flag2="O"																
			else 
				cat /etc/sendmail.cf | grep -i LogLevel																				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				flag2="X"																
			fi
		fi    
	else
		echo "☞ /etc/sendmail.cf 파일이 존재하지 않음"																					>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "☞ Sendmail Service Disable"																								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag3="Disabled"
fi

echo " "                                                                                   											>> $HOSTNAME.$DATE.linux.result.txt 2>&1	
echo "➃ Postfix 프로세스 확인"																											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "---------------------------------------------------------------------------------------"										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep postfix | grep -v grep | wc -l` -gt 0 ]
then
	flag1="Interview"
	ps -ef | grep postfix | grep -v grep																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	
	echo " "																														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "➄ syslog(/etc/syslog.conf 경로) 설정 파일 확인"																				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "---------------------------------------------------------------------------------------"									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/syslog.conf ]
	then
		if [ `cat /etc/syslog.conf | grep -v "#" | grep -i debug_peer_level | wc -l` -eq 0 ]
		then 
			echo "debug_peer_level설정이 안되어 있음"																						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			flag1="Interview"			
		else
			if [ `cat /etc/syslog.conf | grep -v "#" | grep -i debug_peer_level | awk -F= '{print $2}'` -ge 2 ]
			then 
				cat /etc/syslog.conf | grep -v "#" | grep -i debug_peer_level														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				flag2="O"																	
			else 
				cat /etc/syslog.conf | grep -i debug_peer_level																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				flag2="X"											
			fi
		fi
	else
		echo "☞ /etc/syslog.conf 파일이 존재하지 않음"																					>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi

	echo " "																														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "➅ syslog(/etc/rsyslog.conf 경로) 설정 파일 확인"																				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "---------------------------------------------------------------------------------------"									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/rsyslog.conf ]
	then
		if [ `cat /etc/rsyslog.conf | grep -v "#" | grep -i debug_peer_level | wc -l` -eq 0 ]
		then 
			echo "debug_peer_level설정이 안되어 있음"																						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			flag1="Interview"			
		else
			if [ `cat /etc/rsyslog.conf | grep -v "#" | grep -i debug_peer_level | awk -F= '{print $2}'` -ge 2 ]
			then 
				cat /etc/rsyslog.conf | grep -v "#" | grep -i debug_peer_level														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				flag2="O"																	
			else 
				cat /etc/rsyslog.conf | grep -v "#" | grep -i debug_peer_level														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				flag2="X"											
			fi
		fi
	else
		echo "☞ /etc/rsyslog.conf 파일이 존재하지 않음"																					>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi

	echo " "																														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "➆ syslog(/etc/rsyslog.d/ 경로) 설정 파일 확인"																					>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "-------------------------------------------"																				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/rsyslog.d/* ]
	then
		if [ `cat /etc/rsyslog.d/* | grep -v "#" | grep -i debug_peer_level | wc -l` -eq 0 ]
		then 
			echo "debug_peer_level설정이 안되어 있음"																						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			flag1="Interview"			
		else
			if [ `cat /etc/rsyslog.d/* | grep -v "#" | grep -i debug_peer_level | awk -F= '{print $2}'` -ge 2 ]
			then 
				cat /etc/rsyslog.d/* | grep -v "#" | grep -i debug_peer_level														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				flag2="O"																	
			else 
				cat /etc/rsyslog.d/* | grep -v "#" | grep -i debug_peer_level														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				flag2="X"											
			fi
		fi
	else
		echo "☞ /etc/rsyslog.d/ 경로에 파일이 존재하지 않음"																				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "☞ Postfix Service Disable"																								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag3="Disabled"
fi

echo " "                                                                                   											>> $HOSTNAME.$DATE.linux.result.txt 2>&1	
echo "➇ Exim 프로세스 확인"																												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "---------------------------------------------------------------------------------------"										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep exim | grep -v grep | wc -l` -gt 0 ]
then
	flag1="Interview"
	ps -ef | grep exim  | grep -v grep																								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	
	echo " "																														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "➈ Exim 설정 파일 확인 (/etc/exim*/exim*.conf.template)"																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "---------------------------------------------------------------------------------------"									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/exim*/exim*.conf.template ]
	then
		if [ `cat /etc/exim*/exim*.conf.template | grep -v "#" | grep -i log_level  | wc -l` -eq 0 ]
		then 
			echo "log_level 설정이 안되어 있음"																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			flag1="Interview"			
		else
			if [ `cat /etc/exim*/exim*.conf.template | grep -v "#" | grep -i log_level | awk -F= '{print $2}'` -ge 5 ]
			then 
				cat /etc/exim*/exim*.conf.template | grep -v "#" | grep -i log_level												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				flag2="O"																	
			else 
				cat /etc/exim*/exim*.conf.template | grep -v "#" | grep -i log_level												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				flag2="X"											
			fi
		fi
	else
		echo "☞ /etc/exim*/exim*.conf.template 파일이 존재하지 않음"																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi

	echo " "																														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "➉ Exim 설정 파일 확인 (/etc/exim*/exim*.conf)"																				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "---------------------------------------------------------------------------------------"									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/exim*/exim*.conf ]
	then
		if [ `cat /etc/exim*/exim*.conf | grep -v "#" | grep -i log_level  | wc -l` -eq 0 ]
		then 
			echo "log_level 설정이 안되어 있음"																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			flag1="Interview"			
		else
			if [ `cat /etc/exim*/exim*.conf | grep -v "#" | grep -i log_level | awk -F= '{print $2}'` -ge 5 ]
			then 
				cat /etc/exim*/exim*.conf | grep -v "#" | grep -i log_level															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				flag2="O"																	
			else 
				cat /etc/exim*/exim*.conf | grep -v "#" | grep -i log_level															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				flag2="X"											
			fi
		fi
	else
		echo "☞ /etc/exim*/exim*.conf 파일이 존재하지 않음"																				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi

	echo " "																														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "⑪ Exim 설정 파일 확인 (/etc/exim*/conf.d/*.conf)"																				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "---------------------------------------------------------------------------------------"									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/exim*/conf.d/*.conf ]
	then
		if [ `cat /etc/exim*/conf.d/*.conf | grep -v "#" | grep -i log_level  | wc -l` -eq 0 ]
		then 
			echo "log_level 설정이 안되어 있음"																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			flag1="Interview"			
		else
			if [ `cat /etc/exim*/conf.d/*.conf | grep -v "#" | grep -i log_level | awk -F= '{print $2}'` -ge 5 ]
			then 
				cat /etc/exim*/conf.d/*.conf | grep -v "#" | grep -i log_level														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				flag2="O"																	
			else 
				cat /etc/exim*/conf.d/*.conf | grep -v "#" | grep -i log_level														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				flag2="X"											
			fi
		fi
	else
		echo "☞ /etc/exim*/conf.d/*.conf 파일이 존재하지 않음"																			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "☞ Exim Service Disable"																									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag3="Disabled"
fi
echo " "																															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "[참고]"																															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "																															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "/etc/services 파일에서 포트 확인"																									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp"															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "																															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "서비스 포트 활성화 여부 확인"																											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"																				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "☞ Sendmail Service Disable"																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "서비스 포트 확인 불가"																											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "																															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result=$flag1":"$flag2":"$flag3																								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "																															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-006 END"																													>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################"										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "======================================================================================="										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "																															>> $HOSTNAME.$DATE.linux.result.txt 2>&1

#24년 개선 사항 : Postfix, Exim 추가
sleep 1
echo "SRV-007 START"																												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "###########################################################################################"									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "###############           취약한 버전의 SMTP 서비스 사용 			            #################"
echo "###############           취약한 버전의 SMTP 서비스 사용 			            #################"										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "###########################################################################################"									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: SMTP 서비스 버전이 최신 버전일 경우 또는 금융회사 내부 규정에 따라 패치 검토 및 패치를 수행하고 있는 경우"											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"																															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① sendmail 프로세스 확인"																											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep sendmail | grep -v grep | wc -l` -gt 0 ]
then
	flag1="Interview"
	ps -ef | grep sendmail | grep -v grep																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "																														>> $HOSTNAME.$DATE.linux.result.txt 2>&1

	echo "② sendmail 버전확인(최신버전 : 8.17.2)"																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "※ 최소 8.14.9 이상 버전 사용(접근제한 우회 취약점 : CVE-2009-4565)"																	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/mail/sendmail.cf ]
	then
	     grep -v '^ *#' /etc/mail/sendmail.cf | grep DZ																				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "/etc/mail/sendmail.cf 파일이 없습니다."																					>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
	echo " "																														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "☞ Sendmail Service Disable"																								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disabled"
fi

echo " "                                                                                   											>> $HOSTNAME.$DATE.linux.result.txt 2>&1	
echo "③ postfix 프로세스 확인"																											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep postfix | grep -v grep | wc -l` -gt 0 ]
then
	flag1="Interview"
	ps -ef | grep postfix | grep -v grep																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "																														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "④ postfix 버전확인"																											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "※ 2.5일 경우 최소 2.5.13 이상 사용"																								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "※ 2.6일 경우 최소 2.6.10 이상 사용"																								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "※ 2.7일 경우 최소 2.7.4 이상 사용"																								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "※ 2.8일 경우 최소 2.8.3 이상 사용(DoS 또는 코드 실행 취약점 : CVE-2011-1720)"															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	postconf -d mail_version | awk -F= '{print $2}'																					>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "☞ postfix Service Disable"																								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disable"
fi

echo " "                                                                                   											>> $HOSTNAME.$DATE.linux.result.txt 2>&1		
echo "⑤ Exim 프로세스 확인"																												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep exim | grep -v grep | wc -l` -gt 0 ]
then
	flag1="Interview"
	ps -ef | grep exim | grep -v grep																								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "																														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "⑥ Exim 버전 확인"																											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "※ 최소 4.49.2 이상 버전 사용(코드 실행 취약점 : CVE-202-28025)"																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"											>> $HOSTNAME.$DATE.linux.result.txt 2>&1	
	exim -bV | grep version | awk -F" " '{print $2 $3}'																				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "☞ Exim Service Disable"																									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disable"
fi

echo " "																															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "[참고]"                                                                              	   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "/etc/services 파일에서 포트 확인"                                                        											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp"                    										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "서비스 포트 활성화 여부 확인"                                                        	   												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"																				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "☞ Sendmail Service Disable"																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "서비스 포트 확인 불가"																											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result=$flag1                                                                            										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-007 END"                                                                             										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                     										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 

#24년 개선 사항 : Postfix, Exim 추가
sleep 1
echo "SRV-008 START"																												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "###########################################################################################"									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#############           SMTP 서비스의 DoS 방지 기능 미설정       				   ##############"
echo "#############           SMTP 서비스의 DoS 방지 기능 미설정       				   ##############"										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "###########################################################################################"									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: SMTP 서비스의 DoS 방지 관련 설정이 적용된 경우 양호"																				>> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "■ 현황"																															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① sendmail 프로세스 확인"																											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep sendmail | grep -v grep | wc -l` -gt 0 ]
then
    echo "Sendmail Service Enable"                                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Interview"
	ps -ef | grep sendmail | grep -v grep																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "																														>> $HOSTNAME.$DATE.linux.result.txt 2>&1

	echo "② /etc/mail/sendmail.cf 파일 확인"																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/mail/sendmail.cf ]
	then
		if [ `cat /etc/mail/sendmail.cf | egrep "MaxDaemonChildren|ConnectionRateThrottle|MinFreeBlocks|MaxHeadersLength|MaxMessageSize" | grep -v "#" | wc -l` -eq 5 ]
		then
			cat /etc/mail/sendmail.cf | egrep "MaxDaemonChildren|ConnectionRateThrottle|MinFreeBlocks|MaxHeadersLength|MaxMessageSize" | grep -v "#"									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			flag2="Interview"
		else
			cat /etc/mail/sendmail.cf | egrep "MaxDaemonChildren|ConnectionRateThrottle|MinFreeBlocks|MaxHeadersLength|MaxMessageSize"	| grep -v "#"									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo "☞ 파라미터 설정이 적용되어 있지 않음"																						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			flag2="X"
		fi
	else
		echo "☞ /etc/mail/sendmail.cf 파일이 존재하지 않음"																				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi

	echo " "																														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "③ /etc/sendmail.cf 파일 확인"																								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/sendmail.cf ]
	then
		if [ `cat /etc/sendmail.cf | egrep "MaxDaemonChildren|ConnectionRateThrottle|MinFreeBlocks|MaxHeadersLength|MaxMessageSize" | grep -v "#" | wc -l` -eq 5 ]
		then
			cat /etc/sendmail.cf | egrep "MaxDaemonChildren|ConnectionRateThrottle|MinFreeBlocks|MaxHeadersLength|MaxMessageSize" | grep -v "#"											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			flag2="Interview"
		else
			cat /etc/sendmail.cf | egrep "MaxDaemonChildren|ConnectionRateThrottle|MinFreeBlocks|MaxHeadersLength|MaxMessageSize"														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo "☞ 파라미터 설정이 안되어 있음"																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			flag2="X"
		fi
	else
		echo "☞ /etc/sendmail.cf 파일이 존재하지 않음"																					>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "☞ Sendmail Service Disable"																								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag3="Disabled"
fi

echo " "							 																								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "④ postfix 프로세스 확인"																											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "----------------------------------------------------------------------------------"											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep postfix | grep -v grep | wc -l` -gt 0 ]
then
	flag1="Interview"
	ps -ef | grep postfix | grep -v grep																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "⑤ /etc/postfix/main.cf 파일 확인"																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/postfix/main.cf ]
	then
		if [ `cat /etc/postfix/main.cf | egrep "message_size_limit|header_size_limit|default_process_limit|local_destination_concurrency_limit|smtpd_recipient_limit" | grep -v "#" | wc -l` -eq 5 ]
		then
			cat /etc/postfix/main.cf | egrep "message_size_limit|header_size_limit|default_process_limit|local_destination_concurrency_limit|smtpd_recipient_limit" | grep -v "#" 							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			flag2="Interview"
		else
			cat /etc/postfix/main.cf | egrep "message_size_limit|header_size_limit|default_process_limit|local_destination_concurrency_limit|smtpd_recipient_limit" | grep -v "#" 							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo "☞ 파라미터 설정이 안되어 있음"																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			flag2="X"
		fi
	else
		echo "☞ /etc/postfix/main.cf 파일이 존재하지 않음" 																				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "☞ Postfix Service Disable"																								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag3="Disabled"
fi

echo " "                                                                                   											>> $HOSTNAME.$DATE.linux.result.txt 2>&1	
echo "⑥ Exim 프로세스 확인"																												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "----------------------------------------------------------------------------------"											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep exim | grep -v grep | wc -l` -gt 0 ]
then
	flag1="Interview"
	ps -ef | grep exim | grep -v grep																								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1	
	echo "⑦ /etc/exim*/exim*.conf.template 파일 확인"																					>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/exim*/exim*.conf.template ]
	then
		if [ `cat /etc/exim*/exim*.conf.template | egrep "message_size_limit|header_maxsize|queue_run_max|recipients_max" | grep -v "#" | wc -l` -eq 4 ]
		then
			cat /etc/exim*/exim*.conf.template | egrep "message_size_limit|header_maxsize|queue_run_max|recipients_max" | grep -v "#"																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			flag2="Interview"
		else
			cat /etc/exim*/exim*.conf.template | egrep "message_size_limit|header_maxsize|queue_run_max|recipients_max" | grep -v "#"																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo "파라미터 설정이 안되어 있음"																								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		fi
	else
		echo "☞ /etc/exim*/exim*.conf.template 파일이 존재하지 않음"																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
	echo " "                                                                                   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1	
	echo "⑧ /etc/exim*/exim*.conf 파일 확인"																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/exim*/exim*.conf ]
	then
		if [ `cat /etc/exim*/exim*.conf | egrep "message_size_limit|header_maxsize|queue_run_max|recipients_max" | grep -v "#" | wc -l` -eq 4 ]
		then
			cat /etc/exim*/exim*.conf | egrep "message_size_limit|header_maxsize|queue_run_max|recipients_max" | grep -v "#"																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			flag2="Interview"
		else
			cat /etc/exim*/exim*.conf | egrep "message_size_limit|header_maxsize|queue_run_max|recipients_max" | grep -v "#"																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo "파라미터 설정이 안되어 있음"																								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		fi
	else
		echo "👉 /etc/exim*/exim*.conf 파일이 존재하지 않음"																				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
	echo " "                                                                                   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1	
	echo "⑨ /etc/exim*/conf.d/*.conf 파일 확인"																						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/exim*/conf.d/*.conf ]
	then
		if [ `cat /etc/exim*/conf.d/*.conf | egrep "message_size_limit|header_maxsize|queue_run_max|recipients_max" | grep -v "#" | wc -l` -eq 4 ]
		then
			cat /etc/exim*/conf.d/*.conf | egrep "message_size_limit|header_maxsize|queue_run_max|recipients_max" | grep -v "#"																	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			flag2="Interview"
		else
			cat /etc/exim*/conf.d/*.conf | egrep "message_size_limit|header_maxsize|queue_run_max|recipients_max" | grep -v "#"																	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo "파라미터 설정이 안되어 있음"																								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		fi
	else
		echo "👉 /etc/exim*/conf.d/*.conf 파일이 존재하지 않음"																			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "☞ Exim Service Disable"																									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag3="Disabled"
fi

echo " "																															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "[참고]"                                                 									                             	    >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                     									                    >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "/etc/services 파일에서 포트 확인"																									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp"															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "																															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "서비스 포트 활성화 여부 확인"																											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"																				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "☞ Sendmail Service Disable"																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "서비스 포트 확인 불가"																											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result=$flag1":"$flag2":"$flag3														   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-008 END"                                                                             										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 

#24년 개선 사항 : Postfix, Exim 추가
sleep 1
echo "SRV-009 START"                                                                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "###############################################################################################" 								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#####################         SMTP 서비스 스팸 메일 릴레이 제한 미설정         #####################"
echo "#####################         SMTP 서비스 스팸 메일 릴레이 제한 미설정         #####################" 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "###############################################################################################"								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: SMTP 서비스를 사용하지 않거나 릴레이 제한이 설정되어 있을 경우 양호"																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■		: (R$* $#error $@ 5.7.1 $: \"550 Relaying denied\" 해당 설정에 주석이 제거되어 있으면 양호)"											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■		: (sendmail 버전 8.9 이상인 경우 디폴트로 스팸 메일 릴레이 방지 설정이 되어 있으므로 양호)"													>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"																															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① sendmail 프로세스 확인"																											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep sendmail | grep -v grep | wc -l` -gt 0 ]
then
	ps -ef | grep sendmail | grep -v grep													   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Enabled"
	echo " "                                                                                   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "② /etc/mail/sendmail.cf 파일의 옵션 확인"                                           											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"      										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/mail/sendmail.cf ]
	then
		cat /etc/mail/sendmail.cf | grep "R$\*" | grep "Relaying denied"                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2=`cat /etc/mail/sendmail.cf | grep "R$\*" | grep "Relaying denied" | grep -v ^# | wc -l`
	else
		echo "/etc/mail/sendmail.cf 파일이 없습니다."                                          											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2="Null"
	fi
	echo " "                                                                                   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "③ sendmail 버전확인"                                                                											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/mail/sendmail.cf ]
	then
		grep -v '^ *#' /etc/mail/sendmail.cf | grep DZ																				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "/etc/mail/sendmail.cf 파일이 없습니다."																					>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "☞ Sendmail Service Disable"																								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi

echo " "							 																								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "④ postfix 프로세스 확인"																											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep postfix | grep -v grep | wc -l` -gt 0 ]
then
	flag1="Interview"
	ps -ef | grep postfix | grep -v grep																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "         																												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "⑤ postfix 설정 파일 확인"																										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ `find / -name "master.cf" -type f 2>/dev/null | wc -l` -gt 0 ]
	then
		flag2="Interview"
		post_file=`find / -name "master.cf" -type f 2>/dev/null`
		for dir in $post_file
		do
			if [ -f $dir ]
			then
				if [ `cat $dir | egrep -i "smtpd_recipient_restrictions|smtpd_relay_restrictions" | grep -v "^#" | wc -l` -gt 0 ]
				then
					cat $dir | egrep -i "smtpd_recipient_restrictions|smtpd_relay_restrictions" | grep -v "^#"						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				else
					echo "smtpd_recipient_restrictions 또는 smtpd_relay_restrictions 설정값이 없습니다."									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				fi
			fi
		done
	else
		echo "master.cf 파일이 존재하지 않습니다."																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2="Null"
	fi
	
else
	echo "postfix Service Disable"																									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi

echo " "							 																								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "⑥ Exim 프로세스 확인"																												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep exim | grep -v grep | wc -l` -gt 0 ]
then
	flag1="Interview"
	ps -ef | grep sendmail | grep -v grep																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "         																												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "⑦ Exim 설정 파일 확인"																										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ `find / -name exim*.conf -type f 2>/dev/null | wc -l` -gt 0 ]
	then
		flag2="Interview"
		exim_file=`find / -name exim*.conf -type f 2>/dev/null`
		for exim_dir in $exim_file
		do
			if [ -f $exim_dir ]
			then
				if [ `cat $exim_dir | grep acl_smtp_rcpt | grep accept | grep -v "^#" | wc -l` -gt 0 ]
				then
					cat $exim_dir | grep acl_smtp_rcpt | grep accept | grep -v "^#"													>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				else
					echo "acl_smtp_rcpt 정책중 accept 로 허용된 네트워크가 존재하지 않습니다."													>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				fi
			fi
		done		
	else
		echo "exim.conf 파일이 존재하지 않습니다."																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2="Null"
	fi
else
	echo "Exim Service Disable"																										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi

echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "[참고]"                                                                              	  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                      										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "/etc/services 파일에서 포트 확인"                                                    	   											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp"                    										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                      										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "서비스 포트 활성화 여부 확인"                                                       	   												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"																				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "☞ Sendmail Service Disable"																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "서비스 포트 확인 불가"																											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-009 END"                                                                             										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 

#24년 개선 사항 : Postfix, Exim 추가
sleep 1
echo "SRV-010 START"                                                                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "##############################################################################################" 								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "################           SMTP 서비스의 메일 queue 처리 권한 설정 미흡           #################"
echo "################           SMTP 서비스의 메일 queue 처리 권한 설정 미흡           #################" 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "##############################################################################################" 								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: SMTP 서비스를 사용하지 않거나 SMTP 서비스의 메일 queue 처리 권한을 업무 관리자에게만 부여되도록 설정한 경우 양호"           						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : (restrictqrun 옵션이 설정되어 있을 경우 양호)"                                 												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : postsuper 실행 파일에 others 실행 권한이 없는 경우 양호"                                 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : exim 실행 파일에 others 실행 권한이 없는 경우 양호"                                 											>> $HOSTNAME.$DATE.linux.result.txt 2>&1

echo "■ 현황"                                                                                  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① sendmail 프로세스 확인"                                    					       												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep sendmail | grep -v grep | wc -l` -gt 0 ]
then
	ps -ef | grep sendmail | grep -v grep													   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Enabled"
	echo " "                                                                                   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	
	echo " "                                                                                   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "② /etc/mail/sendmail.cf 파일의 옵션 확인"                                           											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"      										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/mail/sendmail.cf ]
	then
		grep -v '^ *#' /etc/mail/sendmail.cf | egrep -i "PrivacyOptions|restrictqrun"                             										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	    flag2=`grep -v '^ *#' /etc/mail/sendmail.cf | grep PrivacyOptions | grep restrictqrun | wc -l`
	else
		echo "/etc/mail/sendmail.cf 파일이 없습니다."                                          											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2="Null"
	fi
	echo " "                                                                                   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "☞ Sendmail Service Disable"        																						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi


echo " "                                                                                   											>> $HOSTNAME.$DATE.linux.result.txt 2>&1	
echo "③ postfix 프로세스 확인"                                    					       												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep postfix | grep -v grep | wc -l` -gt 0 ]
then
	echo "Postfix Service Enabled"		       																						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Enabled"
	echo " " 		       																											>> $HOSTNAME.$DATE.linux.result.txt 2>&1

	echo "④ postsuper 권한 확인"		      																						 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"         									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ `which postsuper | grep -v no | wc -l` -gt 0 ]
	then
		postcommand=`which postsuper`;
		ls -al $postcommand		       																								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "postsuper 파일이 존재하지 않습니다."																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
	echo " "																														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "☞ Postfix Service Disable"																								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi

echo " "                                                                                   											>> $HOSTNAME.$DATE.linux.result.txt 2>&1	
echo "⑤ Exim 프로세스 확인"																												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep exim | grep -v grep | wc -l` -gt 0 ]
then
	echo "Exim Service Enabled"																										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Enabled"
	echo " "																														>> $HOSTNAME.$DATE.linux.result.txt 2>&1

	echo "⑥ exim 실행 파일 권한 확인"																										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ `which exim | grep -v no | wc -l` -gt 0 ]
	then
		eximcommand=`which exim`;
		ls -al $eximcommand																											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "exim 파일이 존재하지 않습니다."																								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
	echo " "																														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "☞ Exim Service Disable"																									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi

echo " "																															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "[참고]"                                                                              	   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "/etc/services 파일에서 포트 확인"                                                    	   											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp"                    										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "서비스 포트 활성화 여부 확인"                                                        	   												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"         										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"                                          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "☞ Sendmail Service Disable"                                                     										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "서비스 포트 확인 불가" 				                                               												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result=$flag1":"$flag2                                                                                      										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-010 END"                                                                             										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 

sleep 1
echo "SRV-011 START"                                                                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#############			    시스템 관리자 계정의 FTP 사용 제한 미비			    #############"
echo "#############			    시스템 관리자 계정의 FTP 사용 제한 미비			    #############" 											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: ftp 를 사용하지 않거나, ftp 사용시 ftpusers 파일에 root가 있을 경우 양호"        														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : [FTP 종류별 적용되는 파일]"                                                    											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : (1)ftpd: /etc/ftpusers 또는 /etc/ftpd/ftpusers"                                										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : (2)proftpd: /etc/ftpusers, /etc/ftpd/ftpusers 또는 /etc/proftpd/ftpusers"                             										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : (3)vsftpd: /etc/vsftpd/ftpusers, /etc/vsftpd/user_list (또는 /etc/vsftpd.ftpusers, /etc/vsftpd.user_list)" 			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① /etc/services 파일에서 포트 확인"                                                     											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service파일:" $1 " " $2}' | grep "tcp" | wc -l` -gt 0 ]
then
	cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service파일:" $1 " " $2}' | grep "tcp"  									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "(1)/etc/service파일: 포트 설정 X (Default 21번 포트)"                                      										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
if [ -s vsftpd.txt ]
then
	if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP 포트: " $1 "  " $2}' | wc -l` -gt 0 ]
	then
		cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP 포트: " $1 "  " $2}' 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "(2)VsFTP 포트: 포트 설정 X (Default 21번 포트 사용중)"                                 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "(2)VsFTP 포트: VsFTP가 설치되어 있지 않습니다."                                            										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
if [ -s proftpd.txt ]
then
	if [ `cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP 포트: " $1 "  " $2}' | wc -l` -gt 0 ]
	then
		cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP 포트: " $1 "  " $2}'      									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "(3)ProFTP 포트: 포트 설정 X (/etc/service 파일에 설정된 포트를 사용중)"                											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "(3)ProFTP 포트: ProFTP가 설치되어 있지 않습니다."                                    												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "② 서비스 포트 활성화 여부 확인"                                                         												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"         								 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
################# /etc/services 파일에서 포트 확인 #################
if [ `cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN"                      										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                               										> ftpenable.txt
	fi
else
	netstat -nat | grep ":21 " | grep -i "^tcp" | grep -i "LISTEN"                             										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                   										> ftpenable.txt
fi
################# vsftpd 에서 포트 확인 ############################
if [ -s vsftpd.txt ]
then
	if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}' | wc -l` -eq 0 ]
	then
		port=21
	else
		port=`cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}'`
	fi
	if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN"                      										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                               										> ftpenable.txt
	fi
fi
################# proftpd 에서 포트 확인 ###########################
if [ -s proftpd.txt ]
then
	port=`cat $profile | grep "Port" | grep -v "^#" | awk '{print $2}'`
	if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN"                      										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                               										> ftpenable.txt
	fi
fi

if [ -f ftpenable.txt ]
then
	rm -rf ftpenable.txt
	flag1="Enabled"

	echo " "                                                                                    									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "③ ftpusers 파일 설정 확인"                                                           											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"       									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "       																													>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	ServiceDIR="/etc/ftpusers /etc/ftpd/ftpusers /etc/vsftpd/ftpusers /etc/vsftpd.ftpusers /etc/vsftpd/user_list /etc/vsftpd.user_list /etc/proftpd/ftpusers"
	ServiceDIRPath=`echo "$ServiceDIR"`
	for file in $ServiceDIRPath
	do
		if [ -f $file ]
		then
			if [ `cat $file | grep "root" | grep -v "^#" | wc -l` -gt 0 ]
			then
				echo "● $file 파일내용: `cat $file | grep "root" | grep -v "^#"` 계정이 등록되어 있음."  			>> ftpusers.txt
				echo "check"                                                                             >> check.txt
			else
				echo "● $file 파일내용: root 계정이 등록되어 있지 않음."                                 				>> ftpusers.txt
				echo "check"                                                                             >> check.txt
			fi
		else
			continue
		fi
	done
	
	if [ -f check.txt ]
	then
		cat ftpusers.txt | grep -v "^ *$"                                                        									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2="Interviw"
	else
		echo "ftpusers 파일을 찾을 수 없습니다. (FTP 서비스 동작 시 취약)"                       												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2="Null"
	fi

else
	echo "☞ FTP Service Disable"                                                                									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi

echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                										>> $HOSTNAME.$DATE.linux.result.txt 2>&1	
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-011 END"                                                                             										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
rm -rf check.txt
rm -rf ftpusers.txt
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 

sleep 1
echo "SRV-012 START"                                                                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "################           .netrc 파일 내 중요 정보 노출     			        #################"
echo "################           .netrc 파일 내 중요 정보 노출            			#################" 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준 : .netrc 파일 내부에 아이디, 패스워드 등 민감한 정보가 없을 경우 양호"  																	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u | grep -v "#" | grep -v "/tmp" | grep -v "uucppublic" | uniq`
for dir in $HOMEDIRS
do
	if [ -d $dir ]
	then
		hfiles=`ls -alL $dir | awk -F" " '{print $9}' | grep ".netrc"`
		if [ `ls -alL $dir | awk -F" " '{print $9}' | grep ".netrc" | wc -l` -gt 0 ]
		then
		for hfile in $hfiles
		do
			if [ -f $dir/$hfile ]
			then
				echo " "                                                                             								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				echo "☞ $dir 홈디렉터리의 .netrc 파일 권한 및 설정 값 확인"            			   											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				ls -aldL $dir/$hfile                                                                 								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				echo "----------------------------------------"                                      								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				cat $dir/$hfile                                                                      								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				echo " "                                                                             								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			else
				echo "☞ $dir/$hfile 파일이 존재하지 않음"                                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			fi
		done                                                                                       
		else
			echo "☞ $dir 홈디렉터리에 .netrc 파일이 존재하지 않음"                                  											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		fi
	else
		echo "☞ $dir 홈디렉터리가 존재하지 않음"                                                  											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
done
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result="Interview"                                                                              								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                      										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-012 END"                                                                             										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 


sleep 1
echo "SRV-013 START"                                                                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#####################           Anonymous 계정의 FTP 서비스 접속 제한 미비          #############"
echo "#####################           Anonymous 계정의 FTP 서비스 접속 제한 미비          #############" 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: Anonymous FTP (익명 ftp)를 비활성화 시켰을 경우 양호"                            												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : (1)ftpd를 사용할 경우: /etc/passwd 파일내 FTP 또는 anonymous 계정이 존재하지 않으면 양호" 											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : (2)proftpd를 사용할 경우: /etc/passwd 파일내 FTP 계정이 존재하지 않으면 양호"  													>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : (3)vsftpd를 사용할 경우: vsftpd.conf 파일에서 anonymous_enable=NO 설정이면 양호" 												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① /etc/services 파일에서 포트 확인"                                                     											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service파일:" $1 " " $2}' | grep "tcp" | wc -l` -gt 0 ]
then
	cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service파일:" $1 " " $2}' | grep "tcp" 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "(1)/etc/service파일: 포트 설정 X (Default 21번 포트)"                                     										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
if [ -s proftpd.txt ]
then
	if [ `cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP 포트: " $1 "  " $2}' | wc -l` -gt 0 ]
	then
		cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP 포트: " $1 "  " $2}'     									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "(2)ProFTP 포트: 포트 설정 X (/etc/service 파일에 설정된 포트를 사용중)"               											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "(2)ProFTP 포트: ProFTP가 설치되어 있지 않습니다."                                         											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
if [ -s vsftpd.txt ]
then
	if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP 포트: " $1 "  " $2}' | wc -l` -gt 0 ]
	then
		cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP 포트: " $1 "  " $2}' 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "(3)VsFTP 포트: 포트 설정 X (Default 21번 포트 사용중)"                                 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "(3)VsFTP 포트: VsFTP가 설치되어 있지 않습니다."                                            										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                      								 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "② 서비스 포트 활성화 여부 확인"                                                         												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"         								 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
################# /etc/services 파일에서 포트 확인 #################
if [ `cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN"                         									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                                  									> ftpenable.txt
	fi
else
	netstat -nat | grep ":21 " | grep -i "^tcp" | grep -i "LISTEN"                              									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                    									> ftpenable.txt
fi
################# vsftpd 에서 포트 확인 ############################
if [ -s vsftpd.txt ]
then
	if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}' | wc -l` -eq 0 ]
	then
		port=21
	else
		port=`cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}'`
	fi
	if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN"                         									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                                  									>> ftpenable.txt
	fi
fi
################# proftpd 에서 포트 확인 ###########################
if [ -s proftpd.txt ]
then
	port=`cat $profile | grep "Port" | grep -v "^#" | awk '{print $2}'`
	if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN"                        									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                                  									>> ftpenable.txt
	fi
fi

if [ -f ftpenable.txt ]
then
	rm -rf ftpenable.txt
	flag1="Enabled"

	echo " "                                                                                       									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "③ Anonymous FTP 설정 확인"                                                              										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"          									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -s vsftpd.txt ]
	then
		cat $vsfile | grep -i "anonymous_enable" | awk '{print "● VsFTP 설정: " $0}'                 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                                     								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2=`cat $vsfile | grep -i "anonymous_enable" | grep -i "YES" | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
	else
		if [ `cat /etc/passwd | egrep "^ftp:|^anonymous:" | wc -l` -gt 0 ]
		then
			echo "● ProFTP, 기본FTP 설정:"                                                               								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			cat /etc/passwd | egrep "^ftp:|^anonymous:"                                                  							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo " "                                                                                     							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			flag2=`cat /etc/passwd | egrep "^ftp:|^anonymous:" | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'` 
			echo " "                                                                                     							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		else
			echo "● ProFTP, 기본FTP 설정: /etc/passwd 파일에 ftp 또는 anonymous 계정이 없습니다."        										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo " "                                                                                     							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			flag2=`cat /etc/passwd | egrep "^ftp:|^anonymous:" | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
		fi	
	fi
else
	echo "☞ FTP Service Disable"                                                                									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                										>> $HOSTNAME.$DATE.linux.result.txt 2>&1

echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-013 END"                                                                             										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 


sleep 1
echo "SRV-014 START"                                                                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "###########################           NFS 접근통제 미비           #########################"
echo "###########################           NFS 접근통제 미비           #########################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준1: NFS 서버 데몬이 동작하지 않으면 양호"                                           												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준2: NFS 서버 데몬이 동작하는 경우 /etc/exports 파일에 everyone 공유 설정이 없으면 양호" 													>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준3: NFS 서버 데몬이 동작하는 경우 설정 파일의 접근권한이 소유자가 root가 아니고 권한이 644보다 높게 부여된 경우 양호" 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① NFS Server Daemon(nfsd)확인"                                                          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep "nfsd" | egrep -v "statdaemon|automountd|emi" | grep -v "grep" | wc -l` -gt 0 ] 
then
	ps -ef | grep "nfsd" | egrep -v "statdaemon|automountd|emi" | grep -v "grep"                									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag="Interview"
else
	echo "☞ NFS Service Disable"                                                               									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag="Disabled"
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "② /etc/exports 파일 설정"                                                               											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/exports ]
then
	if [ `cat /etc/exports | grep -v "^#" | grep -v "^ *$" | wc -l` -gt 0 ]
	then
		cat /etc/exports | grep -v "^#" | grep -v "^ *$"                                           									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "설정 내용이 없습니다."                                                               										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "/etc/exports 파일이 없습니다."                                                         										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "③ /etc/exports 설정 파일 접근권한"																									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/exports ]
then
	ls -aldL /etc/exports																											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
    echo "/etc/exports 파일이 없습니다."																									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo Result=$flag					                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1

echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-014 END"                                                                             										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 

sleep 1
echo "SRV-015 START"                                                                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "########################           불필요한 NFS 서비스 실행            #####################"
echo "########################           불필요한 NFS 서비스 실행            #####################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: 불필요한 NFS 서비스 관련 데몬이 제거되어 있는 경우 양호"                         														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① NFS Server Daemon(nfsd)확인"                                                          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep "nfsd" | egrep -v "statdaemon|automountd|emi" | grep -v "grep" | wc -l` -gt 0 ] 
then
	ps -ef | grep "nfsd" | egrep -v "statdaemon|automountd|emi" | grep -v "grep"                									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Enabled_Server"
else
	echo "☞ NFS Service Disable"                                                               									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disabled_Server"
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "② NFS Client Daemon(statd,lockd)확인"                                                   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | egrep "statd|lockd" | egrep -v "grep|emi|statdaemon|dsvclockd|kblockd" | wc -l` -gt 0 ] 
then
    ps -ef | egrep "statd|lockd" | egrep -v "grep|emi|statdaemon|dsvclockd|kblockd"            										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
    flag2="Enabled_Client"
else
	echo "☞ NFS Client(statd,lockd) Disable"                                                  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
    flag2="Disabled_Client"
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result=$flag1":"$flag2                                                                											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "[참고] RPC Info "                                                                          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
rpcinfo -p                                                                                     										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-015 END"                                                                             										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 

sleep 1
echo "SRV-016 START"                                                                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "##################           불필요한 RPC서비스 활성화          				#################"
echo "##################           불필요한 RPC서비스 활성화            				#################" 																>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 																	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: 불필요한 rpc 관련 서비스가 존재하지 않으면 양호"                                 																				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "(rpc.cmsd|rpc.ttdbserverd|sadmind|rusersd|walld|sprayd|rstatd|rpc.nisd|rpc.pcnfsd|rpc.statd|rpc.ypupdated|rpc.rquotad|kcms_server|cachefsd|rexd)" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  																	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       																	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
SERVICE_INETD="rpc.cmsd|rpc.ttdbserverd|sadmind|rusersd|walld|sprayd|rstatd|rpc.nisd|rpc.pcnfsd|rpc.statd|rpc.ypupdated|rpc.rquotad|kcms_server|cachefsd|rexd"

echo "☞ 불필요한 RPC 서비스 동작 확인"                                                        												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
ps -ef | egrep $SERVICE_INETD | grep -v grep												   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "결과 값이 존재하지 않으면 양호."                                         			   												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo Result=`ps -ef | egrep $SERVICE_INETD | grep -v grep | wc -l`                         										>> $HOSTNAME.$DATE.linux.result.txt 2>&1

echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-016 END"                                                                             										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 

sleep 1
echo "SRV-021 START"                                                                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#################           FTP 서비스 접근 제어 설정 미비            ################"
echo "#################           FTP 서비스 접근 제어 설정 미비         	################" 												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: FTP 접근제어 설정 되어 있을 경우 양호"                       		   															>> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "■ 현황"                                                                                  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "▶Proftp 사용"                                              																	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------"                                  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/proftpd.conf ]
	then
	   cat /etc/proftpd.conf |grep "Allow"								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	   cat /etc/proftpd.conf |grep "Deny"								>> $HOSTNAME.$DATE.linux.result.txt 2>&1	

	else
		echo "/etc/proftpd.conf 파일이 없습니다."                                               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi

echo " "																															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "▶vsftp 사용"                                              																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------"                                  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① /etc/hosts.allow 파일 설정"                                                           											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/hosts.allow ]
then
	if [ ! `cat /etc/hosts.allow | grep -v "#" | grep -ve '^ *$' | wc -l` -eq 0 ]
	then
		cat /etc/hosts.allow | grep -v "#" | grep -ve '^ *$'                                   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "설정 내용이 없습니다."                                                           											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "/etc/hosts.allow 파일이 없습니다."                                                   											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "② /etc/hosts.deny 파일 설정"                                                            											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/hosts.deny ]
then
	if [ ! `cat /etc/hosts.deny | grep -v "#" | grep -ve '^ *$' | wc -l` -eq 0 ]
	then
		cat /etc/hosts.deny | grep -v "#" | grep -ve '^ *$'                                    										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "설정 내용이 없습니다."                                                           											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "/etc/hosts.deny 파일이 없습니다."                                                     	 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi

echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result="Interview"          	                                                                   								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-021 END"                                                                             										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "       


sleep 1
echo "SRV-022 START"                                                                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#################           계정의 비밀번호 미 설정, 빈 암호 사용 관리 미흡            ################"
echo "#################           계정의 비밀번호 미 설정, 빈 암호 사용 관리 미흡         	################" 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: 계정들의 비밀번호가 모두 설정되어 있을 경우 양호"                       		   														>> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "		: 패스워드 값이(/etc/shadow 2번째 필드값) !! 일 경우 패스워드 미설정 "                       				   							>> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "■ 현황"                                                                                  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "/etc/shadow 활성화된 계정 설정 (Login name, 패스워드 값)"                                              								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------"                                  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
accounts1=`cat /etc/passwd | egrep -v "/bin/false|/sbin/nologin" | awk -F: '{print $1}'`
for accounts in $accounts1
	do
	cat /etc/shadow | grep -w $accounts																								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
done
#cat /etc/shadow | awk -F: '{print $1"\t\t"$2"\t\t"$7}'  											   								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result="Interview"          	                                                                   								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-022 END"                                                                             										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1

sleep 1
echo "SRV-025 START"                                                                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "##############           취약한 host.equiv 또는 .rhosts 설정 존재             ##############"
echo "##############           취약한 host.equiv 또는 .rhosts 설정 존재             ##############" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: r-commands 서비스를 사용하지 않으면 양호"                                        												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : r-commands 서비스를 사용하는 경우 HOME/.rhosts, hosts.equiv 설정확인"          												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : (1) .rhosts 파일의 소유자가 해당 계정의 소유자이고, 퍼미션 600, 내용에 + 가 설정되어 있지 않으면 양호" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : (2) /etc/hosts.equiv 파일의 소유자가 root 이고, 퍼미션 600, 내용에 + 가 설정되어 있지 않으면 양호"									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① /etc/services 파일에서 포트 확인"                                                     											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="login" {print $1 "   " $2}' | grep "tcp"                   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="shell" {print $1 "   " $2}' | grep "tcp"                   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="exec" {print $1 "    " $2}' | grep "tcp"                   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "② 서비스 포트 활성화 여부 확인"                                                         												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="login" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="login" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	netstat -na | grep :$port | grep -i "^tcp"                                                  > SRV-025.txt
fi

if [ `cat /etc/services | awk -F" " '$1=="shell" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="shell" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	netstat -na | grep :$port | grep -i "^tcp"                                                  >> SRV-025.txt
fi

if [ `cat /etc/services | awk -F" " '$1=="exec" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="exec" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	netstat -na | grep :$port | grep -i "^tcp"                                                  >> SRV-025.txt
fi

if [ -s SRV-025.txt ]
then
	cat SRV-025.txt | grep -v '^ *$'                                                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag="Interview"
else
	echo "☞ r-command Service Disable"                                                        										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag="Disabled"
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "③ /etc/hosts.equiv 파일 설정"                                                           											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/hosts.equiv ]
	then
		echo "(1) Permission: (`ls -al /etc/hosts.equiv`)"                                     										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "(2) 설정 내용:"                                                                  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "----------------------------------------"                                        										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		if [ `cat /etc/hosts.equiv | grep -v "#" | grep -v '^ *$' | wc -l` -gt 0 ]
		then
			cat /etc/hosts.equiv | grep -v "#" | grep -v '^ *$'                                										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		else
			echo "설정 내용이 없습니다."                                                       											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		fi
	else
		echo "/etc/hosts.equiv 파일이 없습니다."                                               											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "④ 사용자 home directory .rhosts 설정 내용"                                              											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u`
FILES="/.rhosts"

for dir in $HOMEDIRS
do
	for file in $FILES
	do
		if [ -f $dir$file ]
		then
			echo " "                                                                           > rhosts.txt
			echo "# $dir$file 파일 설정:"                                                      										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo "(1) Permission: (`ls -al $dir$file`)"                                        										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo "(2) 설정 내용:"                                                             		 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo "----------------------------------------"                                    										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			if [ `cat $dir$file | grep -v "#" | grep -v '^ *$' | wc -l` -gt 0 ]
			then
				cat $dir$file | grep -v "#" | grep -v '^ *$'                                   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			else
				echo "설정 내용이 없습니다."                                                   											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			fi
		echo " "                                                                               										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		fi
	done
done
if [ ! -f rhosts.txt ]
then
	echo ".rhosts 파일이 없습니다."                                                            											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo Result=$flag                                                                          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1

echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-025 END"                                                                             										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
rm -rf rhosts.txt
rm -rf SRV-025.txt
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 

sleep 1
echo "SRV-026 START"                                                                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "####################           root 계정 원격 접속 제한            ####################"
echo "####################           root 계정 원격 접속 제한            ####################" 											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준1: [telnet] /etc/securetty 파일에 pts/* 설정이 있으면 무조건 취약"                 												>> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "■ 기준2: [telnet] /etc/securetty 파일에 pts/* 설정이 없거나 주석처리가 되어 있고,"       													>> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "■        : /etc/pam.d/login에서 auth required /lib/security/pam_securetty.so 라인에 주석(#)이 없으면 양호" 							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: [SSH] /etc/ssh/sshd_config 파일에 PermitRootLogin no로 설정되어 있을 경우 양호"  												>> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "■ 현황"                                                                                  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① [telnet] /etc/services 파일에서 포트 확인"                                            											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="telnet" {print $1 "   " $2}' | grep "tcp"                  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "② [telnet] 서비스 포트 활성화 여부 확인"                                                												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="telnet" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="telnet" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"                                          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag1="Interview"
	else
		echo "☞ Telnet Service Disable"                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag1="Disabled"
	fi
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "③ [telnet] /etc/securetty 파일 설정"                                                    											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `cat /etc/securetty | grep "pts" | wc -l` -gt 0 ]
then
	cat /etc/securetty | grep "pts"                                                            										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "/etc/securetty 파일에 pts/0~pts/x 설정이 없습니다."                                  											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "④ [telnet] /etc/pam.d/login 파일 설정"                                                  											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/pam.d/login | grep "pam_securetty.so"                                                 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1

echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "⑤ [SSH] 서비스 구동 확인"                                                               											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "--------------------------------------------------------------------------------"        										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep sshd | grep -v "grep" | wc -l` -eq 0 ]
then
	echo "☞ SSH Service Disable"                                                                									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag2="Disabled"
else
	ps -ef | grep sshd | grep -v grep                                                            									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag2="Enabled"
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "⑥ [SSH] /opt/ssh/etc/sshd_config 파일 확인 "                                            											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "--------------------------------------------------------------------------------"        										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `cat /etc/ssh/sshd_config | egrep -i 'PermitRootLogin' | wc -l` -eq 0 ]
then
	echo "☞ sshd_config 파일 설정이 안되어 있음 "                                               											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag3="Fail"
else
	cat /etc/ssh/sshd_config | egrep -i 'PermitRootLogin'                                        									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag3="Interview"
fi	
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result=$flag1":"$flag2":"$flag3                                                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-026 END"                                                                             										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1

sleep 1
echo "SRV-027 START"                                                                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "######################           서비스 접근 IP 및 포트 제한 미비             ###################"
echo "######################           서비스 접근 IP 및 포트 제한 미비             ###################" 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준 : 방화벽, 3rd-party 제품 등을 활용하여 접근제어하고 있을 경우 양호 혹은 tcp-wrapper 사용할 경우 아래 기준 만족할 경우 양호"     					>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■    : /etc/hosts.deny 파일에 All Deny(ALL:ALL) 설정이 등록되어 있고,"                 												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■    : /etc/hosts.allow 파일에 접근 허용 IP가 등록되어 있으면 양호"                    													>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① /etc/hosts.allow 파일 설정"                                                           											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/hosts.allow ]
then
	if [ ! `cat /etc/hosts.allow | grep -v "#" | grep -ve '^ *$' | wc -l` -eq 0 ]
	then
		cat /etc/hosts.allow | grep -v "#" | grep -ve '^ *$'                                   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "설정 내용이 없습니다."                                                           											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "/etc/hosts.allow 파일이 없습니다."                                                   											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "② /etc/hosts.deny 파일 설정"                                                           	 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/hosts.deny ]
then
	if [ ! `cat /etc/hosts.deny | grep -v "#" | grep -ve '^ *$' | wc -l` -eq 0 ]
	then
		cat /etc/hosts.deny | grep -v "#" | grep -ve '^ *$'                                    										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "설정 내용이 없습니다."                                                           											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "/etc/hosts.deny 파일이 없습니다."                                                      										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo Result="Interview"	                                                                           								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "	                                                                                           	 							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "[참고] iptables"                                                                                       							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
iptables -L                                                                                  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-027 END"                                                                                									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "
sleep 1
echo "SRV-028 START"                                                                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#################           원격 터미널 접속 타임아웃 미설정			            #################"
echo "#################           원격 터미널 접속 타임아웃 미설정          			#################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: /etc/profile 에서 TMOUT=900 또는 /etc/csh.login 에서 autologout=15 이하로 설정되어 있으면 양호" 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : (1) sh, ksh, bash 쉘의 경우 /etc/profile 파일 설정을 적용받음"                 												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : (2) csh, tcsh 쉘의 경우 /etc/csh.cshrc 또는 /etc/csh.login 파일 설정을 적용받음" 												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ [참고] 내부 규정에 세션 종료시간이 명시되어 있을 경우 내부 규정을 따름" 																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "☞ 현재 로그인 계정 TMOUT"                                                               											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------"                                        										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `set | egrep -i "TMOUT|autologout" | wc -l` -gt 0 ]
	then
		set | egrep -i "TMOUT|autologout"                                                      										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "TMOUT 이 설정되어 있지 않습니다."                                                												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "☞ TMOUT 설정 확인"                                                                      											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① /etc/profile 파일"                                                                    										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------"                                        										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/profile ]
then
	if [ `cat /etc/profile | grep -i TMOUT | grep -v "^#" | wc -l` -gt 0 ]
	then
		cat /etc/profile | grep -i TMOUT | grep -v "^#"                                            									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "TMOUT 이 설정되어 있지 않습니다."                                                    											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "/etc/profile 파일이 없습니다."                                                         										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "② /etc/csh.login 파일"                                                                  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------"                                        										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/csh.login ]
then
	if [ `cat /etc/csh.login | grep -i autologout | grep -v "^#" | wc -l` -gt 0 ]
	then
		cat /etc/csh.login | grep -i autologout | grep -v "^#"                                     									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "autologout 이 설정되어 있지 않습니다."                                               											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "/etc/csh.login 파일이 없습니다."                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "③ /etc/csh.cshrc 파일"                                                                  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------"                                        										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/csh.cshrc ]
then
	if [ `cat /etc/csh.cshrc | grep -i autologout | grep -v "^#" | wc -l` -gt 0 ]
	then
		cat /etc/csh.cshrc | grep -i autologout | grep -v "^#"                                     									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "autologout 이 설정되어 있지 않습니다."                                               											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "/etc/csh.cshrc 파일이 없습니다."                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo Result="Interview"                                                                          								>> $HOSTNAME.$DATE.linux.result.txt 2>&1

echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-028 END"                                                                             										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "  
sleep 1
echo "SRV-034 START"                                                                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#########################           불필요한 서비스 활성화            ########################"
echo "#########################           불필요한 서비스 활성화            ########################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: automountd 서비스가 동작하지 않을 경우 양호"                                     												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① Automountd Daemon 확인"                                                               										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | egrep 'automount|autofs' | grep -v "grep" | egrep -v "statdaemon|emi" | wc -l` -gt 0 ] 
then
	ps -ef | egrep 'automount|autofs' | grep -v "grep" | egrep -v "statdaemon|emi"              									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag="Enabled"
else
	echo "☞ Automountd Daemon Disable"                                                         									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag="Disabled"
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo Result=$flag                                                                          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1

echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-034 END"                                                                             										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 

sleep 1
echo "SRV-035 START"                                                                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#####################           취약한 서비스 활성화              #####################"
echo "#####################           취약한 서비스 활성화              #####################" 											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: 아래 항목 모두에 해당사항이 없는 경우 양호"                                        													>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "      - tftp, talk, ntalk 서비스가 불필요하게 활성화된 경우"					 														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "      - finger 서비스 활성화"					 						 															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "      - rexec, rlogin, rsh 서비스 활성화"					 	 																	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "      - DoS 공격에 취약한 echo, discard, daytime, chargen 서비스 활성화"		 														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "      - NIS, NIS+ 서비스 활성화"					 					 															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ ※ 단, OS 백업솔루션에서 tftp를 반드시 사용해야 하는 경우 업무와 연관 유무를 고려 후 예외가능"  													>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① /etc/services 파일에서 포트 확인"                                                     											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="tftp" {print $1 "   " $2}' | grep "udp"                    										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="talk" {print $1 "   " $2}' | grep "udp"                    										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="ntalk" {print $1 "  " $2}' | grep "udp"                    										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="login" {print $1 "   " $2}' | grep "tcp"                   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="shell" {print $1 "   " $2}' | grep "tcp"                   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="exec" {print $1 "    " $2}' | grep "tcp"                   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
#cat /etc/services | awk -F" " '$1=="rsync" {print $1 "   " $2}' | grep "tcp"			   											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
#cat /etc/services | awk -F" " '$1=="rsync" {print $1 "   " $2}' | grep "udp"			   											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="finger" {print $1 "   " $2}' | grep "tcp"                  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="echo" {print $1 "      " $2}' | grep "tcp"                 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="echo" {print $1 "      " $2}' | grep "udp"                 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="discard" {print $1 "   " $2}' | grep "tcp"                 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="discard" {print $1 "   " $2}' | grep "udp"                 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="daytime" {print $1 "   " $2}' | grep "tcp"                 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="daytime" {print $1 "   " $2}' | grep "udp"                 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="chargen" {print $1 "   " $2}' | grep "tcp"                 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="chargen" {print $1 "   " $2}' | grep "udp"                 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1

echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1

echo "② 서비스 포트 활성화 여부 확인(tftp, talk, ntalk)"                                                         							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="tftp" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="tftp" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^udp" | wc -l` -gt 0 ]
	then
		echo "☞ tftp Service Enable"   																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1		
		netstat -na | grep ":$port " | grep -i "^udp"                                          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "☞ tftp Service Disable"   																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
fi
if [ `cat /etc/services | awk -F" " '$1=="talk" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="talk" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^udp" | wc -l` -gt 0 ]
	then
		echo "☞ talk Service Enable"   																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		netstat -na | grep ":$port " | grep -i "^udp"                                          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "☞ talk Service Disable"   																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
fi
if [ `cat /etc/services | awk -F" " '$1=="ntalk" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="ntalk" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^udp" | wc -l` -gt 0 ]
	then
		echo "☞ ntalk Service Enable"   																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		netstat -na | grep ":$port " | grep -i "^udp"                                          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "☞ ntalk Service Disable"   																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1	
	fi
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "③ 서비스 포트 활성화 여부 확인(rexec, rlogin, rsh)"                             														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="login" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="login" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		echo "☞ rlogin Service Enable"   																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1	
		netstat -na | grep ":$port " | grep -i "^tcp"                                          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else	
		echo "☞ rlogin Service Disable"   																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1	
	fi
fi

if [ `cat /etc/services | awk -F" " '$1=="shell" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="shell" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		echo "☞ rshell Service Enable"   																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1		
		netstat -na | grep ":$port " | grep -i "^tcp"                                          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "☞ rshell Service Disable"   																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1                                                                            
	fi
fi

if [ `cat /etc/services | awk -F" " '$1=="exec" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="exec" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		echo "☞ rexec Service Enable"   																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1		
		netstat -na | grep ":$port " | grep -i "^tcp"                                           									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "☞ rexec Service Disable"   																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
fi

#22년 금취 반영
:<< 'END'
if [ `cat /etc/services | awk -F" " '$1=="rsync" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="rsync" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		echo "☞ rsync Service Enable"   													>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		netstat -na | grep ":$port " | grep -i "^tcp"                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		if [ `cat /etc/services | awk -F" " '$1=="rsync" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
		then
			port=`cat /etc/services | awk -F" " '$1=="rsync" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
				if [ `netstat -na | grep ":$port " | grep -i "^udp" | wc -l` -gt 0 ]
				then
					netstat -na | grep ":$port " | grep -i "^udp"                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
				fi
		fi
	else
		echo "☞ rsync Service Disable"   													>> $HOSTNAME.$DATE.linux.result.txt 2>&1		
	fi
fi
END

echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "④ 서비스 포트 활성화 여부 확인(finger)"                             																	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="finger" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="finger" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -eq 0 ]
	then
		echo "☞ Finger Service Disable"                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "☞ Finger Service Enable"   																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1		
		netstat -na | grep ":$port " | grep -i "^tcp"                                          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
	echo " "                                                                                   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	#echo Result=`netstat -na | grep ":$port " | grep -i "^tcp" | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`   						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	if [ `netstat -na | grep ":79 " | grep -i "^tcp" | wc -l` -eq 0 ]
	then
		echo "☞ Finger Service Disable"                                                        									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "☞ Finger Service Enable"   																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1		
		netstat -na | grep ":79 " | grep -i "^tcp"                                              									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
	#echo Result=`netstat -na | grep ":79 " | grep -i "^tcp" | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi

echo "⑤ 서비스 포트 활성화 여부 확인(echo, discard, daytime, chargen)"                             											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="echo" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="echo" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		echo "☞ echo Service Enable"   																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		netstat -na | grep ":$port " | grep -i "^tcp"                                          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		if [ `cat /etc/services | awk -F" " '$1=="echo" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
		then
			port=`cat /etc/services | awk -F" " '$1=="echo" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
				if [ `netstat -na | grep ":$port " | grep -i "^udp" | wc -l` -gt 0 ]
				then
					netstat -na | grep ":$port " | grep -i "^udp"                                           						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				fi
		fi		
	else
		if [ `cat /etc/services | awk -F" " '$1=="echo" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
		then
			port=`cat /etc/services | awk -F" " '$1=="echo" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
				if [ `netstat -na | grep ":$port " | grep -i "^udp" | wc -l` -gt 0 ]
				then
					echo "☞ echo Service Enable"   																				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
					netstat -na | grep ":$port " | grep -i "^udp"                                           						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				else
					echo "☞ echo Service Disable"                                                         							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				fi
		fi
	fi
fi

if [ `cat /etc/services | awk -F" " '$1=="discard" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="discard" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		echo "☞ discard Service Enable"   																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		netstat -na | grep ":$port " | grep -i "^tcp"                                           									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		if [ `cat /etc/services | awk -F" " '$1=="discard" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
		then
			port=`cat /etc/services | awk -F" " '$1=="discard" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
				if [ `netstat -na | grep ":$port " | grep -i "^udp" | wc -l` -gt 0 ]
				then
					netstat -na | grep ":$port " | grep -i "^udp"                                           						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				fi
		fi
	else
		if [ `cat /etc/services | awk -F" " '$1=="discard" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
		then
			port=`cat /etc/services | awk -F" " '$1=="discard" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
				if [ `netstat -na | grep ":$port " | grep -i "^udp" | wc -l` -gt 0 ]
				then
					echo "☞ discard Service Enable"   																				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
					netstat -na | grep ":$port " | grep -i "^udp"                                           						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				else
					echo "☞ discard Service Disable"                                                    							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				fi
		fi
	fi
fi

if [ `cat /etc/services | awk -F" " '$1=="daytime" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="daytime" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		echo "☞ daytime Service Enable"   																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		netstat -na | grep ":$port " | grep -i "^tcp"                                           									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		if [ `cat /etc/services | awk -F" " '$1=="daytime" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
		then
			port=`cat /etc/services | awk -F" " '$1=="daytime" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
				if [ `netstat -na | grep ":$port " | grep -i "^udp" | wc -l` -gt 0 ]
				then
					netstat -na | grep ":$port " | grep -i "^udp"                                           						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				fi
		fi
	else
		if [ `cat /etc/services | awk -F" " '$1=="daytime" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
		then
			port=`cat /etc/services | awk -F" " '$1=="daytime" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
				if [ `netstat -na | grep ":$port " | grep -i "^udp" | wc -l` -gt 0 ]
				then
					echo "☞ daytime Service Enable"   																				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
					netstat -na | grep ":$port " | grep -i "^udp"                                           						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				else
					echo "☞ daytime Service Disable"                                                     							>> $HOSTNAME.$DATE.linux.result.txt 2>&1	
				fi
		fi
	fi
fi

if [ `cat /etc/services | awk -F" " '$1=="chargen" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="chargen" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		echo "☞ chargen Service Enable"   																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		netstat -na | grep ":$port " | grep -i "^tcp"                                           									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		if [ `cat /etc/services | awk -F" " '$1=="chargen" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
		then
			port=`cat /etc/services | awk -F" " '$1=="chargen" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
				if [ `netstat -na | grep ":$port " | grep -i "^udp" | wc -l` -gt 0 ]
				then
					netstat -na | grep ":$port " | grep -i "^udp"                                           						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				fi
		fi
	else
		if [ `cat /etc/services | awk -F" " '$1=="chargen" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
		then
			port=`cat /etc/services | awk -F" " '$1=="chargen" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
				if [ `netstat -na | grep ":$port " | grep -i "^udp" | wc -l` -gt 0 ]
				then
					echo "☞ chargen Service Enable"   																				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
					netstat -na | grep ":$port " | grep -i "^udp"                                           						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				else
					echo "☞ chargen Service Disable"                                                         						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				fi
		fi
	fi
fi

echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "⑥ NIS, NIS+ 서비스 활성화 여부 점검"                        				     														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
SERVICE="ypserv|ypbind|ypxfrd|rpc.yppasswdd|rpc.ypupdated|rpc.nids"

if [ `ps -ef | egrep $SERVICE | grep -v "grep" | wc -l` -eq 0 ]
then
	echo "☞ NIS, NIS+ Service Disable"                                                        										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "☞ NIS+ 데몬은 rpc.nids임"														   											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "☞ NIS, NIS+ Service Enable"                                                        										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	ps -ef | egrep $SERVICE | grep -v "grep"                                                   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	# if [ `ps -ef | grep "rpc.nids" | grep -v "grep" | wc -l` -eq 0 ]
	# then
		# flag="Enabled"
	# else
		# flag="nis+"
	# fi
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-035 END"                                                                             										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
echo "SRV-037 START"                                                                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "######################           취약한 FTP 서비스 실행            ######################"
echo "######################           취약한 FTP 서비스 실행            ######################" 											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: ftp 서비스가 비활성화 되어 있을 경우 양호"                                       													>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■		: 단, 업무상 필요하여 FTPS를 활용하는 등 통신 암호화를 위한 별도의 보안수단이 적용된 경우는 양호"  												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① /etc/services 파일에서 포트 확인"                                                     											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service파일:" $1 " " $2}' | grep "tcp" | wc -l` -gt 0 ]
then
	cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service파일:" $1 " " $2}' | grep "tcp" 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "(1)/etc/service파일: 포트 설정 X (Default 21번 포트)"                                     										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
if [ -s vsftpd.txt ]
then
	if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP 포트: " $1 "  " $2}' | wc -l` -gt 0 ]
	then
		cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP 포트: " $1 "  " $2}' 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "(2)VsFTP 포트: 포트 설정 X (Default 21번 포트 사용중)"                                 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "(2)VsFTP 포트: VsFTP가 설치되어 있지 않습니다."                                            										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
if [ -s proftpd.txt ]
then
	if [ `cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP 포트: " $1 "  " $2}' | wc -l` -gt 0 ]
	then
		cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP 포트: " $1 "  " $2}'      									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "(3)ProFTP 포트: 포트 설정 X (/etc/service 파일에 설정된 포트를 사용중)"                											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "(3)ProFTP 포트: ProFTP가 설치되어 있지 않습니다."                                    												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "② 서비스 포트 활성화 여부 확인"                                                         												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
################# /etc/services 파일에서 포트 확인 #################
if [ `cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN"                      										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                               > ftpenable.txt
	fi
else
	netstat -nat | grep ":21 " | grep -i "^tcp" | grep -i "LISTEN"                             										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                   > ftpenable.txt
fi
################# vsftpd 에서 포트 확인 ############################
if [ -s vsftpd.txt ]
then
	if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}' | wc -l` -eq 0 ]
	then
		port=21
	else
		port=`cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}'`
	fi
	if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN"                       									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                                > ftpenable.txt
	fi
fi
################# proftpd 에서 포트 확인 ###########################
if [ -s proftpd.txt ]
then
	port=`cat $profile | grep "Port" | grep -v "^#" | awk '{print $2}'`
	if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN"                        									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                                 > ftpenable.txt
	fi
fi

if [ -f ftpenable.txt ]
then
	rm -rf ftpenable.txt
	flag1="Enabled"
else
	echo "☞ FTP Service Disable"                                                                									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disabled"
fi
echo " "                                                                                         									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo Result=$flag1                                                                           									>> $HOSTNAME.$DATE.linux.result.txt 2>&1

echo " "                                                                                         									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-037 END"                                                                               									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
echo "SRV-040 START"                                                                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "##################           웹 서비스 디렉터리 리스팅 방지 설정 미흡            ###################"
echo "##################           웹 서비스 디렉터리 리스팅 방지 설정 미흡            ###################" 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: httpd.conf 파일의 Directory 부분의 Options 지시자에 Indexes가 설정되어 있지 않으면 양호" 												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ ! $apaflag -eq 0 ]
then
	flag1="Enabled"
	echo "☞ httpd 데몬 동작 확인"                                                         		 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"        									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	ps -ef | grep "httpd" | grep -v "grep"                                					     									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                     									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                     									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "☞ httpd 설정파일 경로"                                                          		 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f Inf_apaTemp.txt ]
	then
		cat Inf_apaTemp.txt                                                           			 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		rm -rf Inf_apaTemp.txt
	fi
	echo "------------------------------------------------------------------------------"        									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo $ACONF																					 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                     									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                     									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	
	if [ -f $ACONF ]
	then
		echo "☞ Indexes 설정 확인"                                                              										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"    									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		cat $ACONF | egrep -i "DocumentRoot " | grep -v '\#'                                     									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                                 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		cat $ACONF | egrep -i "<Directory |Indexes|</Directory" | grep -v '\#'                   									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2=`cat $ACONF | egrep -i "<Directory |Indexes|</Directory" | grep -v '\#' | grep Indexes | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
	else
		echo "☞ Apache 설정파일을 찾을 수 없습니다.(수동점검)"                                  												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2="Null"
	fi
else
	echo "☞ Apache Service Disable"                                                             									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                										>> $HOSTNAME.$DATE.linux.result.txt 2>&1

echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-040 END"                                                                             										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
echo "SRV-042 START"                                                                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#################           웹 서비스 상위 디렉터리 접근 제한 설정 미흡            #################"
echo "#################           웹 서비스 상위 디렉터리 접근 제한 설정 미흡            #################" 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준1: httpd.conf 파일의 Directory 부분의 AllowOverride None 설정이 아니면 양호"        												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준2: Directory Traversal 취약점이 발견되지 않은 Apache 버전(2.0.48이상)을 사용하고 있을 경우 양호"        									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ ! $apaflag -eq 0 ]
then
	flag1="Enabled"
	if [ -f $ACONF ]
	then
		echo "☞ $ACONF 파일 설정 확인"                                                              									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"        								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		cat $ACONF | egrep -i "DocumentRoot " | grep -v '\#'                                         								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                                     								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		cat $ACONF | egrep -i "<Directory |AllowOverride|</Directory" | grep -v '\#'                 								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2=`cat $ACONF | egrep -i "<Directory |AllowOverride|</Directory" | grep -v '\#' | grep AllowOverride | awk -F" " '{print $2}' | grep -v none | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
		echo " "																													>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "☞ APACHE 버전 확인"                                                              										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"       								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo $AVERSION																												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "																													>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "☞ Apache 설정파일을 찾을 수 없습니다.(수동점검)"                                      											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2="Null"
	fi
else
	echo "☞ Apache Service Disable"                                                                 								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi
echo " "                                                                                        									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result=$flag1":"$flag2																											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                        									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-042 END"                                                                              									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################"  									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "======================================================================================="  									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                        									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
# '24년 개선 사항 : 웹 서비스 범위 확대(Jeus 추가)
echo "SRV-043 START"                                                                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "####################           웹 서비스 경로 내 불필요한 파일 존재          ####################"
echo "####################           웹 서비스 경로 내 불필요한 파일 존재          ####################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준  : Server_Root 또는 DocumentRoot 내 manual, examples, samples 디렉터리가 존재하지 않거나,"           								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : test-cgi, printenv, 파일이 존재하지 않는 경우 양호"  						   												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ ! $apaflag -eq 0 ]
then
	flag1="Interview"
	echo "☞ ServerRoot Directory" 	 	                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"      										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo $AHOME																				   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "☞ DocumentRoot Directory" 	                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"      										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ $apache_type = "httpd" ]
	then
		DOCROOT=`cat $ACONF | grep -i ^DocumentRoot | awk '{print $2}' | sed 's/"//g'` 2>&1
		echo $DOCROOT																		   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	elif [ $apache_type = "apache2" ]
	then
		cat $AHOME/sites-enabled/*.conf | grep -i "DocumentRoot" | awk '{print $2}' | uniq     > apache2_DOCROOT.txt 2>&1
		cat apache2_DOCROOT.txt																   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
	echo " "                                                                                   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1

	find $AHOME -name "cgi-bin" -exec ls -l {} \;											   > unnecessary_file.txt 2>&1
	find $AHOME -name "printenv" -exec ls -l {} \;											   >> unnecessary_file.txt 2>&1
	find $AHOME -name "manual" -exec ls -ld {} \;											   > unnecessary_directory.txt 2>&1
	
	find $DOCROOT -name "cgi-bin" -exec ls -l {} \;											   >> unnecessary_file.txt 2>&1
	find $DOCROOT -name "printenv" -exec ls -l {} \;										   >> unnecessary_file.txt 2>&1
	
	if [ $apache_type = "apache2" ]
	then
		for docroot2 in `cat ./apache2_DOCROOT.txt`
		do
			find $docroot2 -name "cgi-bin" -exec ls -l {} \;								   >> unnecessary_file.txt 2>&1
			find $docroot2 -name "printenv" -exec ls -l {} \;								   >> unnecessary_file.txt 2>&1
			find $docroot2 -name "manual" -exec ls -ld {} \;								   >> unnecessary_directory.txt 2>&1
		done
	fi
	
		echo "☞ test-cgi, printenv 파일 확인"       					                       											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		if [ `cat ./unnecessary_file.txt | wc -l` -eq 0 ]
		then
			echo "☞ test-cgi, printenv 파일이 존재하지 않습니다."		                       												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		else
			cat ./unnecessary_file.txt														   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		fi
		echo " "                                                                               										>> $HOSTNAME.$DATE.linux.result.txt 2>&1

		echo "☞ manual 디렉토리 확인"				       					                   											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		if [ `cat ./unnecessary_directory.txt | wc -l` -eq 0 ]
		then
			echo "☞ manual 디렉토리가 존재하지 않습니다."		  				               												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		else
			cat ./unnecessary_directory.txt													   										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		fi
		echo " "                                                                               										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "☞ Apache Service Disable"                                                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disabled"
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1

rm -rf ./unnecessary_file.txt
rm -rf ./unnecessary_directory.txt

echo "JEUS 경로 내 불필요한 파일 확인 ( examples, samples )"                                       											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"  												>> $HOSTNAME.$DATE.linux.result.txt 2>&1

if [ `ps -ef | grep -i "jeus" | grep -v "grep" | wc -l` -gt 0 ]
then
	ls -al $JEUS_HOME | egrep -i "examples|samples"                            														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "☞ JEUS Service Disable"  																								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disabled"
fi

echo " "                                                                                        									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result=$flag1																													>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "																															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-043 END"                                                                              									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################"  									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "======================================================================================="  									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                        									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
# '24년 개선 사항 : 웹 서비스 범위 확대(Jeus 추가)
echo "SRV-044 START"                                                                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "##############           웹 서비스 파일 업로드 및 다운로드 용량 제한 미설정            ###############"
echo "##############           웹 서비스 파일 업로드 및 다운로드 용량 제한 미설정            ###############" 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: 시스템에 따라 파일 업로드 및 다운로드에 대한 용량이 제한되어 있는 경우 양호(파일사이즈 5M권고)"     												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : <Directory 경로>의 LimitRequestBody 지시자에 제한용량이 설정되어 있는 경우 양호" 													>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                    										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                        									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ ! $apaflag -eq 0 ]
then
	flag1="Enabled"
	if [ -f $ACONF ]
	then
		echo "☞ $ACONF 파일 설정 확인"                                                              									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"        								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		cat $ACONF | egrep -i "DocumentRoot " | grep -v '\#'                                         								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                                     								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		cat $ACONF | egrep -i "<Directory |LimitRequestBody|</Directory" | grep -v '\#'              								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                                     								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2=`cat $ACONF | egrep -i "<Directory |LimitRequestBody|</Directory" | grep -v '\#' | grep LimitRequestBody | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
	else
		echo "☞ Apache 설정파일을 찾을 수 없습니다.(수동점검)"                                      											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2="Null"
	fi
else
	echo "☞ Apache Service Disable"                                                                 								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi

echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "☞ JEUS 프로세스 확인"                                               																>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep -i "jeus" | grep -v grep | wc -l` -gt 0 ]
then
	ps -ef | grep -i "jeus" | grep -v grep																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Enabled"
	echo "☞ JEUS 서비스 domain.xml 파일 설정 확인"                                              		 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"        									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ `find / -name domain.xml -type f 2>/dev/null | wc -l` -gt 0 ]
	then
		DOMAIN_HOMEPATH=`find / -name domain.xml -type f 2>/dev/null`
		for domain in $DOMAIN_HOMEPATH
		do
			echo "● $domain 설정 파일 내용"																								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			cat $domain | grep -v "#"																								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo " "																												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		done
	else
		echo "doamin.xml 파일이 존재하지 않습니다."																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "☞ JEUS Service Disable"                                    																>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi

echo " "																															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo result=$flag1":"$flag2																											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-044 END"                                                                             										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
echo "SRV-045 START"                                                                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "##################           웹 서비스 프로세스 권한 제한 미비           ###################"
echo "##################           웹 서비스 프로세스 권한 제한 미비           ###################" 											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: 웹 프로세스 권한을 제한 했을 경우 양호(User root, Group root 가 아닌 경우)"      														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ ! $apaflag -eq 0 ]
then
	flag1="Enabled"
	echo "☞ $ACONF 파일 설정 확인"                                                            											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"      										>> $HOSTNAME.$DATE.linux.result.txt 2>&1	
	cat $ACONF | grep -i "^user"                                                               										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	cat $ACONF | grep -i "^group"                                                              										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	
	flag2=`cat $ACONF | grep -i "^user" | awk -F" " '{print $2}'`":"`cat $ACONF | grep -i "^group" | awk -F" " '{print $2}'`
	
	if [ $apache_type = "apache2" ]
	then
		echo " "                                                                               										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "☞ envvars 파일 설정 확인"                                                       											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		cat $AHOME/envvars | grep -i `cat $ACONF | grep -i "^User" | awk '{print $2}' | sed 's/[${}]//g'`  							>> $HOSTNAME.$DATE.linux.result.txt 2>&1	
		cat $AHOME/envvars | grep -i `cat $ACONF | grep -i "^Group" | awk '{print $2}' | sed 's/[${}]//g'` 							>> $HOSTNAME.$DATE.linux.result.txt 2>&1	
		usercheck=`cat $AHOME/envvars | grep -i `cat $ACONF | grep -i "^User" | awk '{print $2}' | sed 's/[${}]//g'` | awk -F"=" '{print $2}'`
		groupcheck=`cat $AHOME/envvars | grep -i `cat $ACONF | grep -i "^Group" | awk '{print $2}' | sed 's/[${}]//g'` | awk -F"=" '{print $2}'`
		flag2=$usercheck":"$groupcheck
	fi
	echo " "                                                                                     									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "☞ $apache_type 데몬 동작 계정 확인"                                                   											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"        									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	ps -ef | grep $apache_type | grep -v grep                                                    									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "☞ Apache Service Disable"                                                             									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled:Disabled"
fi
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo Result=$flag1":"$flag2                                                                										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-045 END"                                                                             										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
echo "SRV-046 START"                                                                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#################           웹 서비스 경로 설정 미흡                ###################"
echo "#################           웹 서비스 경로 설정 미흡                ###################" 											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: DocumentRoot 경로 중 "/" 등 기타 업무와 영역이 분리되지 않은 경로 또는 불필요한 경로가 존재하지 않을 경우 양호" 		   							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ ! $apaflag -eq 0 ]
then
	flag1="Interview"
	if [ -f $ACONF ]
	then
		echo "☞ DocumentRoot 확인"  		                                                   											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"  										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		if [ $apache_type = "httpd" ]
		then
			echo $DOCROOT																	   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		elif [ $apache_type = "apache2" ]
		then
			for docroot2 in `cat ./apache2_DOCROOT.txt`
			do
				echo $docroot2																   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			done
		fi
	else
		echo "☞ Apache 설정파일을 찾을 수 없습니다.(수동점검)"                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "☞ Apache Service Disable"                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo Result=$flag1				                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
rm -rf ./apache2_DOCROOT.txt
echo "SRV-046 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
echo "SRV-047 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "###################           웹 서비스 경로 내 불필요한 링크 파일 존재            ####################"
echo "###################           웹 서비스 경로 내 불필요한 링크 파일 존재            ####################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: Options 지시자에서 심블릭 링크를 가능하게 하는 옵션인 FollowSymLinks가 제거된 경우 양호" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ ! $apaflag -eq 0 ]
then
	flag1="Enabled"
	if [ -f $ACONF ]
	then
		echo "☞ $ACONF 파일 설정 확인"                                                              		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"        	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		cat $ACONF | egrep -i "DocumentRoot " | grep -v '\#'                                         	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                                     	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		cat $ACONF | egrep -i "<Directory |FollowSymLinks|</Directory" | grep -v '\#'                	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                                     	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2=`cat $ACONF | egrep -i "<Directory |FollowSymLinks|</Directory" | grep -v '\#' | grep FollowSymLinks | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
	else
		echo "☞ Apache 설정파일을 찾을 수 없습니다.(수동점검)"                                					>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2="Null"
	fi
else
	echo "☞ Apache Service Disable"                                                           		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result=$flag1":"$flag2                                                                	   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-047 END"                                                                             		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1

# '24년 개선 사항 : 웹 서비스 범위 확대(Jeus 추가)
echo "SRV-048 START"                                                                           		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#########################################################################################" 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#############           		불필요한 웹 서비스 실행           				 ##############"
echo "#############           		불필요한 웹 서비스 실행           				 ##############" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#########################################################################################" 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: 웹 서비스(Apache, Webtob 등)가 불필요하게 실행되고 있지 않은 경우 양호"								>> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "■ 현황"                                                                                  		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① 프로세스 구동 여부 확인(Webtob)"                                                              		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	Tempps=`echo "wsm[^a-z\.].*webtob|wsm[^a-z\.].*webtob|wsm|webtob" | sed "s/|/ /g"`
	temp_webtob1=0
	for ps in $Tempps
	do
		resTemp=`ps -ef | egrep "[^a-z]$ps[^a-z\.]|[^a-z]$ps$" | grep -v "grep" | sort | uniq`
		if [ "$resTemp" ]; then
			echo -e "$resTemp"                                             					   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo " "                                                                           		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			temp_webtob1=1
		fi
	done
	
	if [ $temp_webtob1 -eq 0 ]
	then 
		echo "WebtoB가 구동중이지 않음"                                                        		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                               		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
echo "② 프로세스 구동 여부 확인(Apache)"                                                               >> $HOSTNAME.$DATE.linux.result.txt 2>&1	
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ $apaflag -ne 0 ]
	then
		echo "Apache 구동중(불필요 여부 인터뷰 확인)"													>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                               		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "Apache 구동중이지 않음"																	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                               		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
	
echo "③ inetd 설정 확인"                                                                      		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	temp_webtob2=0
	Tempinetd=`echo "wsm|webtob" | sed "s/|/ /g"`
	for inetd in $Tempinetd
	do
		if [ -f "/etc/xinetd.d/$inetd" ]; then
			resTemp=`cat "/etc/xinetd.d/$inetd" | egrep -v "^#" | egrep "disable" | egrep "no" | egrep -v "^$"`
			if [ "$resTemp" ]; then
				echo -e "$resTemp" | sed "s/&/\&amp;/g" |  sed "s/</\&lt;/g" | sed "s/>/\&gt;/g" 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				echo " "                                                                         	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				$temp_webtob2=1
			fi
		fi
		
		if [ -f /etc/inetd.conf ]; then
			resTemp=`cat /etc/inetd.conf | egrep -v "^#" | egrep -i "^$inetd[d]?[^a-z]|[^a-z]$inetd[d]?[^a-z]" | egrep -v "^$"`
			if [ "$resTemp" ]; then
				echo -e "$resTemp" | sed "s/&/\&amp;/g" |  sed "s/</\&lt;/g" | sed "s/>/\&gt;/g"    >> $HOSTNAME.$DATE.linux.result.txt 2>&1
				echo " "                                                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
				$temp_webtob2=1
			fi
		fi
	done
	
	if [ $temp_webtob2 -eq 0 ]
	then 
		echo "WebtoB 설정이 존재하지 않음"                                                     		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                               		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
	
echo " "                                                                               		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "④ 프로세스 구동 여부 확인(Tomcat)"                                                     			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep -i "tomcat" | grep -v "grep" | wc -l` -gt 0 ]
then
	echo "Tomcat 서비스 구동중임"        																>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "Tomcat 서비스 미구동"         																>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi


echo " "                                                                               		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "⑤ 프로세스 구동 여부 확인(JEUS)"                                                     			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep -i "jeus" | grep -v "grep" | wc -l` -gt 0 ]
then
	echo "JEUS 서비스 구동중임"        																>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "JEUS 서비스 미구동"         																>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi

echo " "                                                                               		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result="Interview"										 									   	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-048 END"                                                                             		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "																							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
# '24년 개선 사항 : 웹 서비스 범위 확대(Jeus 추가)
echo "SRV-060 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "############             웹 서비스 기본 계정(아이디 또는 비밀번호) 미변경                ############"
echo "############             웹 서비스 기본 계정(아이디 또는 비밀번호) 미변경                ############" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: 관리자 계정/패스워드 tomcat/admin 또는 tomcat/admin 이외의 다른 패스워드로 설정되어 있을 경우 양호" >> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "		: Tomcat6.x와 7.x 이상은 Default 계정의 주석처리 확인 필요."                        >> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "		: JEUS는 accounts.xml 파일을 확인 해 유추 가능한 아이디와 패스워드(평문 또는 base64) 확인 필요"	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① Tomcat 구동 확인(프로세스)"                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep -i "tomcat" | grep -v "grep" | wc -l` -gt 0 ]
then
	ps -ef | grep -i "tomcat" | grep -v "grep"                                                 >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "② Tomcat 홈 디렉터리"                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	ps -ef |grep -i tomcat |awk -F'home' '{print $2}'|awk -F'=' '{print $2}' | awk '{print $1}'		>> $HOSTNAME.$DATE.linux.result.txt 2>&1

	echo "③ tomcat-users.xml 파일 설정 확인(Tomcat_HOME\conf\tomcat-users.xml)"            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -d `ps -ef |grep -i tomcat |awk -F'home' '{print $2}'|awk -F'=' '{print $2}' | awk '{print $1}'`/conf ]
	then
		if [ -f `ps -ef |grep -i tomcat |awk -F'home' '{print $2}'|awk -F'=' '{print $2}' | awk '{print $1}'`/conf/tomcat-users.xml ] 
		then
			ls -alL `ps -ef |grep -i tomcat |awk -F'home' '{print $2}'|awk -F'=' '{print $2}' | awk '{print $1}'`/conf/tomcat-users.xml                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo " "                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo "④ tomcat-users.xml 파일 내용 확인"                                              >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo "-----------------------------------------------------------------------"      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			cat `ps -ef |grep -i tomcat |awk -F'home' '{print $2}'|awk -F'=' '{print $2}' | awk '{print $1}'`/conf/tomcat-users.xml 						               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		else
			echo "tomcat-users.xml 파일이 존재하지 않음"                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		fi
	else
		echo "기본 환경변수 내 구동 경로 미지정 (수동점검 필요)"                               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "Tomcat 서비스가 구동되고 있지 않음"                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi

echo "⑤ JEUS 구동 확인(프로세스)"                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep -i "Jeus" | grep -v "grep" | wc -l` -gt 0 ]
then
	ps -ef | grep -i "Jeus" | grep -v "grep"													>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "																						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "⑥ accounts.xml 파일 설정 확인"																>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"      		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ `find / -name accounts.xml -type f 2>/dev/null | wc -l` -gt 0 ]
	then
		jeus_dir=`find / -name accounts.xml -type f 2>/dev/null`
		for jeus_file in $jeus_dir
		do
			if [ -f $jeus_file ]
			then
				cat $jeus_file																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			else
				continue
			fi
		done
	else
		echo "accounts.xml 파일이 없습니다."														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "JEUS Service Disabled" 															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result="Interview"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-060 END"                                                                             		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
echo "SRV-062 START"                                                                           		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################            DNS 서비스 정보 노출            #######################"
echo "#######################            DNS 서비스 정보 노출            #######################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: option 내부에 version 정보가 없는 경우 양호"                                     			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "     : named 프로세스가 존재하며 option 내부에 version 정보가 있는 경우 취약"           				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "     : option 내부에 version 구문이 없는 경우에도 Default로 버전정보 출력되어 취약"					>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep named | grep -v grep | wc -l` -gt 0 ]
then
	if [ -f /etc/named.conf ]
	then
		echo "① /etc/named.conf 설정 확인"													   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "-----------------------------------------------------------------------"      		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		cat /etc/named.conf | grep -i version														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "        																		  	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "☞ /etc/named.conf 파일이 존재하지 않습니다."      										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		Result="Interview"
	fi
	echo "② /etc/named.conf 설정 확인"													   			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "-----------------------------------------------------------------------"      			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/bind/named.conf ]
	then
		cat /etc/bind/named.conf | grep -i version													>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "        																		   	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "☞ /etc/bind/named.conf 파일이 존재하지 않습니다."      									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		Result="Interview"
	fi
else
	echo "☞ DNS Service Disable"                                                                	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disabled"
fi

echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result=$flag1                                                                            		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-062 END"                                                                             		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
echo "SRV-063 START"                                                                           		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#################           DNS Recursive Query 설정 미흡            ##################"
echo "#################           DNS Recursive Query 설정 미흡            ##################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: options { } 내부에 recursion yes 옵션이 없거나 no 로 설정된 경우 양호"           			>> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "■ 현황"                                                                                  		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① DNS 프로세스 확인"																			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep named | grep -v grep | wc -l` -gt 0 ]
then
	ps -ef | grep named | grep -v grep																>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "②	설정 확인"																		   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"      		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "☞ /etc/named.boot 확인" 								                               		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/named.boot ]
	then
		cat /etc/named.boot                              					                   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "☞ /etc/named.boot 파일이 없습니다."                                             		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi

	echo "☞ /etc/named.conf 확인" 								                               		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/named.conf  ]
	then
		cat /etc/named.conf                              					                   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "☞ /etc/named.conf 파일이 없습니다."                                             		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi

	echo "☞ /etc/bind/named.boot 확인" 								                       			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/bind/named.boot  ]
	then
		cat /etc/bind/named.boot                              					               		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "☞ /etc/bind/named.boot 파일이 없습니다."                                        		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
	
	echo "☞ /etc/bind/named.conf 확인" 								                   				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/bind/named.conf  ]
	then
		cat /etc/bind/named.conf                              					               		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "☞ /etc/bind/named.conf 파일이 없습니다."                                        		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
	
	echo "☞ /etc/bind/named.conf.options 확인" 								           				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f /etc/bind/named.conf.options  ]
	then
		cat /etc/bind/named.conf.options                              					       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "☞ /etc/bind/named.conf.options 파일이 없습니다."                                		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
	flag1="Interview"
else
	echo "☞ DNS Service Disable"                                                             		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disabled"
fi
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result=$flag1                                                                           		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-063 END"                                                                             		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
echo "SRV-064 START"                                                                           		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#############################################################################################">> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "######################            취약한 버전의 DNS 서비스 사용            ######################"
echo "######################            취약한 버전의 DNS 서비스 사용            ######################">> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#############################################################################################">> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준1: DNS 서비스를 사용하지 않거나, 양호한 버전을 사용하고 있을 경우에 양호"           				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "        : (양호한 버전: BIND 9.11.22, BIND 9.16.6, BIND 9.17.4 이상)"               				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준2: dig @localhost +short porttest.dns-oarc.net TXT 명령결과가 다음과 같을 경우 양호"			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "       (z.y.x.w.v.u.t.s.r.q.p.o.n.m.l.k.j.i.h.g.f.e.d.c.b.a.pt.dns-oarc.net."					>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "	  IP-of-GOOD is GOOD: 26 queries in 2.0 seconds from 26 ports with std dev 17685.51)" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
DNSPR=`ps -ef | grep named | grep -v "grep" | awk 'BEGIN{ OFS="\n"} {i=1; while(i<=NF) {print $i; i++}}'| grep "/" | uniq`
DNSPR=`echo $DNSPR | awk '{print $1}'`
if [ `ps -ef | grep named | grep -v grep | wc -l` -gt 0 ]
then
	flag1="Interview"
	if [ -f $DNSPR ]
	then
		echo "① BIND 버전 확인"                                                                      	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"      		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		$DNSPR -v | grep BIND                                                                      		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "																						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "② dig +short porttest.dns-oarc.net TXT 명령 결과 확인"                         				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"      		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		dig +short porttest.dns-oarc.net TXT 															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "$DNSPR 파일이 없습니다."                                                            	 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "☞ DNS Service Disable"                                                                		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disabled"
fi
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result=$flag1                                                                         		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-064 END"                                                                             		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
echo "SRV-066 START"                                                                           		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "######################           DNS Zone Transfer 설정 미흡          ####################"
echo "######################           DNS Zone Transfer 설정 미흡          ####################" 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: DNS 서비스를 사용하지 않거나 Zone Transfer 가 제한되어 있을 경우 양호"           				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① DNS 프로세스 확인 " 																			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep named | grep -v "grep" | wc -l` -eq 0 ]
then
	echo "☞ DNS Service Disable"                                                              		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag="Disabled"
else
	ps -ef | grep named | grep -v "grep"                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag="Interview"
fi
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ls -al /etc/rc.d/rc*.d/* | grep -i named | grep "/S" | wc -l` -gt 0 ]
then
	ls -al /etc/rc.d/rc*.d/* | grep -i named | grep "/S"                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
if [ -f /etc/rc.tcpip ]
then
	cat /etc/rc.tcpip | grep -i "named"                                                          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo "② /etc/named.conf 파일의 allow-transfer 확인(전체 설정으로 zone transfer 제한)"					>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/named.conf ]
then
	cat /etc/named.conf | grep 'allow-transfer'                                                		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ `cat /etc/named.conf | grep 'allow-transfer' | wc -l` -eq 0 ]
	then
		echo "allow-transfer 설정이 없습니다."															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "/etc/named.conf 파일이 없습니다."                                                    		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "③ /etc/named.rfc1912.zones 파일의 allw-transfer 확인 (zone 별 설정)"                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/named.rfc1912.zones ]
then
	cat /etc/named.rfc1912.zones | grep 'allow-transfer'											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ `cat /etc/named.rfc1912.zones | grep 'allow-transfer' | wc -l` -eq 0 ]
	then
		echo "allow-transfer 설정이 없습니다."															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "/etc/named.rfc1912.zones 파일이 없습니다."                                                  	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "④ /etc/named.boot 파일의 xfrnets 확인 (BIND4.9 DNS 설정)"                               		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/named.boot ]
then
	cat /etc/named.boot | grep "\xfrnets"                                                      		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "/etc/named.boot 파일이 없습니다."                                                    		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result=$flag                                                                          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-066 END"                                                                             		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
# 24년 개선 사항: encrypt_method 확인
echo "SRV-070 START"                                                                           		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "###################           취약한 패스워드 저장 방식 사용           ###################"
echo "###################           취약한 패스워드 저장 방식 사용           ###################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: Shadow 패스워드를 사용하거나 패스워드를 안전한 강도로 암호화하여 저장하는 경우 양호"              >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① shadow 패스워드 사용 여부 확인"																>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/passwd ]
then
	if [ `awk -F: '$2=="x"' /etc/passwd | wc -l` -eq 0 ]
	then
		echo "☞ /etc/passwd 파일에 패스워드가 암호화 되어 있지 않습니다."                     			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag1="X"
	else
		echo "☞ /etc/passwd 파일에 패스워드가 암호화 되어 있습니다."                          			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag1="O"
	fi
else
	echo "☞ /etc/passwd 파일이 존재하지 않습니다."                                                    >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Interview"
fi

echo " "																				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "② Salt 값 확인"																				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
enc_file=`find /etc -type f -name "login.defs" 2>/dev/null`
if [ -n "$enc_file" ]
then
	enc_method=`cat $enc_file | grep -v "#" | grep ENCRYPT_METHOD | awk -F" " '{print $2}'`
	if [ "$enc_method" == "SHA512" ]
	then
		echo "사용하시는 암호화 방식은 $enc_method 입니다."												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2="O"
	elif [ "$enc_method" == "SHA256" ]
	then
		echo "사용하시는 암호화 방식은 $enc_method 입니다."												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2="O"
	else
		echo "사용하시는 암호화 방식은 $enc_method 입니다."												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2="x"
	fi
fi
echo " "     	                                                                               				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result=`awk -F: '$2=="x"' /etc/passwd | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`":"$flag1":"$flag2		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-070 END"                                                                             				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "  
sleep 1
echo "SRV-073 START"                                                                           		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#############           관리자 그룹에 불필요한 사용자 존재            #################"
echo "#############           관리자 그룹에 불필요한 사용자 존재            #################" 			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: 관리자 그룹에 불필요한 계정이 없을 경우 양호"                                    			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① 관리자 계정"                                                                          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/passwd ]
then
    awk -F: '$3==0 { print $1 " -> UID=" $3 }' /etc/passwd                                     		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
    echo "/etc/passwd 파일이 없습니다."                                                        		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "② 관리자 계정이 포함된 그룹 확인"                                                       			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
for group in `awk -F: '$3==0 { print $1}' /etc/passwd`
do
	cat /etc/group | grep "$group"                                                             		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
done
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result="Interview"                                                                         	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-073 END"                                                                             		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
echo "SRV-081 START"                                                                           		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "##################           Crontab 설정파일 권한 설정 미흡           ###################"
echo "##################           Crontab 설정파일 권한 설정 미흡           ###################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: cron 서비스 관련 설정 파일들이 아래 기준을 만족하고 있는 경우 양호"                      		>> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "     - 1. /var/spool/cron/crontab/*에 others 읽기,쓰기 권한이 없음"								>> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "     - 2. at 접근제어 파일의 소유자가 root이고 권한이 640 이하"										>> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "     - 3. cron.allow와 cron.deny 파일의 소유자가 root이고 권한이 640 이하 "						>> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "■ 현황"                                                                                  		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① /var/spool/cron/crontab/*, /etc/crontab 등 crontab 관련 설정파일 권한 확인"                    >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "---------------- --------------------------------------------------------------"         		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -d /var/spool/cron/crontabs/ ]
then
	echo "☞ /var/spool/cron/crontabs 설정파일 권한 확인"                                     			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	ls -alL /var/spool/cron/crontabs | egrep -v "total|^d"								   			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ `ls -alL /var/spool/cron/crontabs | egrep -v "total|^d" | wc -l` -eq 0 ]
	then
		echo "/var/spool/cron/crontabs 내 파일이 존재하지 않습니다."									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo " ☞ /var/spool/cron/crontabs 존재하지 않습니다."                                     		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -d /var/spool/cron ]
then
	echo "☞ /var/spool/cron 파일 권한 확인"                                              			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	ls -alL /var/spool/cron | egrep -v "total|^d"										   			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ `ls -alL /var/spool/cron | egrep -v "total|^d" | wc -l` -eq 0 ]
	then
		echo "  /var/spool/cron/ 내 파일이 존재하지 않습니다."											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo " ☞ /var/spool/cron 존재하지 않습니다."                                    		 			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/crontab ]
then
	echo "☞ /etc/crontab 파일 권한 확인"                                              				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	ls -alL /etc/crontab																			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "☞ /etc/crontab 파일이 존재하지 않습니다."                                     				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -d /etc/cron.d ]
then
	echo "☞ /etc/cron.d 파일 권한 확인"                                              				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	ls -alL /etc/cron.d | egrep -v "total|^d"										   				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ `ls -alL /etc/cron.d | egrep -v "total|^d" | wc -l` -eq 0 ]
	then
		echo "  /etc/cron.d 내 파일이 존재하지 않습니다."												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo " ☞ /etc/cron.d 존재하지 않습니다."                                     						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/anacrontab ]
then
	echo "☞ /etc/anacrontab 파일 권한 확인"                                              			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	ls -alL /etc/anacrontab																			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                       	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo " ☞ /etc/anacrontab 파일이 존재하지 않습니다."                                     			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " " 
echo "② at.allow 파일 권한 확인"                                                              		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "---------------- --------------------------------------------------------------"         		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/at.allow ]
then
	ls -alL /etc/at.allow                                                                      		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "/etc/at.allow 파일이 없습니다."                                                      		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                      	 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "③ at.deny 파일 권한 확인"                                                               		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/at.deny ]
then
	ls -alL /etc/at.deny                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "/etc/at.deny 파일이 없습니다."                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "④ cron.allow 파일 권한 확인"                                                            		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/cron.allow ]
then
	ls -alL /etc/cron.allow                                                                    		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "/etc/cron.allow 파일이 없습니다."                                                    		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "⑤ cron.deny 파일 권한 확인"                                                             		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/cron.deny ]
then
	ls -alL /etc/cron.deny                                                                     		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "/etc/cron.deny 파일이 없습니다."                                                     		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-081 END"                                                                             		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
echo "SRV-082 START"                                                                           		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#########################################################################################" 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#################            시스템 주요 디렉터리 권한 설정 미흡            ##################"
echo "#################            시스템 주요 디렉터리 권한 설정 미흡            ##################" 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#########################################################################################" 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: 시스템 주요 디렉터리 내 others에 쓰기 권한이 없을 경우 양호(/usr /bin /sbin /etc /var)"       >> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "■ 현황"                                                                                  		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
HOMEDIRS="/sbin /etc /bin /usr /usr/bin /usr/sbin /usr/lbin /var"
for dir in $HOMEDIRS
do
  ls -dal $dir                                                                                 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
done
echo " "										                                               		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
HOMEDIRS="/sbin /etc /bin /usr /usr/bin /usr/sbin /usr/lbin /var"
for dir in $HOMEDIRS
do          
  if [ -d $dir ]
  then
    if [ `ls -dal $dir | awk -F" " '{print $1}' | grep "l........." | wc -l` -eq 1 ] 
    then
      echo "Manual" 																				>> SRV-082.txt
    elif [ `ls -dal $dir | awk -F" " '{print $1}' | grep "........w." | wc -l` -eq 1 ] 
    then
      echo "Fail" 																					>> SRV-082.txt
    else 
      echo "Success" 																				>> SRV-082.txt 
    fi
  else
    echo "Success" 																					>> SRV-082.txt                                          
  fi
done

if [ `cat SRV-082.txt | grep "Fail" | wc -l` -eq 1 ]
then 
  flag1="Fail"
elif [ `cat SRV-082.txt | grep "Manual" | wc -l` -eq 1 ]
then
  flag1="Interview"
else 
  flag1="Success"
fi

echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result=$flag1																			   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-082 END"                                                                             		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1	
rm -rf SRV-082.txt
sleep 1
echo "SRV-083 START"                                                                           		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "###############           시스템 스타트업 스크립트 권한 설정 미흡           ################"
echo "###############           시스템 스타트업 스크립트 권한 설정 미흡           ################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: others에 쓰기 권한이 없을 경우 양호"                                             			>> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "■ 현황"                                                                                  		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① /etc/init.d /etc/rc2.d /etc/rc3.d /etc/rc.d/init.d 파일 권한 확인"                    		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	DIR_STARTUP="/etc/init.d /etc/rc2.d /etc/rc3.d /etc/rc.d/init.d"
	for ldir in $DIR_STARTUP; 
		do
		echo "☞ $ldir/* 파일 권한"															   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		if [ -d $ldir ]
		then
			ls -aldL $ldir/* | sed "s/&/\&amp;/g" |  sed "s/</\&lt;/g" | sed "s/>/\&gt;/g"	   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		else
			echo "존재하지 않음."                                                              		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		fi
		done	
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result="Interview"          	                                                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-083 END"                                                                             		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
echo "SRV-084 START"                                                                           		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "###################           시스템 주요 파일 권한 설정 미흡           ###################"
echo "###################           시스템 주요 파일 권한 설정 미흡           ###################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: 시스템 주요 파일의 권한이 아래의 조건보다 낮게 부여된 경우 양호"                				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "      - 1. /etc/passwd: 권한 644, 소유자 root"                									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "      - 2. /etc/shadow : 권한 600, 소유자 root"                									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "      - 3. /etc/hosts : 권한 644, 소유자 root"                									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "      - 4. /etc/(x)inetd.conf : 권한 600, 소유자 root"                							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "      - 5. /etc/syslog.conf : 권한 644, 소유자 root"                							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "      - 6. /etc/services : 권한 644, 소유자 root"                								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "      - 7. /etc/hosts.lpd : 권한 640, 소유자 root"                								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① /etc/passwd 파일 권한 확인 (권한 644, 소유자 root)"                    						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/passwd ]
  then
    ls -alL /etc/passwd                                                                        		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
    echo " "                                                                                   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
  else
    echo "☞ /etc/passwd 파일이 없습니다."                                                     		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
    echo " "                                                                                   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo "② /etc/shadow 파일 권한 확인 (권한 600, 소유자 root)"                    						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/shadow ]
then
	ls -alL /etc/shadow                                                                        		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "☞ /etc/shadow 파일이 없습니다."                                                     		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo "③ /etc/hosts 파일 권한 확인 (권한 644, 소유자 root)"                    							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/hosts ]
  then
    ls -alL /etc/hosts                                                                         		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
    echo " "                                                                                   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
   else
    echo "☞ /etc/hosts 파일이 없습니다."                                                      		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
    echo " "                                                                                   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo "④ /etc/xinetd.conf 파일 (권한 600, 소유자 root)"                                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/xinetd.conf ]
then
	ls -alL /etc/xinetd.conf                                                                   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "/etc/xinetd.conf 파일이 없습니다."                                                   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "⑤ /etc/xinetd.d/ 파일 (권한 600, 소유자 root)"                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -d /etc/xinetd.d ]
then
	ls -al /etc/xinetd.d/*                                                                     		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	
else
	echo "/etc/xinetd.d 디렉터리가 없습니다."                                                  		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "⑥ /etc/inetd.conf 파일 (권한 600, 소유자 root)"                                                 >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/inetd.conf ]
then
	ls -alL /etc/inetd.conf                                                                    		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "/etc/inetd.conf 파일이 없습니다."                                                    		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "⑦ /etc/syslog.conf 파일 (권한 644, 소유자 root)"                                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/syslog.conf ]
then
    ls -alL /etc/syslog.conf                                                                   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
    echo " "                                                                                   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
elif [ -f /etc/rsyslog.conf ]
then
	ls -alL /etc/rsyslog.conf                                                           	   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                          	       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
    echo "☞ /etc/(r)syslog.conf 파일이 없습니다."                                             		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
    echo " "                                                                                   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo "⑧ /etc/services 파일 (권한 644, 소유자 root)"                                                  	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/services ]
  then
    ls -alL /etc/services                                                                      		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
    echo " "                                                                                   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
   else
    echo "☞ /etc/services 파일이 없습니다."                                                   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
    echo " "                                                                                   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "⑨ /etc/hosts.lpd 파일 (권한 640, 소유자 root)"                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/hosts.lpd ]
then
	ls -alL /etc/hosts.lpd                                                                     		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                         	       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
 else
  echo "☞ /etc/hosts.lpd 파일이 없습니다. (양호)"                                             		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
  echo " "                                                                         	           		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-084 END"                                                                             		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
sleep 1
echo "SRV-087 START"                                                                           		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#################           C 컴파일러 존재 및 권한 설정 미흡            ##################"
echo "#################           C 컴파일러 존재 및 권한 설정 미흡            ##################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: 컴파일러가 없거나 others 실행권한이 없을 시 양호"                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
DIR_temp="/usr/bin/cc /usr/bin/gcc /usr/ucb/cc /usr/ccs/bin/cc /opt/ansic/bin/cc /usr/vac/bin/cc /usr/local/bin/gcc"
	for dir in $DIR_temp; do
		if [ -f $dir ]
		then
			echo " "                                                                           		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo "☞ $dir 파일 권한"														   			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			ls -alL $dir																	   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo " "                                                                           		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		else
			echo "☞ $dir 존재하지 않음."													   			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo " "                                                                           		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		fi
	done
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result="Interview"          	                                                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-087 END"                                                                             		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
echo "SRV-091 START"                                                                           		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################"		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "##############           불필요하게 SUID, SGID bit 설정된 파일 존재           #############"
echo "##############           불필요하게 SUID, SGID bit 설정된 파일 존재           #############" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: 불필요한 SUID/SGID 설정이 존재하지 않을 경우 양호"                               			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
find /usr -xdev -user root -type f \( -perm -04000 -o -perm -02000 \) -exec ls -al  {}  \;     		> SRV-091.txt
sleep 1
find /sbin -xdev -user root -type f \( -perm -04000 -o -perm -02000 \) -exec ls -al  {}  \;    		>> SRV-091.txt
sleep 1
if [ -s SRV-091.txt ]
then
	sleep 1
	linecount=`cat SRV-091.txt | wc -l`
	if [ $linecount -gt 10 ]
	then
		echo "SUID,SGID,Sticky bit 설정 파일 (상위 10개)"                                          	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"  		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		head -10 SRV-091.txt                                                                     	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                                   	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " 등 총 "$linecount"개 파일 존재 (전체 목록은 스크립트 결과 파일 확인)"               			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                                   	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo Result=$linecount                                                                 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                               		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "SUID,SGID,Sticky bit 설정 파일"                                                      	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"  		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		cat SRV-091.txt                                                                          	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                                   	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " 총 "$linecount"개 파일 존재"                                                        	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                                   	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo Result=$linecount                                                                 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                               		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "☞ SUID/SGID로 설정된 파일이 발견되지 않았습니다."                                   			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " " 		                                                                           		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo Result=$linecount                                             				           		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-091 END"                                                                             		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
echo "SRV-092 START"                                                                           		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "########################################################################################" 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#####################           사용자 홈 디렉터리 설정 미흡           #####################"
echo "#####################           사용자 홈 디렉터리 설정 미흡           #####################" 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "########################################################################################" 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: 홈 디렉터리의 소유자가 실 사용자가 일치하고, 계정간 중복 홈 디렉터리가 존재하지 않고, 불필요한 others 쓰기 권한이 없는 경우 양호"   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① 사용자별 홈 디렉터리(홈디렉터리 소유자가 실 사용자 일치 여부 확인 및 others 쓰기 권한 여부 확인)"       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
sleep 1
TEMP_STR=`cat /etc/passwd | awk -F: '{ print $1":"$6":"$7 }'| grep -v "#" | grep -v "/tmp" | grep -v "uucppublic" | uniq`

for HOME_DATA in $TEMP_STR
do
	
  HOME_OWNER=`echo $HOME_DATA | awk -F: '{ print $1 }'`
  HOME=`echo $HOME_DATA | awk -F: '{ print $2 }'`
  HOME_NOLOGIN=`echo $HOME_DATA | awk -F: '{ print $3 }'`
  
	if [[ "$HOME_NOLOGIN" == *"nologin"* ]]
	then
		RESULT=""
	else   
		echo "● 계정명 : $HOME_OWNER -> 홈디렉터리 : $HOME ($HOME_NOLOGIN)"							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		if [ -d $HOME ]
		then
			ls -dal $HOME																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo ""																					>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		else
			echo "[None Directory]"																	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo ""																					>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		fi
	fi
done
echo " "                                                                            				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
sleep 1
echo "② 계정간 중복 홈 디렉터리 (사용자 계정 위주로 확인)"                                          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "																							> totaltempdir.txt
for HOME_DATA in $TEMP_STR
do
      HOME_OWNER=`echo $HOME_DATA | awk -F: '{ print $1 }'`
      HOME=`echo $HOME_DATA | awk -F: '{ print $2 }'`
      HOME_NOLOGIN=`echo $HOME_DATA | awk -F: '{ print $3 }'`

    if [[ "$HOME_NOLOGIN" == *"nologin"* ]]
    then
		RESULT=""
    else   
		cat /etc/passwd | awk -F: '$6=="'$HOME'" { print "중복 HOMEDIR=" $6 " -> " "계정명: " $1 " (" $7 ")"}' > tmepdir.txt
		if [ `cat tmepdir.txt | wc -l` -gt 1 ]
		then
			cat tmepdir.txt                                                                        	>> totaltempdir.txt
		fi
    fi
 done	
sleep 1
if [ `sort -k 1 totaltempdir.txt | wc -l` -gt 1 ]
then
	sort -k 1 totaltempdir.txt | uniq -d                                                     		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "동일한 홈디렉터리를 사용하는 계정이 발견되지 않았습니다."                               			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1

echo "③ [참고] 홈 디렉터리가 존재하지 않은 계정"                                           			    >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
sleep 1
for HOME_DATA in $TEMP_STR
do
  HOME_OWNER=`echo $HOME_DATA | awk -F: '{ print $1 }'`
  HOME=`echo $HOME_DATA | awk -F: '{ print $2 }'`
  HOME_NOLOGIN=`echo $HOME_DATA | awk -F: '{ print $3 }'`
  
  flag=0
  
	if [[ "$HOME_NOLOGIN" == *"nologin"* ]]
	then
		RESULT=""
	else   
		if [ ! -d $HOME ]
		then
			echo "● 계정명-> 홈디렉터리: "$HOME_OWNER "->" $HOME "("$HOME_NOLOGIN")" 					>> $HOSTNAME.$DATE.linux.result.txt 2>&1				
			echo " "                                                                               	> nothomedir.txt
		fi
	fi
done

if [ ! -f nothomedir.txt ]
then
	echo "홈 디렉터리가 존재하지 않은 계정이 발견되지 않았습니다. (양호)"                     				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo " "                                                                                   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi 
sleep 1
echo " "                                                                                       	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-092 END"                                                                             		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
rm -rf nothomedir.txt
rm -rf totaltempdir.txt
rm -rf tmepdir.txt

sleep 1
echo "SRV-093 START"                                                                           		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#################           불필요한 world writable 파일 존재           #################"
echo "#################           불필요한 world writable 파일 존재           #################" 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "######################################################################################" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: 불필요한 world writable 파일이 존재하지 않을 경우 양호"          					  	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■    : 파일 존재 시 쓰기가능 설정 이유 확인하여 관리하는 경우 양호"  							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -d /etc ]
then
sleep 1
  find /etc -type f -perm -2 -ls | awk '{print $3 " : " $5 " : " $6 " : " $11}' | grep -v "^l"         > world-writable.txt
fi
if [ -d /var ]
then
sleep 1
  find /var -type f -perm -2 -ls | awk '{print $3 " : " $5 " : " $6 " : " $11}' | grep -v "^l"         >> world-writable.txt
fi
if [ -d /tmp ]
then
sleep 1
  find /tmp -type f -perm -2 -ls | awk '{print $3 " : " $5 " : " $6 " : " $11}' | grep -v "^l"         >> world-writable.txt
fi
if [ -d /home ]
then
sleep 1
  find /home -type f -perm -2 -ls | awk '{print $3 " : " $5 " : " $6 " : " $11}'| grep -v "^l"         >> world-writable.txt
fi
if [ -d /export ]
then
sleep 1
  find /export -type f -perm -2 -ls | awk '{print $3 " : " $5 " : " $6 " : " $11}'| grep -v "^l"       >> world-writable.txt
fi
sleep 1
if [ -s world-writable.txt ]
then

  linecount=`cat world-writable.txt | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
  if [ $linecount -gt 10 ]
  then
  	echo "World Writable 파일 (상위 10개)"                                                     	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"  	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	  	head -10 world-writable.txt                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
    	echo " "                                                                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
  		echo " 등 총 "$linecount"개 파일 존재 (전체 목록은 스크립트 결과 파일  확인)"           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " " 		                                                                       	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo Result=$linecount                                                                 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                               	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "SRV-093 END"                                                                     	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                               	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
   else
    	echo "World Writable 파일"                                                              >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		cat world-writable.txt                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
    	echo " 총 "$linecount"개 파일 존재"                                                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                               	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo Result=$linecount                                                                 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " " 		                                                                       	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "SRV-093 END"                                                                     	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
    echo "☞ World Writable 권한이 부여된 파일이 발견되지 않았습니다."							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
    echo " "                                                                                   	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
    echo Result=0 				                                                               	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                               	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
    echo "SRV-093 END"                                                                         	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
echo "SRV-094 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "################           Crontab 참조파일 권한 설정 미흡            #################"
echo "################           Crontab 참조파일 권한 설정 미흡            #################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: crontab 참조파일(cron 파일 내 실행하는 파일)에 others 쓰기 권한이 없는 경우 양호">> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① crontab이 참조하고 있는 파일 확인"                    								  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -d /etc/cron.daily ]
then
	echo "☞ /etc/cron.daily 설정파일 권한 확인"                         			           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	ls -alL /etc/cron.daily | egrep -v "total|^d"								   			   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ `ls -alL /etc/cron.daily | egrep -v "total|^d" | wc -l` -eq 0 ]
	then
		echo "/etc/cron.daily 내 파일이 존재하지 않습니다."									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo " ☞ /etc/cron.daily 존재하지 않습니다."                                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -d /etc/cron.hourly ]
then
	echo "☞ /etc/cron.hourly 설정파일 권한 확인"                         			            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	ls -alL /etc/cron.hourly | egrep -v "total|^d"								   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ `ls -alL /etc/cron.hourly | egrep -v "total|^d" | wc -l` -eq 0 ]
	then
		echo "/etc/cron.hourly 내 파일이 존재하지 않습니다."								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo " ☞ /etc/cron.hourly 존재하지 않습니다."                                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -d /etc/cron.monthly ]
then
	echo "☞ /etc/cron.monthly 설정파일 권한 확인"                         			            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	ls -alL /etc/cron.monthly | egrep -v "total|^d"								   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ `ls -alL /etc/cron.monthly | egrep -v "total|^d" | wc -l` -eq 0 ]
	then
		echo "/etc/cron.monthly 내 파일이 존재하지 않습니다."								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo " ☞ /etc/cron.monthly 존재하지 않습니다."                                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -d /etc/cron.weekly ]
then
	echo "☞ /etc/cron.weekly 설정파일 권한 확인"                         			            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	ls -alL /etc/cron.weekly | egrep -v "total|^d"								   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ `ls -alL /etc/cron.weekly | egrep -v "total|^d" | wc -l` -eq 0 ]
	then
		echo "/etc/cron.weekly 내 파일이 존재하지 않습니다."								>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo " ☞ /etc/cron.weekly 존재하지 않습니다."                                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result="Interview"          	                                                                   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-094 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "
sleep 1
echo "SRV-095 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "###############          존재하지 않는 소유자 및 그룹 권한을 가진 파일 또는 디렉터리 존재          ###############"
echo "###############          존재하지 않는 소유자 및 그룹 권한을 가진 파일 또는 디렉터리 존재          ###############" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: 소유자가 존재하지 않는 파일 및 디렉토리가 존재하지 않을 경우 양호"               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ ※ 실제 소유자명이 숫자일 경우가 있으므로 담당자 확인 필수"		                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "☞ 소유자가 존재하지 않는 파일 (소유자 => 파일위치: 경로)"                               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -d /etc ]
then
  find /etc -ls | awk '{print $5 " => " $11}' | egrep -v -i "(^a|^b|^c|^d|^e|^f|^g|^h|^i|^j|^k|^l|^m|^n|^o|^p|^q|^r|^s|^t|^u|^v|^w|^x|^y|^z)" > SRV-095.txt
fi
if [ -d /var ]
then
find /var -ls | awk '{print $5 " => " $11}' | egrep -v -i "(^a|^b|^c|^d|^e|^f|^g|^h|^i|^j|^k|^l|^m|^n|^o|^p|^q|^r|^s|^t|^u|^v|^w|^x|^y|^z)" >> SRV-095.txt
fi
if [ -d /tmp ]
then
find /tmp -ls | awk '{print $5 " => " $11}' | egrep -v -i "(^a|^b|^c|^d|^e|^f|^g|^h|^i|^j|^k|^l|^m|^n|^o|^p|^q|^r|^s|^t|^u|^v|^w|^x|^y|^z)" >> SRV-095.txt
fi
if [ -d /home ]
then
find /home -ls | awk '{print $5 " => " $11}' | egrep -v -i "(^a|^b|^c|^d|^e|^f|^g|^h|^i|^j|^k|^l|^m|^n|^o|^p|^q|^r|^s|^t|^u|^v|^w|^x|^y|^z)" >> SRV-095.txt
fi
if [ -d /export ]
then
find /export -ls | awk '{print $5 " => " $11}' | egrep -v -i "(^a|^b|^c|^d|^e|^f|^g|^h|^i|^j|^k|^l|^m|^n|^o|^p|^q|^r|^s|^t|^u|^v|^w|^x|^y|^z)" >> SRV-095.txt
fi

if [ -s SRV-095.txt ]
then
	linecount=`cat SRV-095.txt | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
	if [ $linecount -gt 10 ]
	then
		echo "소유자가 존재하지 않는 파일 (상위 10개)"                                          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		head -10 SRV-095.txt                                                                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                                    >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " 등 총 "$linecount"개 파일 존재 (전체 목록은 스크립트 결과 파일 확인)"                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo Result=$linecount                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "SRV-095 END"                                                                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "소유자가 존재하지 않는 파일"                                                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		cat SRV-095.txt                                                                         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                                    >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " 총 "$linecount"개 파일 존재"                                                         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo Result=$linecount                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "SRV-095 END"                                                                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "------------------------------------------------------------------------------"         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "소유자가 존재하지 않는 파일이 발견되지 않았습니다."                                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo Result=0					                                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1	
	echo " "                                                                                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "SRV-095 END"                                                                          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                        >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################"  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "======================================================================================="  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                        >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
# 24년 개선 사항 : 기준 문구 변경
echo "SRV-096 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#####           사용자 환경파일의 소유자 또는 권한 설정 미흡           	#####"
echo "#####           사용자 환경파일의 소유자 또는 권한 설정 미흡           	#####" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준 : 사용자 환경 파일에 others에 부여된 권한(읽기, 쓰기, 실행)이 없을 경우"  						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ [참고] 주요정보통신기반시설 기준: 홈 디렉터리 환경변수 파일 소유자가 root 또는 해당 계정으로 지정되어 있고"        >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 			: 홈디렉터리 환경변수 파일에 소유자 이외에 쓰기 권한이 제거되어 있으면 양호"       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "☞ 홈디렉터리 환경변수 파일"                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u | grep -v '/bin/false' | grep -v 'nologin' | grep -v "#"`
FILES=".profile .cshrc .kshrc .login .bash_profile .bashrc .bash_login .exrc .netrc .history .sh_history .bash_history .dtprofile"
# 무의미한 것으로 보이는 코드
#for file in $FILES
#do
#	FILE=/$file
#	if [ -f $FILE ]
#	then
#		ls -alL $FILE                                                                              >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#	fi
#done

for dir in $HOMEDIRS
do
	for file in $FILES
	do
    FILE=$dir/$file
		if [ -f $FILE ]
		then
			ls -alL $FILE                                                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		fi
	done
done
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result="Interview"                                                                          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-096 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 																						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
sleep 1
# 24년 개선 사항 : 예시 추가
echo "SRV-108 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "################           로그에 대한 접근통제 및 관리 미흡            ################"
echo "################           로그에 대한 접근통제 및 관리 미흡            ################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: 디렉터리 내 로그 파일들의 권한이 644 이하일 때 양호"                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "ex) 디렉터리 내 로그 파일들의 권한이 owner에 읽기(r), 쓰기(w), group에 읽기(r), other에 읽기(r)로 할당한 경우(파일 권한이 644일 때 양호)" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " ※ /var/log/wtmp의 경우는 664 이하 (권한 변경 불가)"                            			>> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "   /var/log/btmp의 경우는 660 이하 (권한 변경 불가)"                            			>> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "☞ /var/log 내 로그 파일 목록"                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
DIR_LOG="/var/log"
for ldir in $DIR_LOG;
do
	echo $ldir"/* 확인"                                                              		   	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "-------------------------------------------"  									   	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	ls -aldL $ldir/*																		   	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                   	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
done
echo " "                                                                                       	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result="Interview"																			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-108 END"                                                                             	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
echo "SRV-109 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "##################           시스템 주요 이벤트 로그 설정 미흡            ##################"
echo "##################           시스템 주요 이벤트 로그 설정 미흡            ##################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준1: syslog 로그 기록 정책이 내부 정책에 부합하게 설정되어 있는 경우 양호" 				>> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "■ 기준2: syslog 설정에서 auth 또는 authpriv(su 명령 로그)가 활성화 된 경우 양호"			>> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① SYSLOG 데몬 동작 확인"                                                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep 'syslog' | grep -v 'grep' | wc -l` -eq 0 ]
then
	echo "☞ SYSLOG Service Disable"                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	ps -ef | grep 'syslog' | grep -v 'grep'                                                    >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "② syslog 설정 확인"                                                                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/syslog.conf ]
then
	if [ `cat /etc/syslog.conf | grep -v "^#" | grep -v "^ *$" | wc -l` -gt 0 ]
	then
		cat /etc/syslog.conf | grep -v "^#" | grep -v "^ *$"                                   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "/etc/syslog.conf 파일에 설정 내용이 없습니다.(주석, 빈칸 제외)"                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "/etc/syslog.conf 파일이 없습니다."                                                   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "③ rsyslog 설정 확인"                                                                    >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/rsyslog.conf ]
then
	if [ `cat /etc/rsyslog.conf | grep -v "^#" | grep -v "^ *$" | wc -l` -gt 0 ]
	then
		cat /etc/rsyslog.conf | grep -v "^#" | grep -v "^ *$"                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "/etc/rsyslog.conf 파일에 설정 내용이 없습니다.(주석, 빈칸 제외)"                 >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "/etc/rsyslog.conf 파일이 없습니다."                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "④ [참고] sulog 별도 지정 여부 확인"																	 >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "(syslog.conf 혹은 rsyslog.conf 파일 내 /var/log/secure에 기본적으로 authpriv(sulog) 저장됨."				>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "그외 별도 경로 지정 여부 확인을 위해 아래 내용 출력)"   									 >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "☞ /etc/login.defs 파일 확인"        										  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/login.defs ]
then
	if [ `cat /etc/login.defs | grep -i -E "sulog|secure" | grep -v "^#" | grep -v "^ *$" | wc -l` -gt 0 ]
	then
		cat /etc/login.defs | grep -i -E "sulog|secure" | grep -v "^#" | grep -v "^ *$"              >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "/etc/login.defs 파일 내 sulog 설정이 존재하지 않음."                                        >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "/etc/login.defs 파일이 없습니다."                                                    >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1  
echo "☞ /etc/logrotate.d/syslog 파일 확인"        										  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/logrotate.d/syslog ]
then
	if [ `cat /etc/logrotate.d/syslog | grep -i -E "sulog|secure" | grep -v "^#" | grep -v "^ *$" | wc -l` -gt 0 ]
	then
		cat /etc/logrotate.d/syslog | grep -i -E "sulog|secure" | grep -v "^#" | grep -v "^ *$"      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "/etc/logrotate.d/syslog 파일 내 sulog 설정이 존재하지 않음."                                 >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "/etc/logrotate.d/syslog 파일이 없습니다."                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-109 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
# 24년 개선 사항 : 기준 문구 변경 및 스크립트 수정
echo "SRV-112 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#################           Cron 서비스 로깅 미설정            ###################"
echo "#################           Cron 서비스 로깅 미설정            ###################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: syslog 로그 기록 정책 또는 다른 로그 프로그램으로 cron 로그가 기록되는 경우 양호"					>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① SYSLOG 데몬 동작 확인" 																>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep 'syslog' | grep -v 'grep' | wc -l` -eq 0 ]
then
	echo "SYSLOG Service Disable"														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Interview"
else
	ps -ef | grep 'syslog' | grep -v 'grep'													>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "																						>> $HOSTNAME.$DATE.linux.result.txt 2>&1

echo "② SYSLOG 설정 확인"																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/syslog.conf ]
then
	if [ `cat /etc/syslog.conf | grep -v "^#" | grep -v "^ *$" | grep -i "cron" | wc -l` -gt 0 ]
	then
		cat /etc/syslog.conf | grep -v "^#" | grep -v "^ *$" | grep -i "cron"									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2="O"
	else
		cat /etc/syslog.conf | grep -v "^#" | grep -v "^ *$"													>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "SYSLOG 설정 파일이 존재하지 않습니다."													>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "																						>> $HOSTNAME.$DATE.linux.result.txt 2>&1	

echo "③ RSYSLOG 데몬 동작 확인"																	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep 'rsyslog' | grep -v 'grep' | wc -l` -eq 0 ]
then
	echo "RSYSLOG Service Disabled"															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Interview"
else
	ps -ef | grep 'rsyslog' | grep -v 'grep'												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "																										>> $HOSTNAME.$DATE.linux.result.txt 2>&1

echo "④ RSYSLOG 설정 확인"																	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/rsyslog.conf ]
then
	if [ `cat /etc/rsyslog.conf | grep -v "^#" | grep -v "^ *$" | grep -i "cron" | wc -l` -gt 0 ]
	then
		cat /etc/rsyslog.conf | grep -v "^#" | grep -v "^ *$" | grep -i "cron"					>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2="O"
	else
		cat /etc/rsyslog.conf | grep -v "^#" | grep -v "^ *$"									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "RSYSLOG 설정 파일이 존재하지 않습니다."													>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag2="X"
fi
echo " "	 																					>> $HOSTNAME.$DATE.linux.result.txt 2>&1

echo "⑤ Cron 데몬 동작 확인"																	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep 'cron' | grep -v 'grep' | wc -l` -eq 0 ]
then
	echo "Cron Service Disabled"																	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Interview"																	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	ps -ef | grep 'cron' | grep -v 'grep'																	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "																						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result=$flag1":"$flag2                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-112 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
echo "SRV-115 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "###################           로그의 정기적 검토 및 보고 미수행           ###################"
echo "###################           로그의 정기적 검토 및 보고 미수행           ###################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: 로그기록에 대해 정기적 검토, 분석, 리포트 작성 및 보고 등의 절차를 수행하고 있는 경우 양호" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "☞ 담당자 인터뷰 및 증적확인"                                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① 일정 주기로 로그를 점검하고 있는가?"                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "② 로그 점검결과에 따른 결과보고서가 존재하는가?"                                        >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result="Interview"                                                                          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-115 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 

sleep 1
echo "SRV-121 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "############           root 계정의 PATH 환경변수 설정 미흡             ############"
echo "############           root 계정의 PATH 환경변수 설정 미흡             ############" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: Path 설정에 '.', '::' 이 맨 앞이나 중간에 포함되어 있지 않을 경우 양호"           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "☞ PATH 설정 확인"                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo $PATH                                                                                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result="Interview"                                                                          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-121 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
# 24년 개선사항 : UMSAK 022
echo "SRV-122 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "########################           UMASK 설정 미흡            #########################"
echo "########################           UMASK 설정 미흡            #########################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준1: 모든 계정의 UMASK 값이 022이상인 경우 양호"                                          >> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "■ 기준2: 설정파일에 적용된 UMASK 값이 022이상인 경우 양호"                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : (1) sh, ksh, bash 쉘의 경우 /etc/profile 파일 설정을 적용받음"                 >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : (2) 계정별 환경파일에서 umask 설정 확인(결과 파일 하단 확인)"                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① 현재 로그인한 계정의 UMASK 설정 값"                                                   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------"                                        >> $HOSTNAME.$DATE.linux.result.txt 2>&1
umask                                                                                          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "② /etc/profile 파일(권고 설정: UMASK 022)"                                              >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------"                                        >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/profile ]
then
	if [ `cat /etc/profile | grep -i umask | grep -v ^# | wc -l` -gt 0 ]
	then
		cat /etc/profile | grep -A 1 -B 1 -i umask | grep -v ^#                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "umask 설정이 없습니다."                                                          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "/etc/profile 파일이 없습니다."                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "③ 계정별 환경파일 umask 설정값 확인"                                                    >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------"                                        >> $HOSTNAME.$DATE.linux.result.txt 2>&1
HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u | grep -v "#" | grep -v "/tmp" | grep -v "uucppublic" | uniq`
for dir in $HOMEDIRS
do
	if [ -d $dir ]
	then
		echo "☞ $dir 디렉토리 내 환경파일 확인"                        							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		
		if [ -f $dir/.profile ]
		then
			echo " - $dir/.profile 파일 존재, umask 설정값 확인"				       			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo " "                                                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			if [ `cat $dir/.profile | grep "umask" | wc -l` -gt 0 ]
			then
				cat $dir/.profile | grep "umask"                                                 >> $HOSTNAME.$DATE.linux.result.txt 2>&1
				echo " "                                                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			else 
				echo "▶ $dir/.profile내 umask 설정 존재하지 않음(/etc/profile 적용)" 								 >> $HOSTNAME.$DATE.linux.result.txt 2>&1	
				echo " "                                                                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			fi
		fi
		if [ -f $dir/.kshrc ]
		then
			echo " - $dir/.kshrc 파일 존재, umask 설정값 확인"            			            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo " "                                                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			if [ `cat $dir/.kshrc | grep "umask" | wc -l` -gt 0 ]
			then
				cat $dir/.kshrc | grep "umask"                                                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
				echo " "                                                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			else 
				echo "▶ $dir/.kshrc내 umask 설정 존재하지 않음(/etc/profile 적용)" 								 >> $HOSTNAME.$DATE.linux.result.txt 2>&1
				echo " "                                                                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			fi
		fi
		if [ -f $dir/.bashrc ]
		then
			echo " - $dir/.bashrc 파일 존재, umask 설정값 확인"            			            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo " "                                                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			if [ `cat $dir/.bashrc | grep "umask" | wc -l` -gt 0 ]
			then
				cat $dir/.bashrc | grep "umask"                                                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
				echo " "                                                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			else 
				echo "▶ $dir/.bashrc내 umask 설정 존재하지 않음(/etc/profile 적용)" 								 >> $HOSTNAME.$DATE.linux.result.txt 2>&1
				echo " "                                                                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			fi
		fi
		if [ -f $dir/.cshrc ]
		then
			echo " - $dir/.cshrc 파일 존재, umask 설정값 확인"            			            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo " "                                                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			if [ `cat $dir/.cshrc | grep "umask" | wc -l` -gt 0 ]
			then
				cat $dir/.cshrc | grep "umask"                                                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
				echo " "                                                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			else 
				echo "▶ $dir/.cshrc내 umask 설정 존재하지 않음(/etc/profile 적용)" 								 >> $HOSTNAME.$DATE.linux.result.txt 2>&1
				echo " "                                                                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			fi
		fi
		if [ -f $dir/.login ]
		then
			echo " - $dir/.login 파일 존재, umask 설정값 확인"           				        >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo " "                                                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			if [ `cat $dir/.login | grep "umask" | wc -l` -gt 0 ]
			then
				cat $dir/.login | grep "umask"                                                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
				echo " "                                                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			else 
				echo "▶ $dir/.login umask 설정 존재하지 않음(/etc/profile 적용)" 								 >> $HOSTNAME.$DATE.linux.result.txt 2>&1
				echo " "                                                                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			fi
		fi
		if [ -f $dir/.bash_profile ]
		then
			echo " - $dir/.bash_profile 파일 존재, umask 설정값 확인"                			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo " "                                                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			if [ `cat $dir/.bash_profile | grep "umask" | wc -l` -gt 0 ]
			then
				cat $dir/.bash_profile | grep "umask"                                               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
				echo " "                                                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			else 
				echo "▶ $dir/.bash_profile umask 설정 존재하지 않음(/etc/profile 적용)" 								 >> $HOSTNAME.$DATE.linux.result.txt 2>&1
				echo " "                                                                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			fi
		fi
	fi
done
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result="Interview"	                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-122 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
echo "SRV-131 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "###########                   SU 명령 사용가능 그룹 제한 미비               ###########"
echo "###########                   SU 명령 사용가능 그룹 제한 미비               ###########" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준1: /etc/pam.d/su 파일 설정이 아래와 같을 경우 양호"                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■      : (auth  required  /lib/security/pam_wheel.so debug group=wheel) 또는"            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■      : (auth  required  /lib/security/\$ISA/pam_wheel.so use_uid)"                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준2: 위의 설정이 없거나, 주석 처리가 되어 있을 경우 취약" 						   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준3: su 명령어에 others 실행권한이 없고, 특정 그룹만 사용 할 수 있도록 제한 되어있으면 양호" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① /etc/pam.d/su 파일 설정"                                                              >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/pam.d/su ]
then
	if [ `cat /etc/pam.d/su | grep 'pam_wheel.so' | grep -v 'trust' | wc -l` -eq 0 ]
	then
		echo "pam_wheel.so 설정 내용이 없습니다."                                              >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		cat /etc/pam.d/su | grep 'pam_wheel.so' | grep -v 'trust'                              >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "/etc/pam.d/su 파일을 찾을 수 없습니다."                                              >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "② su 파일권한"                                                                          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `which su | grep -v 'no ' | wc -l` -eq 0 ]
then
	echo "su 명령 파일을 찾을 수 없습니다."                                                    >> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	sucommand=`which su`;
	ls -alL $sucommand                                                                         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	sugroup=`ls -alL $sucommand | awk '{print $4}'`;
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "③ su 명령그룹"                                                                          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/pam.d/su ]
then
	if [ `cat /etc/pam.d/su | grep 'pam_wheel.so' | grep -v 'trust' | grep 'group' | awk -F"group=" '{print $2}' | awk -F" " '{print $1}' | wc -l` -gt 0 ]
	then
		pamsugroup=`cat /etc/pam.d/su | grep 'pam_wheel.so' | grep -v 'trust' | grep 'group' | awk -F"group=" '{print $2}' | awk -F" " '{print $1}'`
		echo "- su명령 그룹(PAM모듈): `egrep "^$pamsugroup" /etc/group`"                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		if [ `cat /etc/pam.d/su | grep 'pam_wheel.so' | egrep -v 'trust|#' | wc -l` -gt 0 ]
		then
			echo "- su명령 그룹(PAM모듈): `egrep "^wheel" /etc/group`"                         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		fi
	fi
fi
echo "- su명령 그룹(명령파일): `egrep "^$sugroup" /etc/group`"                                 >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo Result="Interview"      			                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-131 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "  
sleep 1
echo "SRV-133 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "####################           cron 서비스 사용 계정 제한 미비            ####################"
echo "####################           cron 서비스 사용 계정 제한 미비            ####################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: cron.allow, cron.deny 파일 내부에 계정이 존재하는 경우 양호"                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "     : cron.allow, cron.deny 파일 둘 다 없는 경우(root만 cron 사용 가능)양호"            >> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	FILE_CRONUSER="/etc/cron.allow /etc/cron.deny"
	for hfile in $FILE_CRONUSER
	do
	if [ -f $hfile ]; then
		ls -alL $hfile                                                                         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "☞ "$hfile" 파일 하단 설정 확인(설정이 없는 경우 공백)"                          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		cat $hfile  |  sed "s/&/\&amp;/g" |  sed "s/</\&lt;/g" | sed "s/>/\&gt;/g"             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else 
		echo "☞ "$hfile" 파일이 존재하지 않음"                                          	   >> $HOSTNAME.$DATE.linux.result.txt 2>&1	
		echo " "                                                                               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
	done
	
	echo " "                                                                                   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo Result="Interview"          	                                                               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-133 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
echo "SRV-134 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "###################           스택 영역 실행 방지 미설정            ###################"
echo "###################           스택 영역 실행 방지 미설정            ###################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: 스택 영역 실행방지가 설정된 경우 양호"                                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "LINUX는 해당사항 없음(SunOS 해당)"                                                                   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result="N/A"                                                                              >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-134 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
echo "SRV-135 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################           TCP 보안 설정 미비            ########################"
echo "#######################           TCP 보안 설정 미비            ########################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: TCP\_STRONG\_ISS 가 2일 경우 양호"                                               >> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "LINUX는 해당사항 없음(SunOS 해당)"                                                                   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result="N/A"                                                                              >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-135 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "
sleep 1
echo "SRV-142 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "##################           중복 UID가 부여된 계정 존재           ###################"
echo "##################           중복 UID가 부여된 계정 존재           ###################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: 동일한 UID로 설정된 사용자 계정이 존재하지 않는 경우 양호"                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "☞ 동일한 UID를 사용하는 계정 "                                                          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       > total-equaluid.txt
for uid in `cat /etc/passwd | awk -F: '{print $3}'`
do
	cat /etc/passwd | awk -F: '$3=="'${uid}'" { print "UID=" $3 " -> " $1 }'                   > equaluid.txt
	if [ `cat equaluid.txt | wc -l` -gt 1 ]
	then
		cat equaluid.txt                                                                       >> total-equaluid.txt
	fi
done
if [ `sort -k 1 total-equaluid.txt | wc -l` -gt 1 ]
then
	sort -k 1 total-equaluid.txt | uniq -d                                                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "동일한 UID를 사용하는 계정이 발견되지 않았습니다."                                   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "	                                                                                   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-142 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
rm -rf equaluid.txt
rm -rf total-equaluid.txt
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "  
sleep 1
echo "SRV-144 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#############           /dev 경로에 불필요한 파일 존재      		           ##############"
echo "#############           /dev 경로에 불필요한 파일 존재      			       ##############" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준 : /dev 경로에 존재하지 않는 device파일이 없는 경우 양호" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■        : (아래 나열된 결과는 major, minor Number를 갖지 않는 파일임)"                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■        : (.devlink_db_lock/.devfsadm_daemon.lock/.devfsadm_synch_door/.devlink_db는 Default로 존재 예외)" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■        : (mqueue, shm 파일은 시스템에서 생성 또는 삭제가 주기적으로 일어나므로 예외)" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
find /dev -type f -exec ls -l {} \;                                                            > SRV-144.txt

if [ -s SRV-144.txt ]
then
	cat SRV-144.txt                                                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "☞ dev 에 존재하지 않은 Device 파일이 발견되지 않았습니다."                          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result="Interview"                                                                          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-144 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
rm -rf SRV-144.txt
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
echo "SRV-147 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "######################           불필요한 SNMP 서비스 실행            #####################"
echo "######################           불필요한 SNMP 서비스 실행            #####################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: SNMP 서비스를 불필요한 용도로 사용하지 않을 경우 양호"                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
# SNMP서비스는 동작시 /etc/service 파일의 포트를 사용하지 않음.
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `netstat -na | grep ":161 " | grep -i "^udp" | wc -l` -eq 0 ]
then
	echo "☞ SNMP Service Disable"                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo Result="Disabled"                                                                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "☞ SNMP 서비스 활성화 여부 확인(UDP 161)"                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"        >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	netstat -na | grep ":161 " | grep -i "^udp"                                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo Result="Enabled"                                                                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-147 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
#24년 개선 사항 : apache/webtob serverToken 판단 방법 개선
echo "SRV-148 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "####################           웹 서비스 정보 노출                ####################"
echo "####################           웹 서비스 정보 노출                ####################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준1: ServerTokens 지시자로 헤더에 전송되는 정보를 설정한 경우 양호.(ServerTokens Prod 설정인 경우 양호)" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : ServerTokens Prod 설정이 없는 경우 Default 설정(ServerTokens Full)이 적용됨."  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준2: ServerSignature Off로 설정한 경우 양호(serversignature은 웹 브라우저에 버전 정보 노출 여부 정의)" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ ! $apaflag -eq 0 ]
then
	echo "☞ $ACONF 파일 ServerTokens 설정 확인"                                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ `cat $ACONF | grep -i "ServerTokens" | grep -v '\#' | wc -l` -gt 0 ]
	then
		cat $ACONF | grep -i "ServerTokens" | grep -v '\#'                                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "ServerTokens 지시자가 설정되어 있지 않습니다.(취약)"                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
	echo "☞ $ACONF 파일 ServerSignature 설정 확인"                                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ `cat $ACONF | grep -i "ServerSignature" | grep -v '\#' | wc -l` -gt 0 ]
	then
		cat $ACONF | grep -i "ServerSignature" | grep -v '\#'                                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "ServerSignature 지시자가 설정되어 있지 않습니다.(취약)"                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "☞ Apache Service Disable"                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi

# WEBTOB_HOME 코드 추가 필요
# echo "② WebtoB"                                                           					   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
# if [ `ps -ef | grep -i "webtob" | grep -v "grep" | wc -l` -gt 0 ]
# then
	# webtob_command=`which $WEBTOB_HOME`
	# if [-f $webtob_command/http.m ]
	# then
		# cat $webtob_command/http.m | grep -v "^#" | grep -i "ServerTokens" | grep -v "\#"		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	# fi
	# flag1="Interview"
# else
	# echo "☞WEBTOB Service Disabled"																>> $HOSTNAME.$DATE.linux.result.txt 2>&1
# fi

echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-148 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
echo "SRV-158 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "################           불필요한 TELNET 서비스 실행            ################"
echo "################           불필요한 TELNET 서비스 실행            ################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: TELNET 서비스가 동작 중이지 않거나, 업무상 사용 중인 경우 양호"                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① 서비스 포트 확인"                  												   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "①-1 TELNET 확인"                 													   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="telnet" {print $1 "   " $2}' | grep "tcp"                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "①-2 SSH 확인"                  														   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 																						> ssh-result.txt
ServiceDIR="/etc/sshd_config /etc/ssh/sshd_config /usr/local/etc/sshd_config /usr/local/sshd/etc/sshd_config /usr/local/ssh/etc/sshd_config"
for file in $ServiceDIR
do
	if [ -f $file ]
	then
		if [ `cat $file | grep "^Port" | grep -v "^#" | wc -l` -gt 0 ]
		then
			cat $file | grep "^Port" | grep -v "^#" | awk '{print "SSH 설정파일('${file}'): " $0 }'      >> ssh-result.txt
			port1=`cat $file | grep "^Port" | grep -v "^#" | awk '{print $2}'`
			echo " "                                                                                 > port1-search.txt
		else
			echo "SSH 설정파일($file): 포트 설정 X (Default 설정: 22포트 사용)"                      >> ssh-result.txt
		fi
	fi
done
if [ `cat ssh-result.txt | grep -v "^ *$" | wc -l` -gt 0 ]
then
	cat ssh-result.txt | grep -v "^ *$"                                                        >> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "SSH 설정파일: 설정 파일을 찾을 수 없습니다."                                         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "② 서비스 포트 활성화 여부 확인"                                                         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "②-1 TELNET"                                                       					   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="telnet" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="telnet" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"                                          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag1="Enabled"
	else
		echo "☞ Telnet Service Disable"                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag1="Disabled"
	fi
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "②-2 SSH 확인"                                                        				   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f port1-search.txt ]
then
	if [ `netstat -na | grep ":$port1 " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -eq 0 ]
	then
		echo "☞ SSH Service Disable"                                                          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2="Disabled"
	else
		netstat -na | grep ":$port1 " | grep -i "^tcp" | grep -i "LISTEN"                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2="Enabled"
	fi
else
	if [ `netstat -na | grep ":22 " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -eq 0 ]
	then
		echo "☞ SSH Service Disable"                                                          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2="Disabled"
	else
		netstat -na | grep ":22 " | grep -i "^tcp" | grep -i "LISTEN"                          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2="Enabled"
	fi
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result=$flag1":"$flag2                                                                		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-158 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
rm -rf port1-search.txt
rm -rf ssh-result.txt
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
echo "SRV-161 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "###############           ftpusers 파일의 소유자 및 권한 설정 미흡            ################"
echo "###############           ftpusers 파일의 소유자 및 권한 설정 미흡            ################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: ftpusers 파일의 소유자가 root이고, 권한이 640 이하이면 양호"                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : [FTP 종류별 적용되는 파일]"                                                    >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : (1)ftpd: /etc/ftpusers 또는 /etc/ftpd/ftpusers"                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : (2)proftpd: /etc/ftpusers, /etc/ftpd/ftpusers 또는 /etc/proftpd/ftpusers"                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : (3)vsftpd: /etc/vsftpd/ftpusers, /etc/vsftpd/user_list" 						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① /etc/services 파일에서 포트 확인"                                                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service파일:" $1 " " $2}' | grep "tcp" | wc -l` -gt 0 ]
then
	cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service파일:" $1 " " $2}' | grep "tcp" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "(1)/etc/service파일: 포트 설정 X (Default 21번 포트)"                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
if [ -s vsftpd.txt ]
then
	if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP 포트: " $1 "  " $2}' | wc -l` -gt 0 ]
	then
		cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP 포트: " $1 "  " $2}' >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "(2)VsFTP 포트: 포트 설정 X (Default 21번 포트 사용중)"                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "(2)VsFTP 포트: VsFTP가 설치되어 있지 않습니다."                                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
if [ -s proftpd.txt ]
then
	if [ `cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP 포트: " $1 "  " $2}' | wc -l` -gt 0 ]
	then
		cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP 포트: " $1 "  " $2}' >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "(3)ProFTP 포트: 포트 설정 X (/etc/service 파일에 설정된 포트를 사용중)"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "(3)ProFTP 포트: ProFTP가 설치되어 있지 않습니다."                                    >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "② 서비스 포트 활성화 여부 확인"                                                         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
################# /etc/services 파일에서 포트 확인 #################
if [ `cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN"                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                               > ftpenable.txt
	fi
else
	netstat -nat | grep ":21 " | grep -i "^tcp" | grep -i "LISTEN"                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                   > ftpenable.txt
fi
################# vsftpd 에서 포트 확인 ############################
if [ -s vsftpd.txt ]
then
	if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}' | wc -l` -eq 0 ]
	then
		port=21
	else
		port=`cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}'`
	fi
	if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN"                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                               > ftpenable.txt
	fi
fi
################# proftpd 에서 포트 확인 ###########################
if [ -s proftpd.txt ]
then
	port=`cat $profile | grep "Port" | grep -v "^#" | awk '{print $2}'`
	if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	then
		netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN"                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                               > ftpenable.txt
	fi
fi

if [ -f ftpenable.txt ]
then
	rm -rf ftpenable.txt
	flag1="Enabled"

	echo " "                                                                                   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "③ ftpusers 파일 소유자 및 권한 확인 (소유자가 root이고, 파일권한이 640 이하인 경우 양호)"                                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	ServiceDIR="/etc/ftpusers /etc/ftpd/ftpusers /etc/vsftpd/ftpusers /etc/vsftpd.ftpusers /etc/vsftpd/user_list /etc/vsftpd.user_list /etc/proftpd/ftpusers"
	ServiceDIRPath=`echo "$ServiceDIR"`
	for file in $ServiceDIRPath
	do
		if [ -f $file ]
		then
			ls -alL $file                                                                      >> ftpusers.txt
		fi
	done
	if [ `cat ftpusers.txt | wc -l` -gt 0 ]
	then
		cat ftpusers.txt | grep -v "^ *$"                                                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		
	else
		echo "ftpusers 파일을 찾을 수 없습니다. (FTP 서비스 동작 시 취약)"                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag2="F"
	fi
else
	echo "☞ FTP Service Disable"                                                              >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag1="Disabled"
	flag2="Disabled"
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result=$flag1":"$flag2                                                                		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-161 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
rm -rf ftpusers.txt
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
# 24년 개선 사항 : /etc/ssh/sshd_config 파일 확인
echo "SRV-163 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "##################           시스템 사용 주의사항 미출력            ###################"
echo "##################           시스템 사용 주의사항 미출력            ###################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: /etc/issue.net, /etc/motd, /etc/ssh/sshd_config 파일에 로그온 시스템 사용 주의사항 등의 안내(경고) 문구가 설정되어 있을 경우 양호"  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ [참고] : /etc/motd > 로그인이 끝났을 때 접속 된 후 출력되는 내용(Telnet, SSH)"						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■		: /etc/issue.net > 외부에서 원격접속 시도할 때 출력되는 내용(Telnet)"							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■		: /etc/issue > 로컬 콘솔에서 직접 접속할때 출력되는 내용"										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■		: /etc/ssh/sshd_config > SSH 접속 시도 할때 출력되기 위해서는 Banner 경로 추가해줘야 주의사항 출력됨"	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① /etc/motd 파일 설정: "                                                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/motd ]
then
	if [ `cat /etc/motd | grep -v "^ *$" | wc -l` -gt 0 ]
	then
		cat /etc/motd | grep -v "^ *$"                                                         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "경고 메시지 설정 내용이 없습니다.(취약)"                                         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "/etc/motd 파일이 없습니다."                                                          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "② /etc/issue.net 파일 설정: "                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/issue.net ]
then
	if [ `cat /etc/issue.net | grep -v "^#" | grep -v "^ *$" | wc -l` -gt 0 ]
	then
		cat /etc/issue.net | grep -v "^#" | grep -v "^ *$"                                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "경고 메시지 설정 내용이 없습니다.(취약)"                                         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "/etc/issue.net 파일이 없습니다."                                                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "● /etc/services 파일에서 포트 확인"                                                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "-------------------------------------------------------------"                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="telnet" {print $1 "   " $2}' | grep "tcp"                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "● 서비스 포트 활성화 여부 확인"                                                          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "-------------------------------------------------------------"                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="telnet" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="telnet" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN"                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "☞ Telnet Service Disable"                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "③ /etc/ssh/sshd_config 파일 설정 "                                                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/ssh/sshd_config ]
then
	if [ `cat /etc/ssh/sshd_config | grep -i "banner" | wc -l` -gt 0 ]
	then
		cat /etc/ssh/sshd_config | grep -i "banner"                                                         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "경고 메시지 설정 내용이 없습니다.(취약)"                                         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "/etc/ssh/sshd_config 파일이 없습니다."                                                          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "④ [참고] /etc/issue 파일 설정(로컬 접속 시):"                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "-------------------------------------------------------------"                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/issue ]
then
	if [ `cat /etc/issue | grep -v "^#" | grep -v "^ *$" | wc -l` -gt 0 ]
	then
		cat /etc/issue | grep -v "^#" | grep -v "^ *$"                                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "경고 메시지 설정 내용이 없습니다.(취약)"                                         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "/etc/issue 파일이 없습니다."                                                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi	
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-163 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
# 24년 개선 사항 : /etc/passwd, /etc/group 비교, /etc/group 파일 내 신규 그룹이 생성되는 GID를 중점적으로 점검, 그룹 삭제 시 그룹 권한이 부여된 파일 또는 디렉토리 존재 여부 확인
echo "SRV-164 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#################           구성원이 존재하지 않는 GID 존재            ##################"
echo "#################           구성원이 존재하지 않는 GID 존재            ##################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: 구성원이 존재하지 않는 GID가 존재하지 않는 경우 양호"                        >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "☞ 구성원이 존재하지 않는 그룹"                                                          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	for gid in `awk -F: '$4==null {print $3}' /etc/group`
	do
		if [ `awk -F: '{print $3}' /etc/passwd |grep -w -c $gid` -eq 0  ]
		then
			grep -w $gid /etc/group                                                               >> nullgid.txt
		fi		
	done

if [ `cat nullgid.txt | wc -l` -eq 0 ]
then
		echo "구성원이 존재하지 않는 그룹이 발견되지 않았습니다."                              >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo Result=0 	                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
		cat nullgid.txt                                                                        >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo Result=`cat nullgid.txt | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-164 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
rm -rf nullgid.txt
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "  
sleep 1
echo "SRV-165 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "########################           불필요하게 Shell이 부여된 계정 존재             #######################"
echo "########################           불필요하게 Shell이 부여된 계정 존재             #######################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: 로그인이 필요하지 않은 시스템 계정에 /bin/false(nologin) 쉘이 부여되어 있으면 양호" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "[참고]: 일반적으로 Deamon 실행을 위한 계정은 Shell이 불필요(예, ftp, apache, www-data 등)" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "☞ /bin/false(nologin)이 부여되어 있지 않은 계정(확인 필요)"                                              >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/passwd ]
then
	cat /etc/passwd | egrep -v "false|nologin" 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                                    >> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
    echo "/etc/passwd 파일이 없습니다."                                                        >> $HOSTNAME.$DATE.linux.result.txt 2>&1
    echo Result=0                                                                              >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-165 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "  
echo " "  
sleep 1
echo "SRV-166 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "##############           불필요한 숨김 파일 또는 디렉터리 존재            ##############"
echo "##############           불필요한 숨김 파일 또는 디렉터리 존재            ##############" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: 불필요한 숨김 파일이 존재하지 않을 경우 양호" 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
find /tmp -name ".*" -ls                                                                       > tempSRV-166.txt
find /home -name ".*" -ls                                                                      >> tempSRV-166.txt
find /usr -name ".*" -ls                                                                       >> tempSRV-166.txt
find /var -name ".*" -ls                                                                       >> tempSRV-166.txt

if [ -s tempSRV-166.txt ]
then
  linecount=`cat tempSRV-166.txt | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
	if [ $linecount -gt 10 ]
	then
		echo "숨겨진 파일 (상위 10개)"                                                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		head -10 tempSRV-166.txt                                                              >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                                   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " 등 총 "$linecount"개 파일 존재 (전체 목록은 스크립트 결과 파일  확인)"              >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " " 		                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	else
		echo "숨겨진 파일"                                                                 >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		cat tempSRV-166.txt                                                                   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " 총 "$linecount"개 파일 존재"                                                        >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                                                                               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " " 		                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
    echo "☞ 숨겨진 파일이 발견되지 않았습니다."                         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
    echo " "                                                                                   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo " "                                                                               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo "SRV-166 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
#24년 개선 사항 : 판단 방법 설명 및 코드 개선
echo "SRV-170 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "##############           SMTP 서비스 정보 노출             ##############"
echo "##############           SMTP 서비스 정보 노출             ##############" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: SMTP 접속 배너에 노출되는 정보가 없는 경우 양호" 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① /etc/mail/sendmail.cf 파일 설정"                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/mail/sendmail.cf ]
then
	echo "☞ /etc/mail/sendmail.cf  파일" 																>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	cat /etc/mail/sendmail.cf | grep -i "GreetingMessage"         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "/etc/mail/sendmail.cf  파일이 없습니다."                                                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi

echo " "                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "② /etc/postfix/main.cf 파일 설정"                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/postfix/main.cf ]
then
	echo "☞ /etc/postfix/main.cf  파일"														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	cat /etc/postfix/main.cf | egrep -i "smtpd_banner|smtp_banner" | grep -v "^#"											>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "/etc/postfix/main.cf 파일이 없습니다."												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi

echo " "                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "③ /etc/exim/exim.conf 파일 설정"                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#ex_banner="/etc/exim*/exim*.conf.template /etc/exim*/exim*.conf /etc/exim*/conf.d/*.conf"
#ex_banner1=`echo "$ex_banner"`
#for exim_dir in $(echo "$ex_banner")
#do
if [ -f /etc/exim*/exim*.conf.template ]
then
	echo "☞ /etc/exim*/exim*.conf.template  파일"														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	cat /etc/exim*/exim*.conf.template | egrep -i "smtp_banner|smtpd_banner"	| grep -v "^#"										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	
elif [ -f /etc/exim*/exim*.conf ]
then
	echo "☞ /etc/exim*/exim*.conf  파일"														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	cat /etc/exim*/exim*.conf | egrep -i "smtp_banner|smtpd_banner"	| grep -v "^#"										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	
elif [ -f /etc/exim*/conf.d/*.conf ]
then
	echo "☞ /etc/exim*/conf.d/*.conf  파일"														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	cat /etc/exim*/conf.d/*.conf | egrep -i "smtp_banner|smtpd_banner"	| grep -v "^#"										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	
else
	echo "/etc/exim*/exim*.conf.template /etc/exim*/exim*.conf /etc/exim*/conf.d/*.conf 파일이 없습니다."												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
#done
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-170 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1

echo "SRV-171 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "##############           FTP 서비스 정보 노출             ##############"
echo "##############           FTP 서비스 정보 노출             ##############" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: FTP 접속 배너에 노출되는 정보가 없는 경우 양호" 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "● /etc/services 파일에서 포트 확인:"                                                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "-------------------------------------------------------------"                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp"                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "● 서비스 포트 활성화 여부 확인:"                                                         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "-------------------------------------------------------------"                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port" | grep -i "LISTEN" | head -1 | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port" | grep -i "LISTEN" | head -1                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo " "                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "● FTP 서비스 파일 설정 확인 (/etc/ftpd/ftpaccess, */proftpd.conf, */vsftpd.conf)"                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "--------------------------------------------------------------------------------"                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		if [ -f /etc/ftpd/ftpaccess ]
		then
			if [ `cat /etc/ftpd/ftpaccess | grep -i "greeting" | grep -v "^#" | wc -l` -gt 0 ]
			then
				echo -e "/etc/ftpd/ftpaccess 파일 내용 \n `cat /etc/ftpd/ftpaccess | grep -i 'greeting' | grep -v '^#'`"                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
				echo " "                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			else
				echo "☞ /etc/ftpd/ftpaccess 파일에 greeting 설정이 존재하지 않습니다."                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
				echo " "                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			fi
		else
			echo "☞ /etc/ftpd/ftpaccess 파일이 존재하지 않습니다."                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo " "                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		fi
		
		if [ `find / -type f -name "proftpd.conf" 2>/dev/null | wc -l` -gt 0 ]
		then
			proftp_file=`find / -type f -name "proftpd.conf" 2>/dev/null`
			for proftp in $proftp_file
			do
				if [ `cat $proftp | grep -i "ServerIdent" | grep -v "^#" | wc -l` -gt 0 ]
				then
					echo -e "$proftp 파일 내용 \n `cat $proftp | grep -i 'ServerIdent' | grep -v '^#'`" 			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
					echo " "                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				else
					echo "☞ $proftp 파일에 ServerIdent 설정이 존재하지 않습니다."			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
					echo " "                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				fi
			done
		else
			echo "☞ proftpd.conf 파일이 존재하지 않습니다."			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo " "                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		fi
		
		if [ `find / -type f -name "vsftpd.conf" 2>/dev/null | wc -l` -gt 0 ]
		then
			vsftp_file=`find / -type f -name "vsftpd.conf" 2>/dev/null`
			for vsftp in $vsftp_file
			do
				if [ `cat $vsftp | grep -i "banner" | grep -v "^#" | wc -l` -gt 0 ]
				then
					echo -e "$vsftp 파일 내용 \n `cat $vsftp | grep -i 'banner' | grep -v '^#'`"			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
					echo " "                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				else
					echo "☞ $vsftp 파일에 ftpd_banner 설정이 존재하지 않습니다."			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
					echo " "                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
				fi
			done
		else
			echo "☞ vsftpd.conf 파일이 존재하지 않습니다." 			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
			echo " "                           										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		fi

		
		flag1="Interview"
		
	else
		echo "☞ FTP Service Disable"                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		flag1="Disabled"
	fi
fi
# 코드 개선으로 주석처리
# echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
# echo "● /etc/vsftpd.conf 파일 설정:"                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
# echo "-------------------------------------------------------------"                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
# if [ -f /etc/vsftpd.conf ]
# then
	# if [ `cat /etc/vsftpd.conf | grep -i "banner" | grep -v "^#" | wc -l` -gt 0 ]
	# then
		# cat /etc/default/telnetd | grep -i "banner" | grep -v "^#"                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	# else
		# echo "BANNER 설정내용이 없습니다.(취약)"                                               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	# fi
# else
	# echo "/etc/vsftpd.conf 파일이 없습니다.(취약)"                                         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
# fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo Result=$flag1     																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1													


echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-171 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 

sleep 1
echo "SRV-173 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "##############           DNS 서비스의 취약한 동적 업데이트 설정             ##############"
echo "##############           DNS 서비스의 취약한 동적 업데이트 설정             ##############" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: DNS 서비스의 동적 업데이트 기능이 비활성화 되었거나, 활성화 시 적절한 접근통제를 수행하고 있을 경우 양호" 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo 
echo "/etc/named.conf 내부의 allow-update 또는 update-policy 존재 구문 확인"					>> $HOSTNAME.$DATE.linux.result.txt 2>&1

if [ -f /etc/bind/named.conf ]
then
	echo "☞ /etc/bind/named.conf 파일" 																>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	cat /etc/bind/named.conf | grep -i "update"         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "/etc/bind/named.conf 파일이 없습니다."                                                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi

echo "##################################################"


if [ -f /etc/named.conf ]
then
	echo "☞ /etc/named.conf 파일" 																>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	cat /etc/named.conf | grep -i "update"         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "/etc/named.conf 파일이 없습니다."                                                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi

echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-173 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 

sleep 1
echo "SRV-174 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "##############           불필요한 DNS 서비스 실행             ##############"
echo "##############           불필요한 DNS 서비스 실행             ##############" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: DNS 서비스가 실행 중이지 않거나, 필요에 의해 사용 중인 경우 양호" 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① DNS 프로세스 확인 " 																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep -i "named" | grep -v "grep" | wc -l` -eq 0 ]
then
	echo "☞ DNS Service Disable"                                                              >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag="Disabled"
else
	ps -ef | grep -i "named" | grep -v "grep"                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	flag="Interview"
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "② /etc/services 파일에서 포트 확인"                                                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `cat /etc/services | awk -F" " '$1=="domain" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="domain" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		echo "☞ DNS Service Enable"   													>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		netstat -na | grep ":$port " | grep -i "^tcp"                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		if [ `cat /etc/services | awk -F" " '$1=="domain" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
		then
			port=`cat /etc/services | awk -F" " '$1=="domain" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
				if [ `netstat -na | grep ":$port " | grep -i "^udp" | wc -l` -gt 0 ]
				then
					netstat -na | grep ":$port " | grep -i "^udp"                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
				fi
		fi
	else
		echo "☞ DNS Service Disable"   													>> $HOSTNAME.$DATE.linux.result.txt 2>&1		
	fi
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-174 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
#24년 개선 사항 : Chronyc 확인 추가
echo "SRV-175 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "##############           NTP 및 시각 동기화 미설정             ##############"
echo "##############           NTP 및 시각 동기화 미설정             ##############" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: NTP 서버 동기화가 설정되어 있는 경우 양호" 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1

if [ -f /etc/ntp.conf ]
then
	echo "☞ /etc/ntp.conf 파일" 																>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	cat /etc/ntp.conf |grep -v "#"         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "/etc/ntp.conf 파일이 없습니다."                                                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "ntp 명령어 확인"																	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	ntp -q 																					>> $HOSTNAME.$DATE.linux.result.txt 2>&1					
	ntpq -pn																					>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi

if [ -f /etc/chrony.conf ]
then
	echo "☞ /etc/chrony.conf 파일"        												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	cat /etc/chrony.conf | grep -v "#"         												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
elif [ -f /etc/chrony/chrony.conf ]
then
	echo "☞ /etc/chrony/chrony.conf 파일"        												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	cat /etc/chrony/chrony.conf | grep -v "#"         												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "/etc/chrony.conf 파일이 없습니다."                                                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-175 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 
sleep 1
#24년 개선 사항 : SNMP 버전 확인
echo "SRV-176 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "##############           취약한 SNMP 버전을 사용             ##############"
echo "##############           취약한 SNMP 버전을 사용             ##############" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: SNMPv3 버전을 사용하는 경우 양호" 									>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① SNMP 서비스 활성화 여부 확인(UDP 161)"                                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `netstat -na | grep ":161 " | grep -i "^udp" | wc -l` -eq 0 ]
then
	echo "☞ SNMP Service Disable"                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	netstat -na | grep ":161 " | grep -i "^udp"                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "② SNMP 서비스 버전 확인"                                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `netstat -na | grep ":161 " | grep -i "^udp" | wc -l` -eq 0 ]
then
	echo "☞ SNMP Service Disable"                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	snmpwalk -v 2c -c public localhost                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#	snmpget --version                                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi

echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-176 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " " 



echo " " 
echo "#############################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#############################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "##############################        5.3.3. 사용자 인증        #############################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#############################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#############################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
sleep 1
echo "SRV-069 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#####################           비밀번호 관리정책 설정 미비            #####################"
echo "#####################           비밀번호 관리정책 설정 미비            #####################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준1: /etc/login.defs 파일 내에 다음 항목들이 설정되어 있을 경우 양호"            	   >> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "* PASS\_MAX\_DAYS, PASS\_MIN\_DAYS, PASS\_MIN\_LEN, PASS\_WARN\_AGE "                    >> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "■ 기준2: /etc/pam.d/system-auth 또는 /etc/security/pwquality.conf 파일 내에 다음 항목들이 설정되어 있을 경우 양호" >> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "* minlen, dcredit, ucredit, lcredit, ocredit, minclass"                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo " 정책 기준 : 영문, 숫자, 특수문자 2개 조합시 10자리 이상, 3개 조합 시 8자리 이상, 패스워드 변경 기간 90일 이하"			>> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① RPM기반 시스템(Redhat, CentOS 등)" 														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/login.defs ]
then
	echo "☞ /etc/login.defs 파일" 																>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	cat /etc/login.defs | egrep "PASS_MAX_DAYS|PASS_MIN_DAYS|PASS_MIN_LEN|PASS_WARN_AGE"         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "/etc/login.defs 파일이 없습니다."                                                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/pam.d/system-auth ]
then
	echo "☞ /etc/pam.d/system-auth 파일" 																>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	cat /etc/pam.d/system-auth | egrep "pam_cracklib.so"                                         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ `cat /etc/pam.d/system-auth | egrep "pam_cracklib.so" | wc -l` -eq 0  ]
	then
		cat /etc/pam.d/system-auth | egrep "pam_pwquality.so"                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "/etc/pam.d/system-auth 파일이 없습니다."                                               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/security/pwquality.conf ]
then
	echo "☞ /etc/security/pwquality.conf 파일" 													>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	cat /etc/security/pwquality.conf | egrep "minlen|dcredit|ucredit|lcredit|ocredit|minclass"   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "/etc/security/pwquality.conf 파일이 없습니다."                                         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "② DEB기반 시스템(Debian 등)" 														>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/pam.d/common-password ]
then
	cat /etc/pam.d/common-password                                          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
	echo "/etc/pam.d/common-password 파일이 없습니다."                                               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result="Interview"          	                                                                   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-069 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
sleep 1
# 24년 개선 사항: 비활성화된 계정 제외
echo "SRV-074 START"                                                                           	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "########################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#################           불필요하거나 관리되지 않는 계정 존재           ##################"
echo "#################           불필요하거나 관리되지 않는 계정 존재           ##################" 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: 분기별 1회 이상 로그인 한 기록이 있고, 비밀번호를 변경하고 있는 경우 양호"  					>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① PASS_MAX_DAYS 설정" 												   					>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
grep "PASS_MAX_DAYS" /etc/login.defs | grep -v "#" 							   					>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "② /etc/passwd 로그인 할 수 있는 계정 목록(사용자 계정 위주 확인)" 						   		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/shadow ]
then
	for user in $(cat /etc/shadow | grep -Ev '\!|\*' | awk -F: '{print $1}')
	do
		shell=`cat /etc/passwd | grep "$user" | awk -F: '{print $7}'`
		if [ "$shell" != "/sbin/nologin|/bin/false" ]
		then
			echo $user																			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		fi
	done
fi
echo " "                                                                                       	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "③ /etc/passwd 로그인 할 수 있는 계정 별 비밀번호 정보" 										>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "(계정명/패스워드상태/최근 패스워드 변경일자/패스워드 변경까지 최소 일자/패스워드 변경까지 최대 일자/패스워드 만료를 알리는 경고 기간/만료되고 비번이 잠기기까지의 유예기간)" 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "(패스워드상태란 : 패스워드 잠김(L 혹은 LK), 패스워드 없음(NP), 사용가능한 패스워드(P 혹은 PS))" 		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/shadow ]
then
	for user in $(cat /etc/shadow | grep -Ev '\!|\*' | awk -F: '{print $1}')
	do
		shell=`cat /etc/passwd | grep "$user" | awk -F: '{print $7}'`
		if [ "$shell" != "/sbin/nologin|/bin/false" ]
		then
			passwd -S $user													 					>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		fi
	done
fi
echo " "                                                                                       	>> $HOSTNAME.$DATE.linux.result.txt 2>&1	
echo "④ /etc/passwd 로그인 할 수 있는 계정 별 로그인 기록" 						   					>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/shadow ]
then
	for user in $(cat /etc/shadow | grep -Ev '\!|\*' | awk -F: '{print $1}')
	do
		shell=`cat /etc/passwd | grep "$user" | awk -F: '{print $7}'`
		if [ "$shell" != "/sbin/nologin|/bin/false" ]
		then
			lastlog -u $user | grep -vi "username" 													>> $HOSTNAME.$DATE.linux.result.txt 2>&1		      		
		fi
	done
fi
echo " "                                                                                       	>> $HOSTNAME.$DATE.linux.result.txt 2>&1	
echo "SRV-074 END"                                                                             	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "  

sleep 1
echo "SRV-075 START"                                                                           	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "######################################################################################" 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "####################           유추가능한 계정 비밀번호 존재           ###################"
echo "####################           유추가능한 계정 비밀번호 존재           ###################" 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "######################################################################################" 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: 시스템의 모든 계정이 비밀번호 복잡도를 만족하는 경우 양호"                         		>> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "■      - 복잡도 : 영문, 숫자, 특수문자 2개 조합시 10자리 이상, 3개 조합시 8자리 이상(계정명, 기관명이 포함된 경우 취약)"      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "☞ 담당자 인터뷰 확인"                                                            			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① 시스템에 존재하는 사용자 계정의 경우 비밀번호 복잡도를 만족하고 있는가?"                          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "② 주기적으로 사용자 계정의 비밀번호를 변경하고 있는가?"                                        	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " [참고] /etc/shadow 파일"                                                            		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/shadow 				         												       	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result="Interview"          	                                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-075 END"                                                                             	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" 	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "  
sleep 1
# 24년 개선 사항 : RHEL8 faillock.conf 확인
echo "SRV-127 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "######################           계정 잠금 임계값 설정 미비            #####################"
echo "######################           계정 잠금 임계값 설정 미비            #####################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: /etc/pam.d/system-auth(common-auth), /etc/pam.d/password-auth, /etc/security/faillock.conf 파일에 아래와 같은 설정이 있으면 양호"       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ [참고]: /etc/pam.d/system-auth : 콘솔을 통한 로그인, su전환일 경우 /etc/pam.d/password-auth : ssh 원격 접속, vsftpd 등"		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "(1) pam_faillock.so 활용 시" 															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : (auth required  pam_faillock.so preauth silent audit deny=5 unlock_time=600)" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : (auth [default=die] pam_faillock.so authfail audit deny=5 unlock_time=600)" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : (account required  pam_faillock.so)"             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "(2) pam_tally2.so 활용 시" 															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : (auth required pam_tally2.so deny=5 unlock_time=600)" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : (account required pam_tally2.so)"             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "(3) pam_tally.so 활용 시" 															>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : (auth required pam_tally.so deny=5 unlock_time=600)" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■       : (account required pam_tally.so)"             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■(4) RHEL 8 경우"																		>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "		  : /etc/security/faillock.conf 우선 적용"												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "		  : deny = 5, unlock_time = 600"												>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① Server 패치 정보 확인"                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "☞ version Check"                                    	                                  	>> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/redhat-release																			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "																						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "② 계정 잠금 임계값 설정 확인"																>> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/pam.d/system-auth ]
then
	echo " "                                                                                   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "☞ /etc/pam.d/system-auth 파일 설정(auth, account)"                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	egrep "auth|account" /etc/pam.d/system-auth                                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1

else	
	if [ -f /etc/pam.d/common-auth ]
	then
		echo " "                                                                               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "☞ /etc/pam.d/common-auth 파일 설정(auth, account, include)"                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		egrep "auth|account|include" /etc/pam.d/common-auth | grep -v "#"                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
fi
if [ -f /etc/pam.d/password-auth ]
then
	echo " "                                                                                   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "☞ /etc/pam.d/password-auth 파일 설정(auth, account)"                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	egrep "auth|account" /etc/pam.d/password-auth                                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1

else	
	if [ -f /etc/pam.d/common-auth ]
	then
		echo " "                                                                               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "☞ /etc/pam.d/common-auth 파일 설정(auth, account, include)"                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		echo "------------------------------------------------------------------------------"  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		egrep "auth|account|include" /etc/pam.d/common-auth | grep -v "#"                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
fi
if [ -f /etc/security/faillock.conf ]
then
	echo " "
	echo "☞ /etc/security/faillock.conf 파일 설정(deny, unlock_time)"							>> $HOSTNAME.$DATE.linux.result.txt
	echo "------------------------------------------------------------------------------"      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	egrep "deny|unlock_time" /etc/security/faillock.conf | grep -v "#"							>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "☞ /etc/pam.d/sshd 파일 설정(auth, account)"                                         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
egrep "auth|account|include" /etc/pam.d/sshd | grep -v "#"                                 >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result="Interview"      			                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1

echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-127 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "  

echo " " 
echo "#############################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#############################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "##############################        5.3.4. 패치 관리        ###############################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#############################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#############################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
sleep 1
# 24년 개선 사항: Jeus 프로세스 확인 및 version 출력
echo "SRV-118 START"                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "###############           주기적인 보안패치 및 벤더 권고사항 미적용            ##############"
echo "###############           주기적인 보안패치 및 벤더 권고사항 미적용            ##############" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 기준: 패치 적용 정책을 수립하여 주기적으로 패치를 관리하고 있을 경우 양호"             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "■ 현황"                                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "① Server 패치 정보 확인"                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "☞ version Check"                                    	                                  	   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/redhat-release																					   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "☞ uname -a"                                    	                                  	   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
uname -a 																					   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "☞ lsb_release -a(해당 패키지 설치할 경우 출력됨)"                                    	           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
lsb_release -a 																				   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1

echo "② JEUS 버전 및 상세 버전 정보 확인"                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ `ps -ef | grep -i "jeus" | grep -v "grep" | wc -l` -gt 0 ]
then
	jeusadmin -version                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	jeusadmin -fullversion                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "③ JEUS 패치 정보 확인"                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "------------------------------------------------------------------------------"                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	if [ -f $JEUS_HOME/lib]
	then
		ls $JEUS_HOME/lib/jext 																>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		ls $JEUS_HOME/lib/jnext																>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		ls $JEUS_HOME/lib/jlext																>> $HOSTNAME.$DATE.linux.result.txt 2>&1
		ls $JEUS_HOME/lib/jbext																>> $HOSTNAME.$DATE.linux.result.txt 2>&1
	fi
else
	echo "JEUS Service Disabled"																			>> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi

echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo Result="Interview"                                                                          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "SRV-118 END"                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=======================================================================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
rm -rf proftpd.txt
rm -rf vsftpd.txt
echo "***************************************** END *****************************************" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
date                                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "***************************************** END *****************************************"

echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "@@FINISH"                                                                        	       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1     
echo "#################################   Process Status   ##################################"
echo "#################################   Process Status   ##################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "END_RESULT"                                                                              >> $HOSTNAME.$DATE.linux.result.txt 2>&1


echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=========================== System Information Query Start ============================"
echo "=========================== System Information Query Start ============================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "###############################  Kernel Information  ##################################"
echo "###############################  Kernel Information  ##################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
uname -a                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "################################## IP Information #####################################"
echo "################################## IP Information #####################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
ifconfig -a                                                                                    >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "################################   Network Status   ###################################"
echo "################################   Network Status   ###################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
sleep 1
netstat -an | egrep -i "LISTEN|ESTABLISHED"                                                    >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#############################   Routing Information   #################################"
echo "#############################   Routing Information   #################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
sleep 1
netstat -rn                                                                                    >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "################################   Process Status   ###################################"
echo "################################   Process Status   ###################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
sleep 1
ps -ef                                                                                         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "###################################   User Env   ######################################"
echo "###################################   User Env   ######################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
env                                                                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "=========================== System Information Query End =============================="
echo "=========================== System Information Query End ==============================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
sleep 1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "[참고] /etc/passwd, /etc/security/passwd, /etc/shadow 파일 내용"                         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/passwd ]
then
    echo "① /etc/passwd 파일"                                                                 >> $HOSTNAME.$DATE.linux.result.txt 2>&1
    cat /etc/passwd                                                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
    echo "/etc/passwd 파일이 없습니다."                                                        >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/security/passwd ]
then
    echo "② /etc/security/passwd 파일"                                                        >> $HOSTNAME.$DATE.linux.result.txt 2>&1
    cat /etc/security/passwd                                                                   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
else
    echo "/etc/security/passwd 파일이 없습니다."                                               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
if [ -f /etc/shadow ]
then
    echo "③ /etc/shadow 파일"                                                                 >> $HOSTNAME.$DATE.linux.result.txt 2>&1
    cat /etc/shadow                                                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1

sleep 1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "[참고] /etc/security/user 파일 내용"                        							   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	cat /etc/security/user                                                                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
sleep 1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "[참고] /etc/group 파일"                                                                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat /etc/group                                                                                 >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "#######################################################################################" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
sleep 1
echo "[참고] 소유자가 존재하지 않는 파일 전체 목록"                                    >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat SRV-095.txt                                                                        >> $HOSTNAME.$DATE.linux.result.txt 2>&1
rm -rf SRV-095.txt
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1		
sleep 1		
echo "[참고] SUID,SGID,Sticky bit 설정 파일 전체 목록"                                 >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat SRV-091.txt                                                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
rm -rf SRV-091.txt
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1    
sleep 1    
echo "[참고] World Writable 파일 전체 목록"                                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "------------------------------------------------------------------------------"  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat world-writable.txt                                                                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
rm -rf world-writable.txt
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1 
echo "[참고] 숨겨진 파일 전체 목록"                                                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
sleep 1
echo "------------------------------------------------------------------------------"  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
cat tempSRV-166.txt                                                                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
rm -rf tempSRV-166.txt
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1 
sleep 1
echo "[참고] 사용자 별 profile 내용"                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo ": 사용자 profile 또는 profile 내 TMOUT 설정이 없는 경우 결과 없음 (/etc/profile을 따름)" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "-----------------------------------------------"                                         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1

awk -F: '{print $1 ":" $6}' /etc/passwd > profilepath.txt

for result in `cat profilepath.txt`
do
	echo $result > tempfile.txt
	var=`awk -F":" '{print $2}' tempfile.txt`

	if [ $var = "/" ]
	then
		if [ `ls -f / | grep "^\.profile$" | wc -l` -gt 0 ]
		then
			filename=`ls -f / | grep "^\.profile$"`

			if [ `grep -i TMOUT /$filename | grep -v "^#" | wc -l` -gt 0 ]
			then
				awk -F":" '{print $1}' tempfile.txt                                                    >> $HOSTNAME.$DATE.linux.result.txt 2>&1
				echo "-----------------------------------------------"                                 >> $HOSTNAME.$DATE.linux.result.txt 2>&1
				grep -i TMOUT /$filename | grep -v "^#"	                                               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
				echo " "                                                                               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
# 사용자 profile이 존재하는 경우만 출력하기 위해 주석 처리
#			else
#				awk -F":" '{print $1}' tempfile.txt                                              >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#                         	echo "----------------------------------------"                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#                         	echo $filename"에 TMOUT 설정이 존재하지 않음"                        >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#				echo " "                                                                         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			fi
#		else
#                        awk -F":" '{print $1}' tempfile.txt                                     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#                        echo "----------------------------------------"                         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#                        echo "사용자 profile 파일이 존재하지 않음"                              >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#			echo " "                                                                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		fi
	else
		pathname=`awk -F":" '{print $2}' tempfile.txt`
				if [ -f $pathname ]
				then
                if [ `ls -f $pathname | grep "^\.profile$" | wc -l` -gt 0 ]
                then
                        filename = `ls -f $pathname | grep "^\.profile$"`

                        if [ `grep -i TMOUT $pathname/$filename | grep -v "^#" | wc -l` -gt 0 ]
                        then
                                awk -F":" '{print $1}' tempfile.txt                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
                                echo "----------------------------------------"                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
                                grep -i TMOUT $pathname/$filename | grep -v "^#"               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
                                echo " "                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
# 사용자 profile이 존재하는 경우만 출력하기 위해 주석 처리
#                        else
#                                awk -F":" '{print $1}' tempfile.txt                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#                                echo "----------------------------------------"                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#                                echo $filename"에 TMOUT 설정이 존재하지 않음"                  >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#                                echo " "                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
                        fi
#                else
#                        awk -F":" '{print $1}' tempfile.txt                                    >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#                        echo "----------------------------------------"                        >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#                        echo "사용자 profile 파일이 존재하지 않음"                             >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#                        echo " "                                                               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
						fi
				fi				 
	fi
done
rm -rf tempfile.txt

echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1

echo "[참고] 사용자 별 profile 내용"                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo ": 사용자 profile 또는 profile 내 UMASK 설정이 없는 경우 결과 없음 (/etc/profile을 따름)" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "-----------------------------------------------"                                         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1

for result in `cat profilepath.txt`
do
	echo $result > tempfile.txt
	var=`awk -F":" '{print $2}' tempfile.txt`

	if [ $var = "/" ]
	then
		if [ `ls -f / | grep "^\.profile$" | wc -l` -gt 0 ]
		then
			filename=`ls -f / | grep "^\.profile$"`

			if [ `grep -i umask /$filename | grep -v "^#" | wc -l` -gt 0 ]
			then
				awk -F":" '{print $1}' tempfile.txt                                                    >> $HOSTNAME.$DATE.linux.result.txt 2>&1
				echo "-----------------------------------------------"                                 >> $HOSTNAME.$DATE.linux.result.txt 2>&1
				grep -A 1 -B 1 -i umask /$filename | grep -v "^#"	                                   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
				echo " "                                                                               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
# 사용자 profile이 존재하는 경우만 출력하기 위해 주석 처리
#			else
#				awk -F":" '{print $1}' tempfile.txt                                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#                         	echo "----------------------------------------"                    >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#                         	echo $filename"에 UMASK 설정이 존재하지 않음"                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#				echo " "                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
			fi
#		else
#                        awk -F":" '{print $1}' tempfile.txt                                   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#                        echo "----------------------------------------"                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#                        echo "사용자 profile 파일이 존재하지 않음"                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#			echo " "                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		fi
	else
		pathname=`awk -F":" '{print $2}' tempfile.txt`
					if [ -f $pathname ]
					then
                if [ `ls -f $pathname | grep "^\.profile$" | wc -l` -gt 0 ]
                then
                        filename = `ls -f $pathname | grep "^\.profile$"`

                        if [ `grep -i umask $pathname/$filename | grep -v "^#" | wc -l` -gt 0 ]
                        then
                                awk -F":" '{print $1}' tempfile.txt                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
                                echo "----------------------------------------"                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
                                grep -A 1 -B 1 -i umask $pathname/$filename | grep -v "^#"     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
                                echo " "                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
# 사용자 profile이 존재하는 경우만 출력하기 위해 주석 처리
#                        else
#                                awk -F":" '{print $1}' tempfile.txt                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#                                echo "----------------------------------------"               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#                                echo $filename"에 UMASK 설정이 존재하지 않음"                 >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#                                echo " "                                                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
                        fi
#                else
#                        awk -F":" '{print $1}' tempfile.txt                                   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#                        echo "----------------------------------------"                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#                        echo "사용자 profile 파일이 존재하지 않음"                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#                        echo " "                                                              >> $HOSTNAME.$DATE.linux.result.txt 2>&1
								 fi
					fi			 
	fi
done
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "[참고] web service config"                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "-----------------------------------------------"                                         >> $HOSTNAME.$DATE.linux.result.txt 2>&1
# Apache, WebtoB, JEUS 버전 확인
apache_version=$(apache2 -v 2>/dev/null || httpd -v 2>/dev/null)
webtob_version="WebtoB Version: $(find / -name webtob -exec {} -version 2>/dev/null \;)"
jeus_version="JEUS Version: $(find / -name jeus -exec {} --version 2>/dev/null \;)"

# 버전 정보 기록
echo "$apache_version" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "===================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "$webtob_version" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "===================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "$jeus_version" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo "===================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1

# Apache 설정 파일 처리
apache2_confs=$(find / -name apache2.conf 2>/dev/null)
apache2_envvars=$(find / -name envvars 2>/dev/null)
httpd_confs=$(find / -name httpd.conf 2>/dev/null)


if [ -n "$apache2_confs" ] || [ -n "$httpd_confs" ]; then
  if [ -n "$apache2_confs" ]; then
    for conf in $apache2_confs; do
      echo "$conf" >> $HOSTNAME.$DATE.linux.result.txt 2>&1    
      cat "$conf" >> $HOSTNAME.$DATE.linux.result.txt 2>&1      
      echo -e "\n===================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1 
    done
	echo "===================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	echo "envvars" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	cat "$apache2_envvars" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
	
  fi

  if [ -n "$httpd_confs" ]; then
    for conf in $httpd_confs; do
      echo "$conf" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
      cat "$conf" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
      echo -e "\n===================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
    done
  fi
else
  echo "No apache2.conf or httpd.conf found" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi

# WebtoB 설정 파일(http.m) 처리
webtob_confs=$(find / -name http.m 2>/dev/null)

if [ -n "$webtob_confs" ]; then
  for conf in $webtob_confs; do
    echo "$conf" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
    cat "$conf" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
    echo -e "\n===================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
  done
else
  echo "No http.m (WebtoB) configuration file found" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi

# JEUS 설정 파일(domain.xml) 처리
jeus_confs=$(find / -name domain.xml 2>/dev/null)

if [ -n "$jeus_confs" ]; then
  for conf in $jeus_confs; do
    echo "$conf" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
    cat "$conf" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
    echo -e "\n===================================" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
  done
else
  echo "No domain.xml (JEUS) configuration file found" >> $HOSTNAME.$DATE.linux.result.txt 2>&1
fi

rm -rf profilepath.txt
rm -rf tempfile.txt 
				# if [`grep "^\.profile$" | wc -l` -gt 0 ]
                # then
                        # filename = `ls -f $pathname | grep "^\.profile$"`

                        # if [ `grep -i umask $pathname/$filename | grep -v "^#" | wc -l` -gt 0 ]
                        # then
                                # awk -F":" '{print $1}' tempfile.txt                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
                                # echo "----------------------------------------"                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
                                # grep -A 1 -B 1 -i umask $pathname/$filename | grep -v "^#"     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
                                # echo " "                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
# 사용자 profile이 존재하는 경우만 출력하기 위해 주석 처리
#                        else
#                                awk -F":" '{print $1}' tempfile.txt                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#                                echo "----------------------------------------"               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#                                echo $filename"에 UMASK 설정이 존재하지 않음"                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
#                                echo " "                                                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
                        # fi
# #                else
# #                        awk -F":" '{print $1}' tempfile.txt                                   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
# #                        echo "----------------------------------------"                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
# #                        echo "사용자 profile 파일이 존재하지 않음"                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
# #                        echo " "                                                              >> $HOSTNAME.$DATE.linux.result.txt 2>&1
						# fi
					# fi			 
	# fi
# done
# echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
# echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
# rm -rf profilepath.txt
# rm -rf tempfile.txtxt 2>&1
								 # fi
					# fi			 
	# fi
# done
# echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
# echo " "                                                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
# rm -rf profilepath.txt
# rm -rf tempfile.txt                                                                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
# #			echo " "                                                                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
		# fi
	# else
		# pathname=`awk -F":" '{print $2}' tempfile.txt`
					# if [ -f $pathname ]
					# then
                # if [ `ls -f $pathname | grep "^\.profile$" | wc -l` -gt 0 ]
                # then
                        # filename = `ls -f $pathname | grep "^\.profile$"`

                        # if [ `grep -i umask $pathname/$filename | grep -v "^#" | wc -l` -gt 0 ]
                        # then
                                # awk -F":" '{print $1}' tempfile.txt                            >> $HOSTNAME.$DATE.linux.result.txt 2>&1
                                # echo "----------------------------------------"                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
                                # grep -A 1 -B 1 -i umask $pathname/$filename | grep -v "^#"     >> $HOSTNAME.$DATE.linux.result.txt 2>&1
                                # echo " "                                                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
# # 사용자 profile이 존재하는 경우만 출력하기 위해 주석 처리
# #                        else
# #                                awk -F":" '{print $1}' tempfile.txt                           >> $HOSTNAME.$DATE.linux.result.txt 2>&1
# #                                echo "----------------------------------------"               >> $HOSTNAME.$DATE.linux.result.txt 2>&1
# #                                echo $filename"에 UMASK 설정이 존재하지 않음"                >> $HOSTNAME.$DATE.linux.result.txt 2>&1
# #                                echo " "                                                      >> $HOSTNAME.$DATE.linux.result.txt 2>&1
                        # fi
# #                else
# #                        awk -F":" '{print $1}' tempfile.txt                                   >> $HOSTNAME.$DATE.linux.result.txt 2>&1
# #                        echo "----------------------------------------"                       >> $HOSTNAME.$DATE.linux.result.txt 2>&1
# #                        echo "사용자 profile 파일이 존재하지 않음"                          >> $HOSTNAME.$DATE.linux.result.txt 2>&1
# #                        echo " "                                                              >> $HOSTNAME.$DATE.linux.result.txt 2>&1
								 # fi
					# fi			 
	# fi
# done
echo " "																						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
echo " "																						>> $HOSTNAME.$DATE.linux.result.txt 2>&1
#rm -rf profilepath.txt
#rm -rf tempfile.txt
#rm -rf proftpd.txt
#rm -rf vsftpd.txt