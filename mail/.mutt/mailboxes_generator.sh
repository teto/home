 #!/bin/sh
#http://dev.mutt.org/trac/wiki/MuttFaq/Maildir
 
 #mailboxes + `\\

 for file in ~/.maildir/.*; do \\

   box=$(basename "$file"); \\

   if [ ! "$box" = '.' -a ! "$box" = '..' -a ! "$box" = '.customflags' \\

       -a ! "$box" = '.subscriptions' ]; then \\

     echo -n "\"+$box\" "; \\

   fi; \\

done; \\

 for folder in ~/.maildir/*; do \\

   if [ -x $folder]; then \\
   
         box=$(basename "$folder"); \\

         for file in ~/.maildir/$box/.*; do \\

                box2=$(basename "$file"); \\

                if [ ! "$box2" = '.' -a ! "$box2" = '..' -a ! "$box2" = '.customflags' \\

                 -a ! "$box2" = '.subscriptions' ]; then \\

                   echo -n "\"+$box/$box2\" "; \\

                fi; \\

         done; \\

    fi; \\

  done`

