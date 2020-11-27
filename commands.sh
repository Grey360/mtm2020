# Lists in a Dataset
zowe files list ds Z05216.DATA --rto 30

# Upload a file to a the binary Dataset
zowe files ul ftds xdata Z05216.DATA --rto 30
#success: true
#from:    /Users/ultron/Documents/Projects/IBM/MasterTheMainframe/cobol-programming-course/COBOL Programming Course #1 - Getting Started/Labs/data/xdata
#to:      Z05216.DATA(XDATA)


#file_to_upload: 1
#success:        1
#error:          0
#skipped:        0


#Data set uploaded successfully.

# ZCLI1.pdf
# 9. FULLY CUSTOMIZED

# 0) Delete the file.
zowe files del ds Z05216.ZOWEPS -f --rto 30

# 1) ################## Custom Dataset for MtM 2020 Lv III ##################
# v0 [CANNOT END THE COURSE] -v VPZRKB 
zowe files create ps Z05216.ZOWEPS --bs 9600 --rl 120 --rto 30
# v1 [IN TESTING: Output matches the one in the exercise description]
zowe files create ps Z05216.ZOWEPS --bs 9600 --rl 120 --rto 30 --sz 15 --rf FB
# Display info on the Dataset
zowe files list ds Z05216.ZOWEPS -a --rto 30

# ZCLI1.pdf
# 11. BUILD A VSAM DATA SET

# DELETE VSAM Dataset then
# VSAM Dataset on volume VPWRKC && Show the 3 data sets it contains
zowe files del vsam Z05216.VSAMDS -f --rto 30 \
&& zowe files create vsam Z05216.VSAMDS -v VPWRKC --rto 30 \
&& zowe files ls ds Z05216.VSAMDS --rto 30
#Data set created successfully.
#Z05216.VSAMDS
#Z05216.VSAMDS.DATA
#Z05216.VSAMDS.INDEX

# 12. LOAD IT UP WITH RECORDS
zowe jobs submit lf "repro.txt" --wfo
#jobid:   JOB01947
#retcode: CC 0000
#jobname: REPRO2
#status:  OUTPUT

# View job details
zowe jobs vw jsbj JOB01547
# View job'spool file
zowe jobs vw sfbi JOB01547 1

# 15. MAKE IT COUNT
zowe files del vsam Z05216.VSAMDS -f --rto 30 \
&& zowe files create vsam Z05216.VSAMDS -v VPWRKC --rto 30 \
&& zowe files ls ds Z05216.VSAMDS --rto 30 \
&& zowe jobs submit lf "repro.txt" --wfo \
&& zowe files create data-set-sequential Z05216.OUTPUT.VSAMPRNT --rto 30
#To complete this, we’re looking for 3 things:
#1) Your ZXXXXX.ZOWEPS sequential data set
#2) Your ZXXXXX.VSAMDS VSAM data set
#3) The first 20 lines of output from your PRINT copy/pasted into
#a sequential ZXXXXX.OUTPUT.VSAMPRNT data set. Don't
#write this data set directly from your JCL, use SYSPRINT, and
#copy/paste lines 1-20 of your SYSPRINT. We need the header.
#Refer to the screenshot above as a (lightly redacted) example.
#When done, submit CHK3. We're in CHK3 territory

# SOLUTION
zowe files create data-set-sequential Z05216.OUTPUT.VSAMPRNT --rto 30
ultron@Gailors-MacBook-Pro Exercises % zowe files del vsam Z05216.VSAMDS -f --rto 30 \
&& zowe files create vsam Z05216.VSAMDS -v VPWRKC --rto 30 \
&& zowe files ls ds Z05216.VSAMDS --rto 30
Data set deleted successfully.
Data set created successfully.
#Z05216.VSAMDS
#Z05216.VSAMDS.DATA
#Z05216.VSAMDS.INDEX
ultron@Gailors-MacBook-Pro Exercises % zowe jobs submit lf "repro.txt" --wfo          
#jobid:   JOB02573
#retcode: CC 0000
#jobname: REPRO2
#status:  OUTPUT
ultron@Gailors-MacBook-Pro Exercises % zowe jobs submit lf "print.txt" --wfo     
#jobid:   JOB02574
#retcode: CC 0000
#jobname: PRINT2
#status:  OUTPUT

# Run some REXX
zowe tso issue command "exec 'z05216.source(somerexx)'" --ssm

# Start an address space with the following command:
zowe tso start as

# Run REXX directed to the previously created address space
zowe tso send as Z05216-244-aadwaaag --data "exec 'z05216.source(somerexx)'"

# Run GUESSNUM in the previously created address space
zowe tso send as Z05216-244-aadwaaag --data "exec 'z05216.source(guessnum)'"

# Try and guess the number
zowe tso send as Z05216-244-aadwaaag --data "25"


# REXX2.pdf
# 4. ENOUGH TALK. LET’S RUN
zowe files create data-set-sequential Z05216.OUTPUT.CUSTOMER --rto 30
# 5. CHECK THE OUTPUT
zowe tso issue command "exec 'Z05216.SOURCE(CCVIEW)'" --ssm
IKJ56247I FILE OUTDD NOT FREED, IS NOT ALLOCATED
IKJ56247I FILE INDD NOT FREED, IS NOT ALLOCATED
File outdd now contains  1500 lines.
READY

# 6. ENHANCE. ENHANCE.