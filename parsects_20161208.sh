#!/bin/bash

#########################
# Unzip all files begin #
#########################
runzip()
{
   #
   # Get parameters
   #

   local zip_file=$1
   local rm_flag=$2

   if [[ "${zip_file}" != *.zip ]]
   then
      zip_file=${zip_file}.zip
   fi

   #
   # Declare local variables
   #

   local zip_dir
   local zip_list
   local new_zip_file
   local new_unzip_sts

   #
   # Verify thar zip file exists
   #

   if [[ ! -e "${zip_file}" ]]
   then
      #echo "$0 - Zip file not found : ${zip_file}" >&2
      return 1
   fi

   #
   # Create unzip directory
   #

#   zip_dir=$PWD/$(basename ${zip_file} .zip)
   zip_dir=$PWD/$(basename "${zip_file}" .zip)

   #if [ ! -d "${zip_dir}" ]
   #then
   #   if ! mkdir "${zip_dir}"
   #   then
   #      #echo "$0 - Failed to create directory : ${zip_dir}"
   #      return 1
   #   fi
   #fi

   #
   # Unzip in unzip directory
   #

   if ! unzip -j -o "${zip_file}" -d "${zip_dir}"
   then
      #echo "$0 - Unzip error for file : $PWD/${zip_file}"
      return 1
   fi

   #
   # Get list of new zip files
   #

  #new_zip_list="${zip_dir}"/.new_zip_list
   #find "${zip_dir}" -type f -name '*.zip' -print > "${new_zip_list}"

   #
   # Recursive unzip of new zip files
   #

   #unzip_sts=0
   #cd "${zip_dir}"
   #while read new_zip_file
   #do
   #   if ! runzip "${new_zip_file}" remove_zip
   #   then
   #      unzip_sts=$?
   #      break
   #   fi
   #done < "${new_zip_list}"
#   rm -f "${new_zip_list}"
   #cd ..

   #
   # Remove zip file if required
   #

#   if [ -n "${rm_flag}" -a ${unzip_sts} -eq 0 ]
#   then
#      if ! rm "${zip_file}"
#      then
#         echo "$0 - Failed to delete file : $PWD/${zip_file}"
#      fi
#   fi

   return 0
}


#runzip "$1"

#########################
# Unzip all files end   #
#########################
for a_file in *;do mv -v $a_file `echo $a_file | tr [:upper:] [:lower:]` ;done;
for i in *.zip; do
runzip "$i"
done


###############################
# Find Report and Type begin  #
###############################
function CHECKREPORTTYPE()
{
#echo $1
if grep -qnri "<Cts version" "$1"
then
newNCTSReport=0
oldCTSREPORTDIR=0
oldCTSRETESTREPORTDIR=0
#echo "cts"
	if [  -z "$FileName1" ]
	then
	    FileName1=$1
		oldCTSREPORTDIR=$FileName1
		oldCTSREPORTDIR=$(echo $oldCTSREPORTDIR | sed 's/\/t.*//')
		oldCTSREPORTDIR=$oldCTSREPORTDIR"/"
		echo "--------------->oldCTSREPORTDIR "  $oldCTSREPORTDIR
	else
	    FileName2=$1
		oldCTSRETESTREPORTDIR=$FileName1
		oldCTSRETESTREPORTDIR=$(echo $oldCTSRETESTREPORTDIR | sed 's/\/t.*//')
		oldCTSRETESTREPORTDIR=$oldCTSRETESTREPORTDIR"/"
		echo "--------------->oldCTSRETESTREPORTDIR "  $oldCTSRETESTREPORTDIR
	fi
	#echo ""
fi
#cts 7.0
if grep -qnri "suite_name=\"CTS"  "$1"
then
newNCTSReport=1
newNCTSReportDir=0
newNCTSRetestReportDir=0
#echo "cts"
	if [  -z "$FileName1" ]
	then
	    FileName1=$1
		newNCTSReportDir=$FileName1
		newNCTSReportDir=$(echo $newNCTSReportDir | sed 's/\/t.*//')
		newNCTSReportDir=$newNCTSReportDir"/"
		echo "--------------->newNCTSReportDir "  $newNCTSReportDir  | tee -a $FILE
	else
	    FileName2=$1
		newNCTSRetestReportDir=$FileName2
		newNCTSRetestReportDir=$(echo $newNCTSRetestReportDir | sed 's/\/t.*//' )
		newNCTSRetestReportDir=$newNCTSRetestReportDir"/"
		echo "--------------->newNCTSRetestReportDir "  $newNCTSRetestReportDir   | tee -a $FILE
	fi
	#echo ""
fi
if grep -qnri "Xts version" "$1"
then
newNGTSReport=0
oldGTSREPORTDIR=0
#echo "Xts"
	FileName3=$1
	oldGTSREPORTDIR=$FileName3
	oldGTSREPORTDIR=$(echo $oldGTSREPORTDIR | sed 's/\/t.*//')
	oldGTSREPORTDIR=$oldGTSREPORTDIR"/"
	echo "--------------->oldGTSREPORTDIR "  $oldGTSREPORTDIR
fi
#gts 4.0
if grep -qnri "suite_name=\"GTS" "$1"
then
newNGTSReport=1
#echo "Xts"
	FileName3=$1
	newNGTSReportDir=$FileName3
	newNGTSReportDir=$(echo $newNGTSReportDir | sed 's/\/t.*//')
	newNGTSReportDir=$newNGTSReportDir"/"
	echo "--------------->newNGTSReportDir "  $newNGTSReportDir
fi
if grep -qnri "verifier-info" "$1"
then
#echo "verifier"
	FileName4=$1
	#echo ""
fi

}


find -name '*.xml' -printf "%T@xxx%p\n" | sort -n > xmlList

FILECOUNT=0

