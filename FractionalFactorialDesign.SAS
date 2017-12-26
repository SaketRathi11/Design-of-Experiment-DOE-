data filter;
input A B C D y;
datalines; 
-1 -1 -1 -1 90
1 -1 -1 -1 74
-1 1 -1 -1 81
1 1 -1 -1 83
-1 -1 1 -1 77
1 -1 1 -1 81
-1 1 1 -1 88
1 1 1 -1 73
-1 -1 -1 1 98
1 -1 -1 1 72
-1 1 -1 1 87
1 1 -1 1 85
-1 -1 1 1 99
1 -1 1 1 79
-1 1 1 1 87
1 1 1 1 80
-1 -1 -1 -1 93
1 -1 -1 -1 78
-1 1 -1 -1 85
1 1 -1 -1 80
-1 -1 1 -1 78
1 -1 1 -1 80
-1 1 1 -1 82
1 1 1 -1 70
-1 -1 -1 1 95
1 -1 -1 1 76
-1 1 -1 1 83
1 1 -1 1 86
-1 -1 1 1 90
1 -1 1 1 75
-1 1 1 1 84
1 1 1 1 80
;

data inter;
    set filter;
    AB=A*B;
    AC=A*C;
    AD=A*D;
    BC=B*C;
    BD=B*D;
    CD=C*D;
    ABC=AB*C;
    ABD=AB*D;
    ACD=AC*D;
    BCD=BC*D;
    ABCD=ABC*D;
run;


proc print data=inter;
proc glm data =inter;
 class A B C D AB AC AD BC BD CD ABC ABD ACD BCD ABCD;
 model y=A B C D AB AC AD BC BD CD ABC ABD ACD BCD ABCD; 
/*model y=A B|C|D;*/
output out=botone r=res p=pred;
run;





estimate 'A' A 1 -1 ;
estimate 'B' B 1 -1 ;
estimate 'C' C 1 -1 ;
estimate 'D' D 1 -1 ;
estimate 'AC' AC 1 -1 ;
estimate 'AB' AB 1 -1 ;
estimate 'AD' AD 1 -1 ;
estimate 'BC' BC 1 -1 ;
estimate 'BD' BD 1 -1 ;
estimate 'CD' CD 1 -1 ;
estimate 'ABC' ABC 1 -1 ;
estimate 'ABD' ABD 1 -1 ;
estimate 'BCD' BCD 1 -1 ;
estimate 'ACD' ACD 1 -1 ;
estimate 'ABCD' ABCD 1 -1 ;










goption colors=(none);
data filter;
do C = -1 to 1 by 2;
do B = -1 to 1 by 2;do A = -1 to 1 by 2; D=A*B*C;
input y @@; output; end; end; end;
datalines;
90 72 87 83 99 81 88 80
;
data inter; /* Define Interaction Terms */
set filter;
AB=A*B; 
AC=A*C; 
AD=A*D;

proc glm data=inter; /* GLM Proc to Obtain Effects */
class A B C D AB AC AD;
model y=A B C D;
run;

estimate 'A' A -1 1; 
estimate 'B' B -1 1; 
estimate 'C' C -1 1;
estimate 'D' D -1 1; 
estimate 'AB' AB -1 1;
/*estimate 'AC' AC -1 1;*/
estimate 'AD' AD -1 1;


/*Q2*/
goption colors=(none);
data filter;
do C = -1 to 1 by 2;
do B = -1 to 1 by 2;
do A = -1 to 1 by 2;
D=A*B;
E=B*C;
input y @@; 
output;
end;
end; 
end;
datalines;
6 12 34 50 18 20 45 63
;
data inter; /* Define Interaction Terms */
set filter;
AC=A*C;
DC= D*C;
proc glm data=inter; /* GLM Proc to Obtain Effects */
class A B C D E AC DC;
model y=A B C D E AC DC;
 run;
