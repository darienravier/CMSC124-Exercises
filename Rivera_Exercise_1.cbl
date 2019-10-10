        IDENTIFICATION DIVISION.
        PROGRAM-ID. sample.

        DATA DIVISION.
        WORKING-STORAGE SECTION.
            77 EXITED PIC 9 VALUE 0.
            77 CHOICE PIC 9.
      *     All of iteration in this exercise will start with 1
      *     As COBOL always start with the index of 1
            77 I PIC 9 VALUE 1.
            77 SEARCHER PIC 9 VALUE 1.
            77 SEARCHERPLUSONE PIC 9 VALUE 2.
            77 FOUNDSTUDENT PIC 9 VALUE 0.
            77 SUBJSEARCHER PIC 9 VALUE 1.
      *     This is an array for students
            01 students.
             02 student OCCURS 10 TIMES.
              03 surname PIC X(20).
              03 firstname PIC X(30).
              03 sNum PIC X(10).
              03 subjects.
               04 subject OCCURS 5 TIMES.
                05 csection PIC X(5).
                05 coursecode PIC X(10).
              03 numSubjects PIC 9 VALUE 0.
      *     Additional Variables
            77 sNumSearch PIC X(10).
            77 numOfStudents PIC 9 VALUE 0.

        PROCEDURE DIVISION.
            PERFORM MENU UNTIL EXITED = 1.
            STOP RUN.
            
            ADDSTUDENT.
             DISPLAY "You will add a student".
             DISPLAY "First Name: " WITH NO ADVANCING.
             ACCEPT firstname(I).
             DISPLAY "Last Name: " WITH NO ADVANCING.
             ACCEPT surname(I).
             DISPLAY "Student Number: " WITH NO ADVANCING.
             ACCEPT sNum(I).
      *      Test Display       
             DISPLAY "Fname: " WITH NO ADVANCING.
             DISPLAY firstname(I).
             ADD 1 TO I GIVING I.
             ADD 1 TO numOfStudents GIVING numOfStudents.
            
      *     Edit Student's Data
            EDITSTUDENT.
             DISPLAY "You will edit".
             DISPLAY "Search -> Student Number:".
             ACCEPT sNumSearch.
             MOVE 1 TO SEARCHER.
             PERFORM STUDNUMSEARCH.
      *      If Student is Found       
             IF FOUNDSTUDENT = 1
              DISPLAY "First Name: " WITH NO ADVANCING
              ACCEPT firstname(SEARCHER)
              DISPLAY "Last Name: " WITH NO ADVANCING
              ACCEPT surname(SEARCHER)
      *       Test Display       
              DISPLAY "Fname: " WITH NO ADVANCING
              DISPLAY firstname(SEARCHER)
             ELSE
              DISPLAY "ERROR! Student not found!"
             END-IF.

      *     Delete Student
            DELETESTUDENT.
             DISPLAY "You will delete a student".
             DISPLAY "Search -> Student Number:".
             ACCEPT sNumSearch.
             MOVE 1 TO SEARCHER.
             PERFORM STUDNUMSEARCH.
      *      If Student is Found       
             IF FOUNDSTUDENT = 1
              PERFORM DELETER
             ELSE
              DISPLAY "ERROR! Student not found!"
             END-IF.
            
            DELETER.
             ADD 1 TO SEARCHER GIVING SEARCHERPLUSONE.
             IF SEARCHER = numOfStudents
      *      If there is only one student
              SUBTRACT 1 FROM I GIVING I
              SUBTRACT 1 FROM numOfStudents GIVING numOfStudents
             ELSE
              IF SEARCHER NOT = I
               MOVE firstname(SEARCHERPLUSONE) TO firstname(SEARCHER)
               MOVE surname(SEARCHERPLUSONE) TO surname(SEARCHER)
               MOVE sNum(SEARCHERPLUSONE) TO sNum(SEARCHER)
               ADD 1 TO SEARCHER GIVING SEARCHER
               ADD 1 TO SEARCHERPLUSONE GIVING SEARCHERPLUSONE
               PERFORM DELETER
              ELSE
               SUBTRACT 1 FROM I GIVING I
               SUBTRACT 1 FROM numOfStudents GIVING numOfStudents
              END-IF
             END-IF. 
            
            ADDSUBJECT.
             DISPLAY "You will add a subject to a student".
             DISPLAY "Search -> Student Number:".
             ACCEPT sNumSearch.
             MOVE 1 TO SEARCHER.
             PERFORM STUDNUMSEARCH.
      *      If Student is Found       
             IF FOUNDSTUDENT = 1
      *      If numSubjects is not yet equal to 6 which means
      *      subjects are not yet full for student       
              IF numSubjects(SEARCHER) NOT = 6
               DISPLAY "Course Code: " WITH NO ADVANCING
               ACCEPT coursecode(SEARCHER, numSubjects(SEARCHER))
               DISPLAY "Course Section: " WITH NO ADVANCING
               ACCEPT csection(SEARCHER, numSubjects(SEARCHER))
      *       Student has 5 subjects already         
              ELSE
               DISPLAY "ERROR! Student has full load!"
              END-IF
             ELSE
              DISPLAY "ERROR! Student not found!"
             END-IF.
            
            VIEWALL.
             IF numOfStudents = 0
              DISPLAY "There are no students!"
             ELSE
              IF SEARCHER NOT = I
      *         DISPLAY "I" WITH NO ADVANCING
      *         DISPLAY I
               DISPLAY "Firstname: " WITH NO ADVANCING
               DISPLAY firstname(SEARCHER)
               DISPLAY "Surname: " WITH NO ADVANCING
               DISPLAY surname(SEARCHER)
               DISPLAY "Student Number: " WITH NO ADVANCING
               DISPLAY sNum(SEARCHER)
               ADD 1 TO SEARCHER GIVING SEARCHER
               PERFORM VIEWALL
              ELSE
               DISPLAY " "
              END-IF. 

            VIEWONE.
             DISPLAY "Search -> Student Number: ".
             ACCEPT sNumSearch.
             MOVE 1 TO SEARCHER.
             PERFORM STUDNUMSEARCH.
             IF FOUNDSTUDENT = 1
              DISPLAY "First Name: " WITH NO ADVANCING
              DISPLAY firstname(SEARCHER)
              DISPLAY "Last Name: " WITH NO ADVANCING
              DISPLAY surname(SEARCHER)
              DISPLAY "Student Number: " WITH NO ADVANCING
              DISPLAY sNum(SEARCHER)
              DISPLAY "Number of Subjects Taken: " WITH NO ADVANCING
              DISPLAY numSubjects(SEARCHER)
             ELSE
              DISPLAY "ERROR! Student Not Found!"
             END-IF.  

            PRINTSUBJECTS.
      *      If the iterator is equal to number of subjects stop function
             IF numSubjects(SEARCHER) = 0
              DISPLAY "This student has no subjects!"
             ELSE      
              IF SUBJSEARCHER = numSubjects(SEARCHER)
               DISPLAY "~~~~~~~~"
              ELSE
               DISPLAY "Course Code: " WITH NO ADVANCING
               DISPLAY coursecode(SEARCHER, numSubjects(SEARCHER))
               DISPLAY "Course Section" WITH NO ADVANCING
               DISPLAY csection(SEARCHER, numSubjects(SEARCHER))
               ADD 1 TO SUBJSEARCHER GIVING SUBJSEARCHER
               PERFORM PRINTSUBJECTS
              END-IF
             END-IF. 

            STUDNUMSEARCH.
      *      If sNumSearch is NOT EQUAL to sNum(index) then add 1 to
      *      SEARCHER VARIABLE
      *      To reset the variable SEARCHER and FOUNDSTUDENT
      *       MOVE 1 TO SEARCHER.
             MOVE 0 TO FOUNDSTUDENT.
             IF numOfStudents = 0
              DISPLAY "There are no students!"
              MOVE 0 TO FOUNDSTUDENT
             ELSE
              IF sNumSearch = sNum(SEARCHER)
      *        Student Found!       
               MOVE 1 TO FOUNDSTUDENT        
              ELSE
               IF SEARCHER NOT = I
                ADD 1 TO SEARCHER GIVING SEARCHER
                PERFORM STUDNUMSEARCH
               ELSE
                MOVE 0 TO FOUNDSTUDENT
               END-IF
              END-IF  
             END-IF.
      *      SEARCHER will maintain data for the other functions to read

            MENU.
             DISPLAY "<Current Number of Students: " WITH NO ADVANCING.
             DISPLAY numOfStudents WITH NO ADVANCING.
             DISPLAY ">".
             DISPLAY "~MENU~".
             DISPLAY "[1] Add Student ".
             DISPLAY "[2] Add Subject To Student ".
             DISPLAY "[3] Edit Student".
             DISPLAY "[4] Delete Student".
             DISPLAY "[5] View Info on One Student".
             DISPLAY "[6] View Info on All Students".
             DISPLAY "[7] Exit".
             DISPLAY " Choice : " WITH NO ADVANCING.
             ACCEPT CHOICE.
   
            IF CHOICE = 1
             IF numOfStudents NOT = 10
              PERFORM ADDSTUDENT
              DISPLAY "ADDSTUDENT"
             ELSE
              DISPLAY "ERROR! Record is Full!"
             END-IF
            ELSE    
             IF CHOICE = 2
              PERFORM ADDSUBJECT
              DISPLAY "ADDSUBJECT"
             ELSE
              IF CHOICE = 3    
               PERFORM EDITSTUDENT
              ELSE
               IF CHOICE = 4
                PERFORM DELETESTUDENT
               ELSE
                IF CHOICE = 5
                 DISPLAY "You will view info one student"
                 PERFORM VIEWONE
                ELSE
                 IF CHOICE = 6
                  DISPLAY "You will view all students"
                  MOVE 1 TO SEARCHER
                  PERFORM VIEWALL
                 ELSE 
                  MOVE 1 TO EXITED
                 END-IF 
                END-IF
               END-IF
              END-IF
             END-IF
            END-IF.