while read line
do
   # FILENAME[$FILECOUNT]=$line
    BEGIN=${line/xxx*/}
    BEGIN=${#BEGIN}
    BEGIN=$((BEGIN+3))
    FILENAME[$FILECOUNT]=${line:$BEGIN}
 #   echo "Text file name - ${FILENAME[$FILECOUNT]}"
    FILECOUNT=$((FILECOUNT+1))
done < xmlList

#echo $FILECOUNT
FileName1=""
FileName2=""
FileName3=""
FileName4=""
for (( i=0; i<FILECOUNT; i++ ))
do
#echo $i
   # echo "Text file name - ${FILENAME[$i]}"
    CHECKREPORTTYPE "${FILENAME[$i]}"
	echo $FileName1
	echo $FileName2
	echo $FileName3
	echo $FileName4
done

rm -rf xmlList

#echo $FileName1
#echo $FileName2
#echo $FileName3
#echo $FileName4

###############################
# Find Report and Type end    #
###############################


######################
# Check Report Begin #
######################

CTS_DEVICEID=""
CTS_RETEST_DEVICEID=""
GTS_DEVICEID=""
CLIENTID=""
CTS_REPORT_PATH=$FileName1
CTS_RETEST_REPORT_PATH=$FileName2
GTS_REPORT_PATH=$FileName3
CTS_VERIFER_REPORT_PATH=$FileName4
CTS_FINGERPRINT=""
CTS_RETEST_FINGERPRINT=""
GTS_FINGERPRINT=""
CTS_VERIFIER_FINGERPRINT=""
#for checking if its correct report
CTSCHECK="<Cts version"
GTSCHECK="Xts version"
CTSVERIFIERCHECK="verifier-info"
CTS_Version=""
GTS_Version=""
CTSVERIFER_Version=""
OS_INFO=""
BUILD_VERSION=""
LOW_RAM=""

#chec tests
CTS_FAILS=""
CTS_PASS=""
CTS_NOTEXECUTED=""
TOTAL_TEST=""

CTS_RETEST_FAILS=""
CTS_RETEST_PASS=""
CTS_RETEST_NOTEXECUTED=""

GTS_FAILS=""
GTS_PASS=""
GTS_NOTEXECUTED=""


#CTS VERSION FROM FILE
CTS_TOOL=""
function LOAD_TOOL_INFO()
{

A=$(cat toolsfile.txt)
OS_INFO=$(grep -nri "$1" "$A")
echo "$A"
echo "$1"
CTS_TOOL=$(cat toolsfile.txt |sed -n "${1}" )

#| sed 's/\"//' | sed 's/\".*//'
echo "$CTS_TOOL"
}
function CTS(){
echo "****************************First run failures****************************" 						| tee -a $FILE
BASICCTSCHECK  "$1"

CTS_DEVICEID=$(grep -ir "deviceID=\"" "$1"  |sed 's/.*deviceID=\"//'|  sed 's/\".*//' )
#CTS_FAILS=$(grep -ir "<Summary failed=\"" "$1"  |sed 's/.*<Summary failed="//'|  sed 's/\".*//')
echo " "																								| tee -a $FILE
FINGERPRINTS "$1" "CTS"
}

function RETEST_CTS(){
echo " "																								| tee -a $FILE
echo "****************************Retest failures*******************************" | tee -a $FILE
BASICCTSCHECK  "$1"

#CTS_RETEST_DEVICEID=$(grep -ir "deviceID=\"" "$1"  |sed 's/.*deviceID=\"//'|  sed 's/\".*//' )
echo " "																								| tee -a $FILE
FINGERPRINTS "$1" "CTSR"
}

function GTS(){
echo " "																								| tee -a $FILE
echo "*************************************GTS***********************************"						| tee -a $FILE
GTSVERSION "$1"
echo ""
CHECKCLIENTID "$1"																							| tee -a $FILE
GMSVERSION "$1"
GTSANDROIDFORORK "$1"
CHECKSECURITYPATCH
echo ""																									| tee -a $FILE
#COMPAREDEVICEID "$CTS_DEVICEID"  "$CTS_RETEST_DEVICEID" "$GTS_DEVICEID"
#AUTOHIDEAPP "$1"
CHECKGMSESSENTIALAPPS "$1"
MUSTGMS "$1"
OPTIONALGMS "$1"
GOOGLELIBRRIES "$1"
MTKlogger "$1"
GTS_RESULT $1

CTS_VERIFIER_FINGERPRINT=""
FINGERPRINTS "$1" "GTS"
}


function FINGERPRINTS(){

locationGTS_N="./"$newNGTSReportDir"/PropertyDeviceInfo.deviceinfo.json"
locationCTS_N="./"$newNCTSReportDir"/PropertyDeviceInfo.deviceinfo.json"
echo "111111---->    "$1
oldlocation=$1
fingerprint_=""
if [ $newNGTSReport -ne 0 ]
then
		
		if [ "$2" == "GTS" ]; then
			location="$locationGTS_N"
			GTS_FINGERPRINT=$(sed ':a;N;$!ba;s/\",\n/ /g' $location | grep  "ro.build.fingerprint"  | sed 's/.*\"value\": \"//' | sed 's/\"//' )
			echo "Fingerprint :  "  $GTS_FINGERPRINT | tee -a $FILE
			fingerprint_=$GTS_FINGERPRINT
		elif [ "$2" == "CTS" ]; then
			location="$locationCTS_N"
			CTS_FINGERPRINT=$(sed ':a;N;$!ba;s/\",\n/ /g' $location | grep  "ro.build.fingerprint"  | sed 's/.*\"value\": \"//' | sed 's/\"//' )
			echo "Fingerprint :  "  $CTS_FINGERPRINT | tee -a $FILE
			fingerprint_=$CTS_FINGERPRINT
		else
			#fingerprint="alps/full_k50v1_64_om/k50v1_64:7.0/NRD90M/1480308947:user/dev-keys"
			CTS_VERIFIER_FINGERPRINT=" $(grep -ir "fingerprint=" "$1" | sed 's/.*fingerprint=\"//'| sed 's/ //' | sed 's/\".*//' )"
			echo "Fingerprint aa:  "  $CTS_VERIFIER_FINGERPRINT | tee -a $FILE
			fingerprint_=$CTS_VERIFIER_FINGERPRINT
		fi

		
	else
		if [ "$2" == "GTS" ]; then
			GTS_FINGERPRINT=" $(grep -ir "buildFingerprint=" $oldlocation | sed 's/.*buildFingerprint=\"//' | sed 's/\".*/ /')"
			echo "Fingerprint :  "  $GTS_FINGERPRINT | tee -a $FILE
			fingerprint_=$GTS_FINGERPRINT
		elif [ "$2" == "CTS" ]; then
			CTS_FINGERPRINT=" $(grep -ir " build_fingerprint=" $oldlocation | sed 's/.* build_fingerprint=\"//' | sed 's/\".*/ /')"
			echo "Fingerprint :  "  $CTS_FINGERPRINT | tee -a $FILE
			fingerprint_=$CTS_FINGERPRINT
		elif [ "$2" == "CTSR" ]; then
			CTS_RETEST_FINGERPRINT=" $(grep -ir " build_fingerprint=" $oldlocation | sed 's/.* build_fingerprint=\"//' | sed 's/\".*/ /')"
			echo "Fingerprint :  "  $CTS_RETEST_FINGERPRINT | tee -a $FILE
			fingerprint_=$CTS_RETEST_FINGERPRINT
		elif [ "$2" == "CTSV" ]; then
			CTS_VERIFIER_FINGERPRINT=" $(grep -ir " fingerprint=" "$oldlocation" | sed 's/.* fingerprint=\"//' | sed 's/\".*/ /')"
			echo "Fingerprint :  "  $CTS_VERIFIER_FINGERPRINT | tee -a $FILE
			fingerprint_=$CTS_VERIFIER_FINGERPRINT
		
			else
			echo ""
		fi

#		"$CTS_FINGERPRINT" "$CTS_RETEST_FINGERPRINT" "$GTS_FINGERPRINT" "$CTS_VERIFIER_FINGERPRINT"
fi
CHECKFINGERPRINT $fingerprint_								| tee -a $FILE

}


function GTSVERSION(){
echo " "																								| tee -a $FILE
if [ $newNGTSReport -ne 0 ]
then
	locationGTS_N=$newNGTSReportDir
	grep --exclude "*.log" -ir "suite_name=\"GTS" $locationGTS_N  |sed 's/.*suite_version=\"/GTS suite version=/'|sed 's/.*<//' | sed 's/\".*//' | tee -a $FILE

else
	grep --exclude "*.log" -ir "Xts version" "$1" |sed 's/.*<//' | sed 's/\"//' | sed 's/\".*//'  							| tee -a $FILE
fi

}
function GTS_RESULT(){


	if [ $newNGTSReport -ne 0 ]
	then
			echo " "																								| tee -a $FILE
			echo  "GTS FAILS:"																						| tee -a $FILE
#		<Test result="fail" name="testWidgetPresence">
		checkfail="result=\"fail"
		grep -ir "$checkfail" "$1"  		|sed 's/.*name=\"/	/'	| sed 's/\".*//'	| sed 's/\"//' | sed 's/\"//'		| tee -a $FILE
#		 <Summary pass="632" failed="10" not_executed="0" modules_done="60" modules_total="60" />
			GTS_FAILS=$(grep -ir "<Summary pass=\"" "$1"  |sed 's/.*failed="//'|  sed 's/\".*//')
			GTS_PASS=$(grep -ir "<Summary pass=\"" "$1"  |sed 's/.*pass="//'|  sed 's/\".*//')
			GTS_NOTEXECUTED=$(grep -ir "<Summary pass=\"" "$1"  |sed 's/.*not_executed="//'|  sed 's/\".*//')
			TOTAL_GTS_TEST=$((GTS_RETEST_FAILS + GTS_RETEST_PASS + GTS_RETEST_NOTEXECUTED))
			echo " "																								| tee -a $FILE
			echo "Pass : " $GTS_PASS										| tee -a $FILE
			echo "Fails : "$GTS_FAILS									| tee -a $FILE
			echo "Not Executed : "$GTS_NOTEXECUTED						| tee -a $FILE
			grep -rniq "notExecuted\"" "$1"	| sed 's/.*<Test name="/	/' |  sed s/\".*// 		  | tee -a $FILE
			echo " "																								| tee -a $FILE
	else
			echo " "																								| tee -a $FILE
			echo  "GTS FAILS:"																						| tee -a $FILE
			checkfail="result=\"fail"
			grep -ir "$checkfail" "$1"  | grep starttime |sed 's/.*<Test name=/	/' | sed 's/result.*//'	| sed 's/\"//' | sed 's/\"//'				| tee -a $FILE
			GTS_FAILS=$(grep -ir "<Summary failed=\"" "$1"  |sed 's/.*<Summary failed="//'|  sed 's/\".*//')
			GTS_PASS=$(grep -ir "pass=\"" "$1"  |sed 's/.*pass="//'|  sed 's/\".*//')
			GTS_NOTEXECUTED=$(grep -ir "notExecuted=\"" "$1"  |sed 's/.*notExecuted="//'|  sed 's/\".*//')
			TOTAL_GTS_TEST=$((GTS_RETEST_FAILS + GTS_RETEST_PASS + GTS_RETEST_NOTEXECUTED))
			echo ""
			echo "Pass : " $GTS_PASS										| tee -a $FILE
			echo "Fails : "$GTS_FAILS									| tee -a $FILE
			echo "Not Executed : "$GTS_NOTEXECUTED						| tee -a $FILE
			grep -rniq "notExecuted\"" "$1"	| sed 's/.*<Test name="/	/' |  sed s/\".*// 		  | tee -a $FILE
			echo " "																								| tee -a $FILE
	fi




}

function VERIFIER(){
echo " "																								| tee -a $FILE
echo "****************************Verifier ****************************" 							| tee -a $FILE

#grep -ir "board" "$1"								 						| tee -a $FILE

grep -ir "version-name" "$1"  |sed 's/\ <verifier-info//' |  sed 's/\"//' |sed 's/\" v.*//' | sed 's/\ //' | sed 's/\ //'			| tee -a $FILE

BYOD="BYOD test  present"
if grep -wqri "BYOD" "$1"

		then
			echo $BYOD"			YES"												| tee -a $FILE
		else
			echo $BYOD"			NO"												| tee -a $FILE
fi

echo "CTS VERIFIER FAILS:"																							| tee -a $FILE
grep -ir "result=\"fai" "$1"  |sed s/.*'<test title="'/"	"/ |  sed s/\".*//     									| tee -a $FILE
echo " "																											| tee -a $FILE
echo "CTS VERIFIER Not Executed:"																					| tee -a $FILE
grep -ir "result=\"not-executed" "$1"  |sed s/.*'<test title="'/"	"/ |  sed s/\".*//     							| tee -a $FILE
echo ""																												| tee -a $FILE
#CTS_RETEST_DEVICEID=$(grep -ir "deviceID=\"" "$1"  | sed 's/.*deviceId=\"//'| sed 's/\".*//')
#CTS_VERIFIER_FINGERPRINT=" $(grep -ir "fingerprint=" "$1" | sed 's/.*fingerprint=\"//' | sed 's/\".*/ /')"

FINGERPRINTS "$1" "CTSV"
}

function GTSANDROIDFORORK(){

androidforwork_package="com.google.android.androidforwork"
searchfor=$package$androidforwork_package$flag
output="Contain android for WorK"

if [ $newNGTSReport -ne 0 ]
then
	locationGTS_N=$newNGTSReportDir"PackageDeviceInfo.deviceinfo.json"
	if grep -wqri $searchfor $1
	then
			echo  $output "		YES"												| tee -a $FILE
	else
			echo  $output "		NO"													| tee -a $FILE
	fi

else
	if grep -wqri $searchfor "$1"
	then
			echo  $output "		YES"												| tee -a $FILE
	else
			echo  $output "		NO"													| tee -a $FILE
	fi
fi
echo " "																								| tee -a $FILE


}

function CHECKCLIENTID(){

echo "-----------------------------------------"														| tee -a $FILE
echo "CLIENTID : "																						| tee -a $FILE
clientidtxt='/data/web/script/clientid.txt'

if [ $newNGTSReport -ne 0 ]
then
		locationGTS_N="./"$newNGTSReportDir"/PropertyDeviceInfo.deviceinfo.json"

		CLIENTID=$(sed ':a;N;$!ba;s/\",\n/ /g' $locationGTS_N | grep "ro.com.google.clientidbase " | sed 's/.*value\": \"//' | sed 's/\"//' )
		echo $CLIENTID
		sed ':a;N;$!ba;s/\",\n/ /g' $locationGTS_N | grep -iw "ro.com.google.clientidbase"  | sed 's/.*name\": \"ro/ro/' | sed 's/value\": \"/	:/' | sed 's/\"//' | sed 's/\"//'	| tee -a $FILE
		if [ -f /data/web/script/clientid.txt ]; then 

			if  grep  -qir $CLIENTID $clientidtxt	  ; then
				echo "CLIENT ID  FOUND : " $CLIENTID												| tee -a $FILE
				grep $CLIENTID $clientidtxt												| tee -a $FILE
			else
				echo "CLIENT ID NOT FOUND : "	$CLIENTID										| tee -a $FILE
				grep $CLIENTID $clientidtxt										| tee -a $FILE
			fi
		else
			echo "ClientID File does not exist"
		fi

else
		grep -iw "ro.com.google.clientidbase" "$1"   |sed 's/.*ro.com.google.//' | sed 's/\"\ value//' | sed 's/\"//' |sed 's/\".*//'			| tee -a $FILE
		CLIENTID=$(grep -ir "ro.com.google.clientidbase\"" "$1"   |sed 's/.*value=\"//' | sed 's/\"//' |sed 's/\".*//' | sed 's/\/.*//')
		if [ -f /data/web/script/clientid.txt ]; then 

			if  grep  -qir $CLIENTID $clientidtxt	  ; then
				echo "CLIENT ID  FOUND : " $CLIENTID												| tee -a $FILE
				grep $CLIENTID $clientidtxt												| tee -a $FILE
			else
				echo "CLIENT ID NOT FOUND : "	$CLIENTID										| tee -a $FILE
				grep $CLIENTID $clientidtxt										| tee -a $FILE
			fi
		else
			echo "ClientID File does not exist"
		fi
fi
echo "-----------------------------------------"														| tee -a $FILE

}

function BASICCTSCHECK(){
#all info comes from report
#check basic information for full cts and retest
#list build version
if [ "$newNCTSReport" -ne 0 ]
then

	echo "this is 7.0 style report"
		echo " "																								| tee -a $FILE
		grep -ir "build_version_release=" "$1"  | sed 's/.*build_version_release="/OS VERSION=/'  | sed 's/\".*/	/'  					| tee -a $FILE


		#list CTS version
		echo " "																								| tee -a $FILE
		grep -ir "<Cts version" "$1"  | sed 's/.*<//'  |   sed 's/\"//' |  sed 's/\">//'		    					| tee -a $FILE

		#list root process
		#echo " "																									| tee -a $FILE
		#echo "Root Process:"									    					| tee -a $FILE
		#grep -ir "<Process name=\"" "$1"  | sed 's/.*<Process name=\"/	/'  |   sed 's/\".*/	/'  					| tee -a $FILE

		#check contains com.google.widevine.software.drm. GMS devices must contain
		echo " "																								| tee -a $FILE
		echo "DRM Library:"									    					| tee -a $FILE
		grep -ir "com.google.widevine.software.drm" "$1"  |sed 's/.*<Library name=\"/	/'  |   sed 's/\".*/	   /'   		| tee -a $FILE

		#check data partition
		echo " "																								| tee -a $FILE
		echo "Data Partition:"																					| tee -a $FILE
		location=$newNCTSReportDir"StorageDeviceInfo.deviceinfo.json"	
		grep -r " \/data\"," "$location"   							| tee -a $FILE
		#check low ram
		echo " "																								| tee -a $FILE
		echo "Is device low ram:"																										| tee -a $FILE
		locationCTS_N=$newNCTSReportDir"MemoryDeviceInfo.deviceinfo.json"			
		grep -ir "low_ram_device" "$locationCTS_N" | sed 's/.*low_ram_device":"/ /' |   sed 's/,.*/	/' 							| tee -a $FILE

		#check if fail testEncryption. 6.0  must pass in full and all retest report
		echo " "																								| tee -a $FILE
		#echo "Encryption Fails if item displayed below:"														| tee -a $FILE
		#grep -ir "name=\"testEncryption\" result=\"fai" "$1"  |sed 's/.*<Test name="/	/' |  sed s/\".*// 							| tee -a $FILE


		echo " "																								| tee -a $FILE
		echo "CHECK HERE FOR BYOD"																				| tee -a $FILE
		managedUserReport=$newNCTSReportDir"FeatureDeviceInfo.deviceinfo.json"	
		 managedUsers=$(sed ':a;N;$!ba;s/\",\n/ /g' $managedUserReport | grep "android.software.managed_users " |sed 's/.*name\": \"//' |  sed 's/users.*available\":/users :/' |sed 's/,//' )
		ManagedFeature="Managed user feature present"
		   echo $ManagedFeature "=" $managedUsers																							| tee -a $FILE
		storage_devices="storage_devices"
		locationCTS_N="./"$newNCTSReportDir"/StorageDeviceInfo.deviceinfo.json"
		emulated=$(grep -r "/storage/emulated" "$locationCTS_N"   )	
		echo $storage_devices"	"$emulated                                 								| tee -a $FILE
		

		#list failures
		echo " "																								| tee -a $FILE
		echo "CTS Fails :"														| tee -a $FILE
		grep -ir "result=\"fail" "$1" |  sed 's/.* name=\"/	/'  | sed 's/\".*/	/'  | tee -a $FILE
		
		echo " "															| tee -a $FILE
		#<Summary pass="353147" failed="18" not_executed="0" modules_done="277" modules_total="277" />
		SUMMARY=$(grep -ir "<Summary pass=\"" "$1")		
		echo $summary 		| tee -a $FILE
		
		CTS_FAILS=$(echo $SUMMARY |sed 's/.*failed="//'|  sed 's/\".*//')
		CTS_PASS=$(echo $SUMMARY |sed 's/.*<Summary pass="//'|  sed 's/\".*//')
		CTS_NOTEXECUTED=$(echo $SUMMARY | sed 's/.*not_executed="//'|  sed 's/\".*//')
		MODULES_DONE=$(echo $SUMMARY | sed 's/.*modules_done="//'|  sed 's/\".*//')
		MODULES_TOTAL=$(echo $SUMMARY | sed 's/.*modules_total="//'|  sed 's/\".*//')
		#TOTAL_TEST=$((CTS_RETEST_FAILS + CTS_RETEST_PASS + CTS_RETEST_NOTEXECUTED))

		echo ""
		#echo "Total test :" $TOTAL_TEST										| tee -a $FILE
		echo "Pass : " $CTS_PASS										| tee -a $FILE
		echo "Fails : "$CTS_FAILS									| tee -a $FILE
		echo "MODULES_DONE : "$MODULES_DONE									| tee -a $FILE
		echo "MODULES_TOTAL : "$MODULES_TOTAL									| tee -a $FILE		
		echo "Not Executed : "$CTS_NOTEXECUTED						| tee -a $FILE
		if [  "$CTS_NOTEXECUTED" != "0" ]
			then
				echo "		This report has Not Executed test, retry again "					| tee -a $FILE
		fi
		checkfail="result=\"notExecuted"
		grep -ir "$checkfail" "$1"  | grep starttime |sed 's/.*<Test name=/	/' | sed 's/result.*//'					| tee -a $FILE

		echo ""		
		
		
else

echo " "																								| tee -a $FILE
	grep -ir "buildVersion=" "$1"  | sed 's/.*buildVersion="/OS VERSION=/'  | sed 's/\".*/	/'  					| tee -a $FILE


	#list CTS version
	echo " "																								| tee -a $FILE
	grep -ir "<Cts version" "$1"  | sed 's/.*<//'  |   sed 's/\"//' |  sed 's/\">//'		    					| tee -a $FILE

	#list root process
	echo " "																									| tee -a $FILE
	echo "Root Process:"									    					| tee -a $FILE
	grep -ir "<Process name=\"" "$1"  | sed 's/.*<Process name=\"/	/'  |   sed 's/\".*/	/'  					| tee -a $FILE

	#check contains com.google.widevine.software.drm. GMS devices must contain
	echo " "																								| tee -a $FILE
	echo "DRM Library:"									    					| tee -a $FILE
	grep -ir "com.google.widevine.software.drm" "$1"  |sed 's/.*<Library name=\"/	/'  |   sed 's/\".*/	   /'   		| tee -a $FILE

	#check data partition
	echo " "																								| tee -a $FILE
	echo "Data Partition:"														| tee -a $FILE
	grep -ir ";/data" "$1" | sed 's/.*;\/data/	/' | sed 's/;.*/	 /' 							| tee -a $FILE

	#check low ram
	echo " "																								| tee -a $FILE
	echo "Is device low ram:"														| tee -a $FILE
	grep -ir "<MemoryInfo is_low_ram_device" "$1" | sed 's/<MemoryInfo is_low_ram_device=\"/ /' |   sed 's/\".*/	/' 							| tee -a $FILE

	#check if fail testEncryption. 6.0  must pass in full and all retest report
	echo " "																								| tee -a $FILE
	echo "Encryption Fails if item displayed below:"														| tee -a $FILE
	grep -ir "name=\"testEncryption\" result=\"fai" "$1"  |sed 's/.*<Test name="/	/' |  sed s/\".*// 							| tee -a $FILE


	echo " "																								| tee -a $FILE
	echo "      CHECK HERE FOR BYOD"																								| tee -a $FILE
	ManagedFeature="Managed user feature present"
	managedUsers=$(grep -ir "android.software.managed_users" "$1"  | sed 's/.*available="//'|  sed 's/\".*//')
	#grep -ir "android.software.managed_users" "$3"  | sed 's/.*available="//'|  sed 's/\".*//'    | tee -a $FILE
	echo $ManagedFeature "=" $managedUsers													| tee -a $FILE
	storage_devices="storage_devices"
	emulated=$(grep -ir "$storage_devices" "$1"  | sed 's/.*storage_devices="//'|  sed 's/\".*//')
	echo $storage_devices "=" $emulated                                 								| tee -a $FILE



	#list failures
	echo " "																								| tee -a $FILE
	echo "CTS Fails :"														| tee -a $FILE
	grep -ir "result=\"fai" "$1"  |sed 's/.*<Test name="/	/' |  sed s/\".*// 							| tee -a $FILE
	echo " "																								| tee -a $FILE

CTS_RETEST_FAILS=$(grep -ir "<Summary failed=\"" "$1"  |sed 's/.*<Summary failed="//'|  sed 's/\".*//')
CTS_RETEST_PASS=$(grep -ir "pass=\"" "$1"  |sed 's/.*pass="//'|  sed 's/\".*//')
CTS_RETEST_NOTEXECUTED=$(grep -ir "notExecuted=\"" "$1"  |sed 's/.*notExecuted="//'|  sed 's/\".*//')
TOTAL_RETEST=$((CTS_RETEST_FAILS + CTS_RETEST_PASS + CTS_RETEST_NOTEXECUTED))

echo ""
echo "Total test :" $TOTAL_RETEST									| tee -a $FILE
echo "Pass : " $CTS_RETEST_PASS										| tee -a $FILE
echo "Fails : "$CTS_RETEST_FAILS									| tee -a $FILE
echo "		Not Executed : "$CTS_RETEST_NOTEXECUTED						| tee -a $FILE
if [  "$CTS_RETEST_NOTEXECUTED" != "0" ]
	then
		echo "			This report has Not Executed test, retry again "					| tee -a $FILE
fi
checkfail="result=\"notExecuted"
grep -ir "$checkfail" "$1"  | grep starttime |sed 's/.*<Test name=/		/' | sed 's/result.*//'					| tee -a $FILE
RAN_TEST=$((CTS_RETEST_PASS+CTS_RETEST_FAILS))

echo "RAN_TEST    " $RAN_TEST					| tee -a $FILE
if [  "$TOTAL_RETEST" -ne "$RAN_TEST" ]
	then
		echo "		This report  Full and retest do not match retest again "					| tee -a $FILE
fi
echo ""																| tee -a $FILE



fi



}

function CHECKSECURITYPATCH(){


locationGTS_N=$newNGTSReportDir"GenericDeviceInfo.deviceinfo.json"
path=$(grep --include "*.xml" -rni "xts_result.xsl" | sed 's/\/xts.*//' )
path=$path"/""GenericDeviceInfo.deviceinfo.json"

if [ $newNGTSReport -ne 0 ]
	then
		securityPatch=$(grep -m 1 -i  "\"build_version_security_patch\"" $locationGTS_N | head -1 |sed s/.*'\"build_version_security_patch\"'// |  sed s/\:// |sed s/\"// | sed s/\"//  )
		echo "Security Patch Version" $securityPatch                                                  | tee -a $FILE
		checkDate=$(grep -m 1 -i  "\"build_version_security_patch\"" $locationGTS_N | head -1 |sed s/.*'\"build_version_security_patch\"'// |  sed s/\:// |sed s/\"// | sed s/\"// |  head -c-4 )
		#echo "Security Patch Version short" $checkDate
		todayDate=$(date +"%Y-%m")
		#echo "todayDate" $todayDate
		expectedYear=$(echo  ${todayDate:0:4})
		expectedMonth=$(echo  ${todayDate:5:2})
		expectedMonthOriginal=$(echo  ${todayDate:5:2})
		#expectedMonth=$(echo  ${todayDate:5:6})
		#expectedMonth=$(echo  ${todayDate:5})
		expectedMonthFirstDigit=$(echo  ${todayDate:5:1})
		expectedMonthSecondDigit=$(echo  ${todayDate:6:1})
		reportYear=$(echo  ${checkDate:0:5})
		reportMonth=$(echo  ${checkDate:6:7})
		reportedMonthFirstDigit=$(echo  ${checkDate:6:1})
		reportedMonthSecondDigit=$(echo  ${checkDate:7:1})
		reportedMonth=""
		if [ "$expectedMonthFirstDigit" -eq 0 ];then
			expectedMonth=$(($expectedMonthSecondDigit-1))
			expectedMonth="0"$expectedMonth
		fi

		if [ $reportedMonthFirstDigit -le 0 ];then
			reportedMonth=$reportedMonthSecondDigit
			echo "reportedMonthFirstDigit" $reportedMonthFirstDigit
			echo "reportedMonthSecondDigit" $reportedMonthSecondDigit
			echo "reportMonth" $reportMonth
			echo "reportedMonth" $reportedMonth
		fi



		echo "expectedYear" $expectedYear
		echo "expectedMonth" $expectedMonth
		echo "reportYear" $reportYear
		echo "reportMonth" $reportMonth
		echo "expectedMonthFirstDigit" $expectedMonthFirstDigit
		echo "expectedMonthSecondDigit" $expectedMonthSecondDigit
		echo "reportedMonthFirstDigit" $reportedMonthFirstDigit
		echo "reportedMonthSecondDigit" $reportedMonthSecondDigit
		echo "reportedMonth" $reportedMonth


		monthDifference=$((expectedMonth-reportedMonth))
		echo "monthDifference" $monthDifference
		if [ $monthDifference -ge 2 ];then

			echo "expectedMonth" $expectedMonth
			echo "reportYear" $reportYear
			echo "reportedMonth" $reporedtMonth
			echo "Security Patch NOT Acceptable,minum version requires is "$expectedYear-$expectedMonth						| tee -a $FILE
		else
				echo "Security Patch Acceptable"				| tee -a $FILE
		fi

		echo "expectedYear" $expectedYear
		echo "expectedMonth" $expectedMonth
		echo "reportYear" $reportYear
		echo "reportMonth" $reportMonth
		echo "expectedMonthFirstDigit" $expectedMonthFirstDigit
		echo "expectedMonthSecondDigit" $expectedMonthSecondDigit
		echo "reportedMonthFirstDigit" $reportedMonthFirstDigit
		echo "reportedMonthSecondDigit" $reportedMonthSecondDigit
		echo "reportedMonth" $reportedMonth


	else
		securityPatch=$(grep -m 1 -i  "\"build_version_security_patch\"" $path   )
		echo "Security Patch Version" $securityPatch                                                  | tee -a $FILE
		checkDate=$(grep -m 1 -i  "\"build_version_security_patch\"" $path | head -1 |sed s/.*'\"build_version_security_patch\"'// |  sed s/\:// |sed s/\"// | sed s/\"// |  head -c-4 )
		#echo "Security Patch Version short" $checkDate
		todayDate=$(date +"%Y-%m")
		#echo "todayDate" $todayDate
		expectedYear=$(echo  ${todayDate:0:4})
		expectedMonth=$(echo  ${todayDate:5:2})
		expectedMonthOriginal=$(echo  ${todayDate:5:2})
		#expectedMonth=$(echo  ${todayDate:5:6})
		#expectedMonth=$(echo  ${todayDate:5})
		expectedMonthFirstDigit=$(echo  ${todayDate:5:1})
		expectedMonthSecondDigit=$(echo  ${todayDate:6:1})
		reportYear=$(echo  ${checkDate:0:5})
		reportMonth=$(echo  ${checkDate:6:7})
		reportedMonthFirstDigit=$(echo  ${checkDate:6:1})
		reportedMonthSecondDigit=$(echo  ${checkDate:7:1})
		reportedMonth=""
		if [ "$expectedMonthFirstDigit" -eq 0 ];then
			expectedMonth=$(($expectedMonthSecondDigit-1))
			expectedMonth="0"$expectedMonth
		fi

		if [ $reportedMonthFirstDigit -le 0 ];then
			reportedMonth=$reportedMonthSecondDigit
			echo "reportedMonthFirstDigit" $reportedMonthFirstDigit
			echo "reportedMonthSecondDigit" $reportedMonthSecondDigit
			echo "reportMonth" $reportMonth
			echo "reportedMonth" $reportedMonth
		fi



		echo "expectedYear" $expectedYear
		echo "expectedMonth" $expectedMonth
		echo "reportYear" $reportYear
		echo "reportMonth" $reportMonth
		echo "expectedMonthFirstDigit" $expectedMonthFirstDigit
		echo "expectedMonthSecondDigit" $expectedMonthSecondDigit
		echo "reportedMonthFirstDigit" $reportedMonthFirstDigit
		echo "reportedMonthSecondDigit" $reportedMonthSecondDigit
		echo "reportedMonth" $reportedMonth


		monthDifference=$((expectedMonth-reportedMonth))
		echo "monthDifference" $monthDifference
		if [ $monthDifference -ge 2 ];then

			echo "expectedMonth" $expectedMonth
			echo "reportYear" $reportYear
			echo "reportedMonth" $reporedtMonth
			echo "Security Patch NOT Acceptable,minum version requires is "$expectedYear-$expectedMonth						| tee -a $FILE
		else
				echo "Security Patch Acceptable"				| tee -a $FILE
		fi

		echo "expectedYear" $expectedYear
		echo "expectedMonth" $expectedMonth
		echo "reportYear" $reportYear
		echo "reportMonth" $reportMonth
		echo "expectedMonthFirstDigit" $expectedMonthFirstDigit
		echo "expectedMonthSecondDigit" $expectedMonthSecondDigit
		echo "reportedMonthFirstDigit" $reportedMonthFirstDigit
		echo "reportedMonthSecondDigit" $reportedMonthSecondDigit
		echo "reportedMonth" $reportedMonth

fi

}

function AUTOHIDEAPP(){
grep  -r "ro.com.google.apphider"
#if grep -q "ro.com.google.apphider=off" $1;then
#   echo "AUTOHIDEAPP ON"		| tee -a $FILE
#else
#   echo "AUTOHIDEAPP OFF" 		| tee -a $FILE
#fi
}

function GMSVERSION(){
echo " "		| tee -a $FILE
locationGTS_N=$newNGTSReportDir"PropertyDeviceInfo.deviceinfo.json"

	if [ $newNGTSReport -ne 0 ]
	then
		sed ':a;N;$!ba;s/\",\n/ /g' $locationGTS_N | grep "ro.com.google.gmsversion"  | sed 's/.*ro.com.google.gmsversion/ro.com.google.gmsversion/' | sed 's/\"value\": \"/:/' | sed 's/\"//'	| tee -a $FILE
	else
		grep -ir "gmsversion" "$1"  |sed 's/.*ro.com.google.//'   |sed 's/\" value//' | sed 's/\"//' |sed 's/\".*//'			| tee -a $FILE
	fi
echo " "		| tee -a $FILE
}

function MTKlogger(){
echo " "																								| tee -a $FILE

locationGTS_N=$newNGTSReportDir"PackageDeviceInfo.deviceinfo.json"

	if [ $newNGTSReport -ne 0 ]
	then
		if grep -qri -q "com.mediatek.mtklogger"  $locationGTS_N
		then
				echo "MTK Logger is preloaded"		| tee -a $FILE
			else
			   echo "MTK Logger is not preloaded" 		| tee -a $FILE
		fi
	else
			echo " "		| tee -a $FILE
			echo "------------------------------------------------------------------------------------------ "		| tee -a $FILE
			if grep -q "com.mediatek.mtklogger" $1;then
			   echo "MTK Logger is preloaded"		| tee -a $FILE
			else
			   echo "MTK Logger is not preloaded" 		| tee -a $FILE
			fi
			echo "------------------------------------------------------------------------------------------ "		| tee -a $FILE
			 echo " "		| tee -a $FILE

	fi



}

function COMPAREDEVICEID(){
echo "REPORT DEVICE ID "											| tee -a $FILE
echo "	"$1															| tee -a $FILE
echo "	"$2															| tee -a $FILE
echo "	"$3															| tee -a $FILE

full="$1"
retest="$2"
gts="$3"


if [ "$retest" == "" ]; then
	retest="$1"
	fi
if [ "$full" == "$retest" ]; then
	if [ "$retest" == "$gts" ]; then
		echo "	SAME DEVICE ID"												|  tee -a $FILE
	else
		echo "	DIFFERENT DEVICE ID"									| tee -a $FILE
	fi
else
	echo "	DIFFERENT DEVICE ID"										| tee -a $FILE
fi

}

function COMPAREFINGERPRINT(){
echo $1
echo $2
echo $3
echo $4
full="$1"
retest="$2"
gts="$3"
verfier="$4"
verfier=$(echo "$4" | sed 's/ //' )
echo " DEVICE FINGERPRINT "													| tee -a $FILE
if [ z $retest ]; then
	retest="$full"
	echo " compare no retest"
	echo "full :"$full
	echo "retest :"$retest
	echo "gts :"$gts
	echo "verifier :"$verfier 
fi
if  [[ "$full" == *"$retest"* ]]; then
	if [[ "$full" == *"$gts"* ]];then
		if [[ "$full" == *"$verfier"* ]]; then
			echo "	SAME FINGERPTINT" "$1"										| tee -a $FILE
			CHECKFINGERPRINT	"$full"												| tee -a $FILE
		else
			echo "1"
			echo " DIFFERENT FINGERPRINT"										| tee -a $FILE
		fi
	else
		echo "2"
		echo " DIFFERENT FINGERPRINT"											| tee -a $FILE
	fi
else
	echo "3"
	echo " DIFFERENT FINGERPRINT"												| tee -a $FILE
fi
#acme/myproduct/mydevice:6.0/LMYXX/3359:userdebug/test-keys

}

function CHECKFINGERPRINT(){
echo "$1">fingerprint.txt
#echo $1
if grep -qrni 'test-keys\|:eng/\|:userdebug/\|dev-keys' fingerprint.txt
then
	echo "***********************************************************************"						| tee -a $FILE
	echo "This SW fingerpint is engineer, userdebug, or contains test/dev keys"					| tee -a $FILE
	echo "***********************************************************************"						| tee -a $FILE
else
	echo ""																
fi
brand=$(grep "release" fingerprint.txt| sed 's/\/.*//')
echo "Brand: "$brand													| tee -a $FILE

product=$(grep "release" fingerprint.txt| sed 's/\//@/' | sed 's/.*\@//' | sed 's/\/.*//')
echo "Product: "$product												| tee -a $FILE

device=$(grep "release" fingerprint.txt| sed 's/\//@/' | sed 's/.*\@//' | sed 's/\//@/' | sed 's/.*\@//' | sed 's/\:.*//')
echo "Device: "$device													| tee -a $FILE
VERSION_RELEASE=$(grep "release" fingerprint.txt| sed 's/\//@/' | sed 's/.*\@//' | sed 's/\//@/' | sed 's/.*\@//' | sed 's/\:/@/' | sed 's/.*\@//' | sed s'/\/.*//')
echo "VERSION_RELEASE: "$VERSION_RELEASE								| tee -a $FILE
ID=$(grep "release" fingerprint.txt| sed 's/\//@/' | sed 's/.*\@//' | sed 's/\//@/' | sed 's/.*\@//' | sed 's/\:/@/' | sed 's/.*\@//' | sed s'/\//@/' | sed 's/.*@//' | sed 's/\/.*//')
echo "ID: "$ID															| tee -a $FILE
VERSION_INCREMENTAL=$(grep "release" fingerprint.txt| sed 's/\//@/' | sed 's/.*\@//' | sed 's/\//@/' | sed 's/.*\@//' | sed 's/\:/@/' | sed 's/.*\@//' | sed s'/\//@/' | sed 's/.*@//' | sed 's/\//@/' | sed 's/.*@//' | sed 's/\:.*//')
echo "VERSION_INCREMENTAL: "$VERSION_INCREMENTAL						| tee -a $FILE
TYPE=$(grep "release" fingerprint.txt| sed 's/\//@/' | sed 's/.*\@//' | sed 's/\//@/' | sed 's/.*\@//' | sed 's/\:/@/' | sed 's/.*\@//' | sed s'/\//@/' | sed 's/.*@//' | sed 's/\//@/' | sed 's/.*@//' | sed 's/\:/@/' | sed 's/.*\@//' | sed 's/\/.*//'
)
echo "TYPE: "$TYPE														| tee -a $FILE


TAGS=$(grep "release" fingerprint.txt| sed 's/\//@/' | sed 's/.*\@//' | sed 's/\//@/' | sed 's/.*\@//' | sed 's/\:/@/' | sed 's/.*\@//' | sed s'/\//@/' | sed 's/.*@//' | sed 's/\//@/' | sed 's/.*@//' | sed 's/\:/@/' | sed 's/.*\@//' | sed 's/\//@/' | sed 's/.*\@//')
echo "TAGS: "$TAGS


#rm fingerprint.txt

}

function CHECKCORRECTREPORT(){

if  grep -qnri "$1" "$2"
then
	echo ""
else
	if [ "$1" = "<Cts version" ]
	then
		echo "NOT A CTS REPORT"												| tee -a $FILE
		exit
	elif [ "$1" = "Xts version" ]
	then
		echo "NOT A GTS REPORT"												| tee -a $FILE
		exit
	elif [ "$1" = "verifier-info" ]
	then
		echo "NOT A Verifier REPORT"											| tee -a $FILE
		exit
	fi

fi
}

function CHECKGMSESSENTIALAPPS(){
echo ""																			| tee -a $FILE
cp "$1" $tempFile



ESSENTIALAPPS=(com.google.android.partnersetup
com.google.android.setupwizard
com.google.android.onetimeinitializer
com.google.android.gsf.login
com.google.android.gsf
#com.google.android.gms
com.google.android.feedback
com.google.android.backuptransport
com.google.android.packageinstaller)

contains_all_essential=true
echo "CHECKING GMS ESSENTIAL"																| tee -a $FILE
package="name=\""
flag="\""
#CGTS 4.0


for i in ${ESSENTIALAPPS[*]}
do
searchfor=$package$i$flag

	locationGTS_N=$newNGTSReportDir"PackageDeviceInfo.deviceinfo.json"
	if [ $newNGTSReport -ne 0 ]
	then
		if grep -qri $i  $locationGTS_N
		then
			echo -ne ""																			| tee -a $FILE
		else
			echo "	GMS ESSENTIAL package not found  new : $i"										| tee -a $FILE
			contains_all_essential=false
		fi
	else
		if grep -qri $searchfor $tempFile  && sed   -i '/'$searchfor'/d' "$tempFile"
		then
			echo -ne ""																			| tee -a $FILE
		else
			echo "	GMS ESSENTIAL package not found  old : $i"										| tee -a $FILE
			contains_all_essential=false
		fi
	fi


done

if $contains_all_essential != "false"
then
	echo "	Contains all GMS ESSENTIAL"													| tee -a $FILE
else
	echo "	GSM ESSENTIALS missing"  															| tee -a $FILE
fi
#if grep -qri "com.google.android." "$1" && grep -qrni "flag_system" "$1"
#then
#	grep -qri "com.google.android." "$1" | sed 's/*com./	com./' |sed 's/\" flag_sys.*/	/'
#else
#	echo -e ""
#fi


}

function MUSTGMS(){
echo ""																			| tee -a $FILE
MUST=(com.android.chrome
com.google.android.gms
com.google.android.googlequicksearchbox
com.google.android.apps.maps
com.google.android.youtube
com.android.vending
com.google.android.apps.docs
com.google.android.music
com.google.android.videos
com.google.android.talk
com.google.android.apps.photos
com.google.android.gm
com.google.android.tts
com.google.android.webview
com.google.android.apps.tachyon
#com.google.android.androidforwork
)

contains_all_must=true
echo "CHECKING GMS MUST APPS"																									| tee -a $FILE
#echo "	Please check geovailability for play apps ( movies, books)"																| tee -a $FILE

package="name=\""
flag="\""

for i in ${MUST[*]}
do
searchfor=$package$i$flag



locationGTS_N=$newNGTSReportDir"PackageDeviceInfo.deviceinfo.json"
	if [ $newNGTSReport -ne 0 ]
	then
		if grep -qri $i  $locationGTS_N
		then
			echo -ne ""																			| tee -a $FILE
		else
			echo "	GMS MUST package not found  : $i"										| tee -a $FILE
			contains_all_must=false
		fi
	else
		if grep -qri $searchfor $tempFile  && sed   -i '/'$searchfor'/d' "$tempFile"
		then
			echo -ne ""																			| tee -a $FILE
		else
			echo "	GMS MUST package not found  : $i"										| tee -a $FILE
			contains_all_must=false
		fi
	fi
done
if $contains_all_must != false
then
	echo "	Contains all GMS MUST"														| tee -a $FILE
else
echo "	MUST GMS missing"  																| tee -a $FILE
fi




}

function GOOGLELIBRRIES(){
cp "$1" $tempFile
echo ""																			| tee -a $FILE
LIBRARIES=(com.google.android.maps.jar
com.google.android.media.effects.jar
)

contains_lib=true
echo "CHECKING GOOGLE LIBRARIES"																									| tee -a $FILE

package="name=\""
flag="\""

for i in ${LIBRARIES[*]}
do
searchfor=$package$i$flag



	locationGTS_N=$newNGTSReportDir"LibraryDetailDeviceInfo.deviceinfo.json"
	if [ $newNGTSReport -ne 0 ]
	then
		if grep --include "*.json" -qri $i  $locationGTS_N
		then
			echo "	GMS Library package  found  : $i"										| tee -a $FILE
		else
			echo -ne ""
		fi
	else
		if grep -wqri $searchfor $tempFile  && sed   -i '/'$searchfor'/d' "$tempFile"

		then
			echo "	GMS Library package  found  : $i"																	| tee -a $FILE
		else
			echo -ne ""											| tee -a $FILE

		fi
	fi

done



}

function OPTIONALGMS(){
echo ""

OPTIONAL=(com.google.android.calendar
com.google.android.apps.plus
com.google.android.apps.books
com.google.android.play.games
com.google.android.apps.magazines
com.google.android.launcher
com.android.facelock
com.google.android.marvin.talkback
com.google.android.GoogleCamera
com.google.android.apps.docs.editors.docs
com.google.android.apps.docs.editors.sheets
com.google.android.apps.docs.editors.slides
com.google.android.apps.cloudprint
com.google.android.keep
com.google.android.apps.adm
com.google.android.apps.enterprise.dmagent
com.google.android.apps.translate
com.google.android.apps.messaging
com.google.android.apps.genie.geniewidget
com.google.android.apps.walletnfcrel
com.google.android.inputmethod.latin
com.google.android.apps.inputmethod.hindi
com.google.android.inputmethod.japanese
com.google.android.inputmethod.korean
com.google.android.inputmethod.pinyin
com.google.android.apps.inputmethod.zhuyin
com.google.android.apps.blogger
com.google.earth
com.google.android.street
com.google.android.apps.googlevoice
com.google.android.ears)

contains_optional=true
echo ""																			| tee -a $FILE
echo "CHECKING GMS OPTIONAL APPS"														| tee -a $FILE
echo "	Please check geovailability for play apps ( movies, books)"						| tee -a $FILE

package="name=\""
flag="\""

locationGTS_N=$newNGTSReportDir"PackageDeviceInfo.deviceinfo.json"
echo
for i in ${OPTIONAL[*]}
do
searchfor=$package$i$flag

	if [ $newNGTSReport -ne 0 ]
	then
		if grep -qri $i  $locationGTS_N
		then
			echo "	GMS OPTIONAL package  found  : $i"										| tee -a $FILE
		fi
	else
		if grep -wqri $searchfor $tempFile  && sed   -i '/'$searchfor'/d' "$tempFile"

		then
			echo "	GMS OPTIONAL package  found  : $i"										| tee -a $FILE

	fi

	fi
done


}

function containsAndroidForWork(){
#nned gts and verifier reports
package="name=\""
flag="\""
output="Contain android for WorK"
BYOD="BYOD test  present"
ManagedFeature="Managed user feature present"
storage_devices="storage_devices"
echo " "																								| tee -a $FILE
echo "****************************android for work ****************************" 							| tee -a $FILE

  if [ $newNGTSReport -ne 0 ]
  then
    if grep -wqri "BYOD" "$2"

    		then
    			echo $BYOD"			YES"												| tee -a $FILE
    		else
    			echo $BYOD"			NO"												| tee -a $FILE
    fi

  
managedUserReport=$newNCTSReportDir"FeatureDeviceInfo.deviceinfo.json"	
		 managedUsers=$(sed ':a;N;$!ba;s/\",\n/ /g' $managedUserReport | grep "android.software.managed_users " |sed 's/.*name\": \"//' |  sed 's/users.*available\":/users :/' |sed 's/,//' )
		#grep -ir "android.software.managed_users" "$3"  | sed 's/.*available="//'|  sed 's/\".*//'    | tee -a $FILE
    echo $ManagedFeature "=" $managedUsers													| tee -a $FILE
    #if [ "$managedUsers"="true true" ]
    #
    #		then
    #			echo $ManagedFeature"	        YES"												| tee -a $FILE
    #		else
    #			echo $ManagedFeature"	        NO"												| tee -a $FILE
    #fi


	storage_devices="storage_devices"
		locationCTS_N="./"$newNCTSReportDir"/StorageDeviceInfo.deviceinfo.json"
		emulated=$(grep -r "/storage/emulated" "$locationCTS_N"   )	
		echo $storage_devices"	"$emulated                                 								| tee -a $FILE



  else
    androidforwork_pacage=com.google.android.androidforwork
    searchfor=$package$androidforwork_pacage$flag

    if grep -wqri $searchfor "$1"

    		then
    			echo  $output "		YES"												| tee -a $FILE
    		else
    			echo  $output "		NO"										| tee -a $FILE

    fi
    if grep -wqri "BYOD" "$2"

    		then
    			echo $BYOD"			YES"												| tee -a $FILE
    		else
    			echo $BYOD"			NO"												| tee -a $FILE
    fi

    managedUsers=$(grep -ir "android.software.managed_users" "$3"  | sed 's/.*available="//'|  sed 's/\".*//')
    #grep -ir "android.software.managed_users" "$3"  | sed 's/.*available="//'|  sed 's/\".*//'    | tee -a $FILE
    echo $ManagedFeature "=" $managedUsers													| tee -a $FILE
    #if [ "$managedUsers"="true true" ]
    #
    #		then
    #			echo $ManagedFeature"	        YES"												| tee -a $FILE
    #		else
    #			echo $ManagedFeature"	        NO"												| tee -a $FILE
    #fi



    emulated=$(grep -ir "$storage_devices" "$3"  | sed 's/.*storage_devices="//'|  sed 's/\".*//')
    echo $storage_devices "=" $emulated                                 								| tee -a $FILE

  fi
}

CHECKGTS=1
CHECKCTSV=1
current_time=$(date "+%Y.%m.%d-%H.%M.%S")
FILE="report$current_time.log"
FILEFORSystem="report.log"
tempFile="temp.temp1"
#toolsFile =".toolsfile.txt"


CHECKCORRECTREPORT  "$FileName1"

if ["$FileName2" = ""]
then
echo "No retest"
CHECKCORRECTREPORT  "$FileName1"
else
echo "have retest"
CHECKCORRECTREPORT  "$FileName2"
fi

#if no GTS report we set CHECKGTS to 0 else stay at 1
if [ "$FileName3" = "" ]
then
echo  "NO GTS Report"                                                           				| tee -a $FILE
CHECKGTS=0
else
CHECKCORRECTREPORT  $FileName3
fi

#if no Verifier report we set CHECKGTS to 0 else stay at 1
if ["$FileName4" = ""]
then
echo  "NO CTS VERIFIER Report"                                                           				| tee -a $FILE
CHECKCTSV=0
else
CHECKCORRECTREPORT  "$FileName4"
fi

CTS "$FileName1"
if ["$FileName2" = ""]
then
	echo ""
else
RETEST_CTS "$FileName2"
fi

#if no GTS report we set CHECKGTS to 0 else stay at 1 so we
#if different than 1  there is no GTS report we so not check GTS
#if euals 1 then we check GTS
if [ $CHECKGTS -ne 1 ]
then
echo  "NO CTS GTS Report"                                                           				| tee -a $FILE
else
GTS "$FileName3"
fi

#if no VERIFIER report we set CHECKCTSV to 0 else stay at 1 so we
#if different than 1  there is no VERIFIER report we so not check VERIFIER
#if euals 1 then we check VERIFIER
if [ $CHECKCTSV -ne 1 ]
then
echo  "NO CTS VERIFIER Report"                                                           				| tee -a $FILE
else
VERIFIER "$FileName4"
#only if have the a cts full cts, gts and verifier can check android for work
#parameter  GTS,Verifier, CTS
containsAndroidForWork "$FileName3" "$FileName4"  "$FileName1"
fi


#check fingerprint
#parameter "$CTS_FINGERPRINT" "$CTS_RETEST_FINGERPRINT" "$GTS_FINGERPRINT" "$CTS_VERIFIER_FINGERPRINT" will fail for indivual test
echo " "															| tee -a $FILE
echo "**************************** Fingerprint ****************************" 							| tee -a $FILE
if  [ $CHECKCTSV -ne 1 ] || [ $CHECKCTSV -ne 1 ]
then
echo  "Single report check"                                                           				| tee -a $FILE
else
	echo "cts :" $CTS_FINGERPRINT
	echo "cts retest:" $CTS_RETEST_FINGERPRINT
	echo "gts :" $GTS_FINGERPRINT
	echo "ctsv :" $CTS_VERIFIER_FINGERPRINT

COMPAREFINGERPRINT  "$CTS_FINGERPRINT" "$CTS_RETEST_FINGERPRINT" "$GTS_FINGERPRINT" "$CTS_VERIFIER_FINGERPRINT"
fi



cp $FILE $FILEFORSystem

######################
# Check Report end   #
######################
