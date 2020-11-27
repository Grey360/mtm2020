/**************************** REXX *********************************/
/* This exec illustrates the use of "EXECIO 0 ..." to open, empty, */
/* or close a file. It reads records from file indd, allocated     */
/* to 'sams.input.dataset', and writes selected records to file    */
/* outdd, allocated to 'sams.output.dataset'. In this example, the */
/* data set 'smas.input.dataset' contains variable-length records  */
/* (RECFM = VB).                                                   */
/*******************************************************************/

"FREE FI(outdd)"
/* Allocate */
"ALLOC FI(outdd) DA('Z05216.OUTPUT(CUST16)') OLD REUSE"
/* Open the file */
"EXECIO 0 DISKW outdd (OPEN"

occ = 0
DO WHILE (occ < 501)
    rand_one = RANDOM(1000,9999)
    rand_two = RANDOM(1000,9999)
    rand_three = RANDOM(1000,9999)
    rand_four = RANDOM(100,999)    
    left = rand_one''rand_two''rand_three''rand_four
    check = luhn_checksum(left)
    cc_digits = left''check
    SAY cc_digits' is being tested...'
    IF luhn_caclulate(cc_digits) = 0 then
        DO
            line.occ = cc_digits'0'
            occ = occ + 1
        End
END

IF occ = 501 THEN
    DO
        res = occ-1
        "EXECIO "res"  DISKW outdd (STEM line."
        If rc = 0 then
            DO
                /* Close the file  */
                "EXECIO 0 DISKW outdd (FINIS"
                If rc = 0 then
                    SAY 'File outdd now contains ' res' lines.'
            ENd
    END
ELSE
  DO
        "EXECIO 0 DISKW outdd (OPEN FINIS"
        SAY 'File outdd is now empty.'
   END
"FREE FI(outdd)"
EXIT

luhn_caclulate:
Parse ARG partcode
    result = 0
    checksum = luhn_checksum(partcode)
    If checksum \= 0 then
        result = 10 - checksum
RETURN result

luhn_checksum:
Parse ARG cc_digits
    len = LENGTH(cc_digits)
    parity = len // 2
    sum = 0
    DO I=1 to LENGTH(cc_digits)
        d = SUBSTR(cc_digits, I, 1)
        If I // 2 = parity then
            d = d * 2
        IF d > 9 then
            d = d - 9
        sum = sum + d
    End
RETURN sum//10