/**************************** REXX *********************************/
/* This exec illustrates the use of "EXECIO 0 ..." to open, empty, */
/* or close a file. It reads records from file indd, allocated     */
/* to 'sams.input.dataset', and writes selected records to file    */
/* outdd, allocated to 'sams.output.dataset'. In this example, the */
/* data set 'smas.input.dataset' contains variable-length records  */
/* (RECFM = VB).                                                   */
/*******************************************************************/
"FREE FI(outdd)"
"FREE FI(indd)"
"ALLOC FI(indd) DA('MTM2020.PUBLIC.CUST16') SHR REUSE"
"ALLOC FI(outdd) DA('Z05216.OUTPUT(CUST16)') SHR REUSE"
eofflag = 2                 /* Return code to indicate end-of-file */
return_code = 0                /* Initialize return code           */
in_ctr = 0                     /* Initialize # of lines read       */
out_ctr = 0                    /* Initialize # of lines written    */

/*******************************************************************/
/* Open the indd file, but do not read any records yet.  All       */
/* records will be read and processed within the loop body.        */
/*******************************************************************/

"EXECIO 0 DISKR indd (OPEN"   /* Open indd                         */

/*******************************************************************/
/* Now read all lines from indd, starting at line 1, and copy      */
/* selected lines to outdd.                                        */
/*******************************************************************/



DO WHILE (return_code \= eofflag) /* Loop while not end-of-file   */
    'EXECIO 1 DISKR indd'           /* Read 1 line to the data stack */
    return_code = rc                /* Save execio rc                */
    IF return_code = 0 THEN         /* Get a line ok?                */
        DO                             /* Yes                           */
            in_ctr = in_ctr + 1         /* Increment input line ctr      */
            PARSE PULL line.1           /* Pull line just read from stack*/
            IF LENGTH(line.1) > 10 then /* If line longer than 10 chars  */
                DO
                    "EXECIO 1 DISKW outdd (STEM line." /* Write it to outdd   */
                    cc_digits = SUBSTR(line.1,3,19)
                    IF luhn(cc_digits) \= 0 then
                        say cc_digits
                End
                    out_ctr = out_ctr + 1        /* Increment output line ctr */
        END
END

luhn:
Parse ARG cc_digits
    checksum = 0
    DO I=1 to LENGTH(cc_digits)
        current_char_digit = SUBSTR(cc_digits, I, 1)
        even_digits = current_char_digit//2
        If even_digits \= 0 then
            checksum = checksum + current_char_digit
        Else
            checksum = checksum + current_char_digit * 2
    End
RETURN checksum//10

"EXECIO 0 DISKR indd (FINIS"   /* Close the input file, indd   */
IF out_ctr > 0 THEN             /* Were any lines written to outdd?*/
  DO                               /* Yes.  So outdd is now open   */
     /****************************************************************/
   /* Since the outdd file is already open at this point, the      */
   /* following "EXECIO 0 DISKW ..." command will close the file,  */
   /* but will not empty it of the lines that have already been    */
   /* written. The data set allocated to outdd will contain out_ctr*/
   /* lines.                                                       */
   /****************************************************************/

  "EXECIO 0 DISKW outdd (FINIS" /* Closes the open file, outdd     */
  SAY 'File outdd now contains ' out_ctr' lines.'
END
ELSE                         /* Else no new lines have been        */
                             /* written to file outdd              */
  DO                         /* Erase any old records from the file*/

   /****************************************************************/
   /* Since the outdd file is still closed at this point, the      */
   /* following "EXECIO 0 DISKW " command will open the file,   */
   /* write 0 records, and then close it.  This will effectively   */
   /* empty the data set allocated to outdd.  Any old records that */
   /* were in this data set when this exec started will now be     */
   /* deleted.                                                     */
   /****************************************************************/

   "EXECIO 0 DISKW outdd (OPEN FINIS"  /*Empty the outdd file      */
   SAY 'File outdd is now empty.'
   END
"FREE FI(indd)"
"FREE FI(outdd)"
EXIT

