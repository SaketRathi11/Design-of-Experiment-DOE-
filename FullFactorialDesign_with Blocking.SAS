goption colors=(none);
data filter;
do C = -1 to 1 by 2;
do B = -1 to 1 by 2;
do A = -1 to 1 by 2; 
input y @@; 
output; 
end;
end; 
end;
datalines;
45 100 45 65 75 60 80 96
;

Proc print data=filter;


goption colors=(none);
data New;
do C = -1 to 1 by 2;
do B = -1 to 1 by 2;
do A = -1 to 1 by 2; 
input R@@ ; 
output; 
end;
end; 
end;
datalines;
22 31 25 32 43 29 35 34 
;

do C = -1 to 1 by 2;
do B = -1 to 1 by 2;
do A = -1 to 1 by 2; 
input R@@ ; 
output; 
end;
end; 
end;
datalines;
22 31 25 32 43 29 35 34 
;

Proc print data=New;

50 55 47 46 44 45 38 40 37 36 60 50 54 39 41 47
proc glm data=New;
  class A B C;
  model resp=row col trt greek;
  means trt/ tukey lines;
  run;
  
  
data filter;
input A B C devi;
datalines; 
-1 -1 -1 22
-1 -1 -1 31
-1 -1 -1 25
+1 -1 -1 32
+1 -1 -1 43
+1 -1 -1 29
-1 +1 -1 35
-1 +1 -1 34
-1 +1 -1 50
+1 +1 -1 55
+1 +1 -1 47
+1 +1 -1 46
-1 -1 +1 44
-1 -1 +1 45
-1 -1 +1 38
+1 -1 +1 40
+1 -1 +1 37
+1 -1 +1 36
-1 +1 +1 60
-1 +1 +1 50
-1 +1 +1 54
+1 +1 +1 39
+1 +1 +1 41
+1 +1 +1 47
;

proc print data=filter;
proc glm data =filter;
class A B C; 
model devi=A|B|C;
output out=botone r=res p=pred;
run;



data filter;
input A B C devi block;
datalines; 
-1 -1 -1 22 1
-1 -1 -1 31 2
-1 -1 -1 25 3
+1 -1 -1 32 1
+1 -1 -1 43 2
+1 -1 -1 29 3
-1 +1 -1 35 1
-1 +1 -1 34 2
-1 +1 -1 50 3
+1 +1 -1 55 1
+1 +1 -1 47 2 
+1 +1 -1 46 3
-1 -1 +1 44 1
-1 -1 +1 45 2
-1 -1 +1 38 3
+1 -1 +1 40 1
+1 -1 +1 37 2
+1 -1 +1 36 3
-1 +1 +1 60 1
-1 +1 +1 50 2
-1 +1 +1 54 3
+1 +1 +1 39 1
+1 +1 +1 41 2
+1 +1 +1 47 3
;

proc print data=filter;
proc glm data =filter;
class A B C block; 
model devi=A|B|C block;
output out=botone r=res p=pred;
run;